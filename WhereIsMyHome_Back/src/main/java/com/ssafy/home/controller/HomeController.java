package com.ssafy.home.controller;

import java.io.File;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ssafy.board.model.BoardDto;
import com.ssafy.board.model.ReviewDto;
import com.ssafy.board.model.service.BoardService;
import com.ssafy.home.model.service.HomeService;
import com.ssafy.home.model.HomedealDto;
import com.ssafy.home.model.HouseinfoDto;
import com.ssafy.member.model.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/home")
public class HomeController {

	private HomeService homeService;

	public HomeController(HomeService homeService) {
		this.homeService = homeService;
	}

	@GetMapping("/amount")
	public ResponseEntity<?> getAmount(@RequestParam("aptCode") String aptCode,HttpServletRequest request, HttpServletResponse response) {
		try {
	
			String amount ="";
			amount = homeService.findAmount(aptCode);
			
			return new ResponseEntity<String>(amount, HttpStatus.OK);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	
	@GetMapping("/full")
	public ResponseEntity<?> full(@RequestParam("dongCode") String dong, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			
			List<HouseinfoDto> list = homeService.findApartByDong(dong);

			if (list != null && !list.isEmpty()) {
				JSONObject jsonResponse = new JSONObject();
				JSONArray houseArray = new JSONArray();
				for (HouseinfoDto dto : list) {
					JSONObject houseObject = new JSONObject();
					houseObject.put("roadName", dto.getRoadName());
					houseObject.put("aptCode", dto.getAptCode());
					houseObject.put("buildYear", dto.getBuildYear());
					houseObject.put("dong", dto.getDong());
					houseObject.put("apartmentName", dto.getApartmentName());
					houseObject.put("lng", dto.getLng());
					houseObject.put("lat", dto.getLat());
					houseArray.put(houseObject);
				}
				jsonResponse.put("dongList", houseArray);

				return ResponseEntity.ok().body(jsonResponse.toString());
			} else {
				return ResponseEntity.noContent().build();
			}
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}

	}
	@GetMapping("/wishList")
	public ResponseEntity<?> getWishListData(@RequestParam("aptCode") String aptCode, HttpServletRequest request,
			HttpServletResponse response) {
		System.out.print("여기까진 왔니..?");
		try {
			
			HouseinfoDto home = homeService.findApartByAptCode(aptCode);
			Map<String, Object> info = new HashMap<String,Object>();
			
			if (home != null) {
				info.put("houseInfo",home);
				System.out.println(home.getLat()+" "+home.getLng());
				return new ResponseEntity<Map<String, Object>>(info, HttpStatus.OK);
			} else {
				return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);
			}
		} catch (Exception e) {
			return new ResponseEntity<Void>(HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}
	
	@GetMapping("/info")
	public ResponseEntity<?> getInfo(@RequestParam("aptCode") String aptCode, HttpServletRequest request,
			HttpServletResponse response) {
	
		try {
			
			
			List<HomedealDto> h = homeService.getHomeInfo(aptCode);
			
			for(HomedealDto d : h) {
				System.out.println(d);
			}
			

			
			return new ResponseEntity<List<HomedealDto>>(h, HttpStatus.OK);
			
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	} 

	@GetMapping("/address/sido")
	public ResponseEntity<?> getSido(HttpServletRequest request, HttpServletResponse response) {
		try {
			List<String> list = homeService.findSido();

			if (list != null && !list.isEmpty()) {
				JSONObject jsonResponse = new JSONObject();
				JSONArray sidoArray = new JSONArray();
				for (String sido : list) {
					sidoArray.put(sido);
				}
				jsonResponse.put("sidoList", sidoArray);

				return ResponseEntity.ok().body(jsonResponse.toString());
			} else {
				return ResponseEntity.noContent().build();
			}
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	@GetMapping("/address/gugun")
	public ResponseEntity<?> getGugun(@RequestParam("sido") String sido, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			List<String> list = homeService.findGugunBySido(sido);

			if (list != null && !list.isEmpty()) {
				JSONObject jsonResponse = new JSONObject();
				JSONArray gugunArray = new JSONArray();

				for (String gugun : list) {
					gugunArray.put(gugun);
				}
				jsonResponse.put("gugunList", gugunArray);

				return ResponseEntity.ok().body(jsonResponse.toString());
			} else {
				return ResponseEntity.noContent().build();
			}
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	@GetMapping("/address/dong")
	public ResponseEntity<?> getDong(@RequestParam("sido") String sido,@RequestParam("gugun") String gugun, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			Map<String,String> map = new HashMap<>();
			map.put("sido", sido);
			map.put("gugun",gugun);
			
			List<String> list = homeService.findDongByGugun(map);

			
			if (list != null && !list.isEmpty()) {
				JSONObject jsonResponse = new JSONObject();
				JSONArray dongArray = new JSONArray();

				for (String dong : list) {
					dongArray.put(dong);
				}
				jsonResponse.put("dongList", dongArray);

				return ResponseEntity.ok().body(jsonResponse.toString());
			} else {
				return ResponseEntity.noContent().build();
			}
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	@GetMapping("/address/name")
	public ResponseEntity<?> getFullName(@RequestParam("sido") String sido,@RequestParam("gugun") String gugun,@RequestParam("dong") String dong, HttpServletRequest request,
			HttpServletResponse response) {
	
		try {
		
			Map<String,String> map = new HashMap<>();
			map.put("sido", sido);
			map.put("gugun", gugun);
			map.put("dong",dong);
			
			String fullcode =homeService.findDongCodeByfullname(map);

	
			return new ResponseEntity<String>(fullcode, HttpStatus.OK);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	@GetMapping("/address/apt")
	public ResponseEntity<?> getDong(@RequestParam("dongCode") String dongCode, HttpServletRequest request,
			HttpServletResponse response) {
		try {

			
			List<String> list = homeService.findAptList(dongCode);

			
			if (list != null && !list.isEmpty()) {
				JSONObject jsonResponse = new JSONObject();
				JSONArray aptArray = new JSONArray();

				for (String apt : list) {
					aptArray.put(apt);
				}
				jsonResponse.put("aptList", aptArray);

				return ResponseEntity.ok().body(jsonResponse.toString());
			} else {
				return ResponseEntity.noContent().build();
			}
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	@GetMapping("/aptCode")
	public ResponseEntity<?> getAptCode(@RequestParam("dongCode") String dongCode,@RequestParam("apartmentName") String apartmentName, HttpServletRequest request,
			HttpServletResponse response) {
		try {

			Map<String,String> map = new HashMap<>();
			map.put("dongCode", dongCode);
			map.put("apartmentName", apartmentName);
			
			String name = homeService.findAptCode(map);

			System.out.println(name);

			return new ResponseEntity<String>(name, HttpStatus.OK);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}	
	

	

}
