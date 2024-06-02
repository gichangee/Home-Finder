package com.ssafy.member.controller;

import java.sql.SQLException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.ssafy.member.model.MemberDto;
import com.ssafy.member.model.service.MemberService;
import com.ssafy.util.JWTUtil;

import io.swagger.v3.oas.annotations.Parameter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RequestMapping("/user")
@RestController
public class MemberController {
	
	private final JWTUtil jwtUtil;
	private final MemberService memberService;

	public MemberController(MemberService memberService,JWTUtil jwtUtil) {
		super();
		this.memberService = memberService;
		this.jwtUtil = jwtUtil;
	}
	
	
	// ------------------ 회원 가입 --------------------------------
	@PostMapping("/join")
	public  ResponseEntity<Map<String, Object>> join(@RequestBody Map<String, String> map)throws Exception {
		System.out.println("join");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpStatus status = HttpStatus.ACCEPTED;
		try {
			memberService.join(map);
			status = HttpStatus.CREATED;
		}
		catch (Exception e) {
			resultMap.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}
	
	// ------------------ 회원 정보 수정  --------------------------------
	@PatchMapping("/edit")
	public ResponseEntity<Map<String, Object>> mypage(@RequestBody Map<String, String> map) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpStatus status = HttpStatus.ACCEPTED;
		try {
			memberService.editUserInfo(map);	
		} catch (Exception e) {
			resultMap.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}
	
	
	// ------------------ 비밀번호 찾기  --------------------------------
	@PostMapping("/findpassword")
	public String findPassword(@RequestParam Map<String, String> map, HttpSession session) throws SQLException {
		String password=null;
		boolean notMatch = false;	//해당 계정이 있는지 체크
		try {
			password = memberService.findPassword(map);
			session.setAttribute("isFind", true);	//비밀번호 찾기를 시도한 적 있는지 체크
			if(password!=null) {
				session.setAttribute("user_id", map.get("user_id"));
				session.setAttribute("findPassword", password);
			}
			else {
				 notMatch = true;
				 session.setAttribute("findPassword", null);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("result : "+ password);
		session.setAttribute("notMatch", notMatch);
		return "user/findpassword";
	}
	
	
	
	
	// ------------아이디 유효성 검사  --------------------------------
	@GetMapping("/confirmuserid/{userid}")
	public ResponseEntity<Map<String,Object>> confirmUserId(@PathVariable ("userid") String user_id){
		Map<String,Object> resultMap =new HashMap<String, Object>();
		HttpStatus status = HttpStatus.ACCEPTED;
		try {
			boolean result = memberService.confirmUserId(user_id);
			resultMap.put("result", result);
			status = HttpStatus.OK;
		}catch (Exception e) {
			resultMap.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}
	
	
	
	//-----------------로그인  --------------------------------
	@PostMapping("/login")
	public ResponseEntity<Map<String, Object>> login(
			@RequestBody Map<String, String> credentials) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpStatus status = HttpStatus.ACCEPTED;
		try {
			MemberDto loginUser = memberService.login(credentials);
			if(loginUser != null) {
				String accessToken = jwtUtil.createAccessToken(loginUser.getUser_id());
				String refreshToken = jwtUtil.createRefreshToken(loginUser.getUser_id());
//				발급받은 refresh token 을 DB에 저장.
				memberService.saveRefreshToken(loginUser.getUser_id(), refreshToken);
				
//				JSON 으로 token 전달.
				resultMap.put("access-token", accessToken);
				resultMap.put("refresh-token", refreshToken);
				
				status = HttpStatus.CREATED;
			} else {
				resultMap.put("message", "아이디 또는 패스워드를 확인해 주세요.");
				status = HttpStatus.UNAUTHORIZED;
			} 
			
		} catch (Exception e) {
			resultMap.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}
	
	
	
	// ----------------- 이메일 유효성 검사  --------------------------------
	
	@GetMapping("/emailcofirm")
	public ResponseEntity<Map<String, Object>> emailCofirm(
			  @RequestParam String email_domain,
	            @RequestParam String email_id) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpStatus status = HttpStatus.ACCEPTED;
		Map<String,String> email = new HashMap<String,String>();
		email.put("email_id", email_id);
		email.put("email_domain", email_domain);
		try {
			boolean result = memberService.emailCofirm(email);
			System.out.println(result);
			if(result) {
				resultMap.put("result", true);
			}
			//사용불가능한 이메일임
			else {
				resultMap.put("result", false);
			}
		} catch (Exception e) {
			resultMap.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}
	
	
	
	//  ------------ 회원 정보 가져오기  --------------------------------
	@GetMapping("/info/{userId}")
	public ResponseEntity<Map<String, Object>> getInfo(
			@PathVariable("userId") @Parameter(description = "인증할 회원의 아이디.", required = true) String userId,
			HttpServletRequest request) {
//		logger.debug("userId : {} ", userId);
		Map<String, Object> resultMap = new HashMap<>();
		HttpStatus status = HttpStatus.ACCEPTED;
		if (jwtUtil.checkToken(request.getHeader("Authorization"))) {
			try {
//				로그인 사용자 정보.
				MemberDto memberDto = memberService.userInfo(userId);
				resultMap.put("userInfo", memberDto);
				status = HttpStatus.OK;
			} catch (Exception e) {
				resultMap.put("message", e.getMessage());
				status = HttpStatus.INTERNAL_SERVER_ERROR;
			}
		} else {
			status = HttpStatus.UNAUTHORIZED;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}

	
	
	// ------------------ 로그아웃  --------------------------------
	@GetMapping("/logout/{userId}")
	public ResponseEntity<?> removeToken(@PathVariable ("userId") @Parameter(description = "로그아웃 할 회원의 아이디.", required = true) String userId) {
		Map<String, Object> resultMap = new HashMap<>();
		HttpStatus status = HttpStatus.ACCEPTED;
		try {
			memberService.deleRefreshToken(userId);
			status = HttpStatus.OK;
		} catch (Exception e) {
			resultMap.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}

	
	// --------------- 리프레시 토큰  --------------------------------
	@PostMapping("/refresh")
	public ResponseEntity<?> refreshToken(@RequestBody MemberDto memberDto, HttpServletRequest request)
			throws Exception {
		Map<String, Object> resultMap = new HashMap<>();
		HttpStatus status = HttpStatus.ACCEPTED;
		String token = request.getHeader("refreshToken");
		if (jwtUtil.checkToken(token)) {
			if (token.equals(memberService.getRefreshToken(memberDto.getUser_id()))) {
				String accessToken = jwtUtil.createAccessToken(memberDto.getUser_id());
				resultMap.put("access-token", accessToken);
				status = HttpStatus.CREATED;
			}
		} else {
			status = HttpStatus.UNAUTHORIZED;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}
	
	
	//--------------- 비밀번호 확인  --------------------------------
	//헤더 값 가져오는 법
	// 함수 매개변수 - HttpServletRequest httpRequest
	// String token = httpRequest.getHeader("Authorization").substring(7); // Remove "Bearer " prefix
	@PostMapping("/passwordconfirm")
	public ResponseEntity<Void> passwordConfirm(@RequestBody Map<String, String> map) throws Exception {
	  boolean match = memberService.isMatchPassword(map);
	  if (match) {
	    memberService.setForeignKeyToNull(map.get("user_id"));
	    memberService.deleteMember(map.get("user_id"));
	    return new ResponseEntity<>(HttpStatus.OK);
	  } else {
	    return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
	  }
	}
	
	
	
	//-----------------찜 목록 가져오기
	
	@GetMapping("/highlight/{userid}")
	public ResponseEntity<Map<String, Object>> getHighLighted(
			@PathVariable("userid") String user_id,
			HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<>();
		HttpStatus status = HttpStatus.ACCEPTED;
		List<String> list = memberService.getHighLighted(user_id);
		status = HttpStatus.OK;
		resultMap.put("list",list);
		return new ResponseEntity<Map<String, Object>>(resultMap, status);
	}
	
	// ------------------- 찜 추가하기
	@PostMapping("/highlight")
	public ResponseEntity<Map<String, Object>> addHighLighted(
			@RequestBody Map<String, String> map,
			HttpServletRequest request) {
		System.out.println("좋아요 추가");
		Map<String, Object> resultMap = new HashMap<>();
		HttpStatus status = HttpStatus.ACCEPTED;
		try {
			memberService.addHighLighted(map);
			status = HttpStatus.OK;			
		}
		catch(Exception e) {
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(status);
	}
	
	// -------------------- 찜 삭제하기
	@PostMapping("/highlight/delete")
	public ResponseEntity<Map<String, Object>> deleteHighLighted(
			@RequestBody Map<String, String> map,
			HttpServletRequest request) {
		System.out.println("좋아요 삭제");
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("hello", "hello");
		HttpStatus status = HttpStatus.ACCEPTED;
		try {
			memberService.deleteHighLighted(map);
			status = HttpStatus.OK;
		}
		catch(Exception e) {
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<Map<String, Object>>(resultMap,status);
	}
	
	

	
}
