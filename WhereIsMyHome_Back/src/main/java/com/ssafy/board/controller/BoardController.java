package com.ssafy.board.controller;

import java.io.File;
import java.nio.charset.Charset;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ssafy.board.model.BoardDto;
import com.ssafy.board.model.ReviewDto;
import com.ssafy.board.model.service.BoardService;
import com.ssafy.member.model.MemberDto;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/board")
public class BoardController {

	private final BoardService bs;

	public BoardController(BoardService bs) {
		this.bs = bs;
	}

	
	//리뷰 등록
	@PostMapping("/review")
	public ResponseEntity<?> writerewviewlistArticle(@RequestBody ReviewDto reviewDto) {
		try {
			bs.registReview(reviewDto);
			List<ReviewDto> reviewDtoList = bs.reviewlist();
			return new ResponseEntity<List<ReviewDto>>(reviewDtoList, HttpStatus.OK);

		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	
	//리뷰 수정 시 데이터 가져오기
	@GetMapping("/reviewEdit/{review_no}")
	public ResponseEntity<?> getReviewEdit(@PathVariable("review_no") int review_no) throws Exception {
		try {
			return new ResponseEntity<ReviewDto>(bs.getReviewbyarticle(review_no + ""), HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	
	//리뷰 상세페이지 - 번호로 검색 
	@GetMapping("/review/{review_no}")
	public ResponseEntity<?> getReview(@PathVariable("review_no") int review_no) throws Exception {

		try {
			bs.updateReviewHit(review_no);
			return new ResponseEntity<ReviewDto>(bs.getReviewbyarticle(review_no + ""), HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}

	}

	//리뷰 상세페이지 - limit
	
	@GetMapping("/reviewdetail")
	public ResponseEntity<?> listReview(@RequestParam("aptCode") String aptCode) {
	try {
			List<ReviewDto> reviewListDto = bs.reviewDetailList(aptCode);
			if (reviewListDto != null && !reviewListDto.isEmpty()) {
				return new ResponseEntity<List<ReviewDto>>(reviewListDto, HttpStatus.OK);
			} else {
				return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);
			}
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}
	

	
	//게시판 데이터 =  페이징
	@GetMapping("/limit")
	public ResponseEntity<?> getFreeBoardListLimit(@RequestParam("key") int key, @RequestParam("size") int size) {
		try {

			Map<String, Integer> info = new HashMap<String, Integer>();

			info.put("article_type", key);
			info.put("size", size);

			List<BoardDto> boardList = bs.getFreeBoardListLimit(info);
			return new ResponseEntity<List<BoardDto>>(boardList, HttpStatus.OK);

		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}
	
	//리뷰 게시판 = 페이징
	@GetMapping("/review/limit")
	public ResponseEntity<?> getReviewBoardListLimit(@RequestParam("size") int size) {
		try {

			Map<String, Integer> info = new HashMap<String, Integer>();

			info.put("size", size);

			List<ReviewDto> boardList = bs.getReviewBoardListLimit(info);
			return new ResponseEntity<List<ReviewDto>>(boardList, HttpStatus.OK);

		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}
	

	//조건에 따라 게시글 크기 가져오기
	@GetMapping("/size")
	public ResponseEntity<?> articleListSize(@RequestParam("key") int article_type,@RequestParam("select") String select,@RequestParam("word") String word) {
		try {
			
			System.out.println(article_type + " " +" "+select+" "+word);
			Map<String, Object> info = new HashMap<String, Object>();

			info.put("article_type", article_type);
			info.put("select", select);
			info.put("word", word);

			int size = bs.articleListSize(info);
			return new ResponseEntity<Integer>(size, HttpStatus.OK);

		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	//조건에 따라 리뷰 사이즈 가져오기
	@GetMapping("/review/size")
	public ResponseEntity<?> articleListSize(@RequestParam("select") String select,@RequestParam("word") String word) {
		try {
			System.out.println( " " +" "+select+" "+word);
			Map<String, Object> info = new HashMap<String, Object>();

			info.put("select", select);
			info.put("word", word);

			int size = bs.reviewListSize(info);
			return new ResponseEntity<Integer>(size, HttpStatus.OK);

		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	// 조건에 따라 게시글 가져오기
	@GetMapping
	public ResponseEntity<?> listArticle(@RequestParam("key") int article_type, @RequestParam("page") int page,
			@RequestParam("size") int size,@RequestParam("select") String select,@RequestParam("word") String word) {
		try {

			int start = (page - 1) * size;
			System.out.println(article_type + " " + start + " " + size+" "+select);

			Map<String, Object> info = new HashMap<String, Object>();

			info.put("article_type", article_type);
			info.put("start", start);
			info.put("size", size);
			info.put("select", select);
			info.put("word", word);

			List<BoardDto> boardListDto = bs.listPage(info);
			if (boardListDto != null && !boardListDto.isEmpty()) {
				return new ResponseEntity<List<BoardDto>>(boardListDto, HttpStatus.OK);
			} else {
				return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);
			}
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}
	
	
	//조건에 따라 리뷰 가져오기
	@GetMapping("/review")
	public ResponseEntity<?> listReview(@RequestParam("page") int page, @RequestParam("size") int size,@RequestParam("select") String select,@RequestParam("word") String word) {
		try {

			int start = (page - 1) * size;

			Map<String, Object> info = new HashMap<String, Object>();

			info.put("start", start);
			info.put("size", size);
			info.put("select", select);
			info.put("word", word);


			List<ReviewDto> reviewListDto = bs.reviewListPage(info);
			if (reviewListDto != null && !reviewListDto.isEmpty()) {
				return new ResponseEntity<List<ReviewDto>>(reviewListDto, HttpStatus.OK);
			} else {
				return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);
			}
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}


	@PostMapping
	public ResponseEntity<?> writeBoard(@RequestBody BoardDto boardDto) {

		try {
			bs.registArticle(boardDto);
			List<BoardDto> boardListDto = bs.list(boardDto.getArticle_type());
			return new ResponseEntity<List<BoardDto>>(boardListDto, HttpStatus.OK);

		} catch (Exception e) {
			return exceptionHandling(e);
		}

	}

	@GetMapping("/edit/{articleno}")
	public ResponseEntity<?> getArticleEdit(@PathVariable("articleno") int articleno) throws Exception {
		try {
			return new ResponseEntity<BoardDto>(bs.getBoardbyarticle(articleno + ""), HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}

	}

	@GetMapping("/{articleno}")
	public ResponseEntity<?> getArticle(@PathVariable("articleno") int articleno) throws Exception {

		try {
			bs.updateHit(articleno);
			return new ResponseEntity<BoardDto>(bs.getBoardbyarticle(articleno + ""), HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}

	}

	@DeleteMapping("/{articleno}")
	public ResponseEntity<?> deleteArticle(@PathVariable("articleno") int articleno) throws Exception {
		try {
			bs.deletebyarticle(articleno + "");
			return new ResponseEntity<Void>(HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	@DeleteMapping("/review/{review_no}")
	public ResponseEntity<?> deleteReview(@PathVariable("review_no") int review_no) throws Exception {
		try {
			bs.deleteReview(review_no + "");
			return new ResponseEntity<Void>(HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	@PutMapping
	public ResponseEntity<?> modifyArticle(@RequestBody BoardDto boardDto) throws Exception {
		try {
			bs.modifyArticle(boardDto);
			return new ResponseEntity<Void>(HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}

	}

	@PutMapping("/reviewupdate")
	public ResponseEntity<?> modifyReview(@RequestBody ReviewDto reviewDto) throws Exception {
		try {
			bs.modifyReview(reviewDto);
			return new ResponseEntity<Void>(HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}

	}

	@GetMapping("/multipleSearch")
	public ResponseEntity<?> multipleSearch(@RequestParam("key") String selectKey,
			@RequestParam("word") String inputText, @RequestParam("article_type") String article_type) {
		try {
			if (selectKey.equals("검색조건") || inputText == null) {
				return badRequestHandling();
			}
			Map<String, String> map = new HashMap<>();
			map.put("selectKey", selectKey);
			map.put("inputText", inputText);
			map.put("article_type", article_type);
			List<BoardDto> boardListDto = bs.multipleSearch(map);
			return new ResponseEntity<List<BoardDto>>(boardListDto, HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	@GetMapping("review/multipleReviewSearch")
	public ResponseEntity<?> multipleReviewSearch(@RequestParam("key") String selectKey,
			@RequestParam("word") String inputText) {
		try {
			if (selectKey.equals("검색조건") || inputText == null) {
				return badRequestHandling();
			}
			Map<String, String> map = new HashMap<>();
			map.put("selectKey", selectKey);
			map.put("inputText", inputText);
			List<ReviewDto> boardListDto = bs.multipleReviewSearch(map);
			return new ResponseEntity<List<ReviewDto>>(boardListDto, HttpStatus.OK);
		} catch (Exception e) {
			return exceptionHandling(e);
		}
	}

	private ResponseEntity<String> badRequestHandling() {
		return new ResponseEntity<String>("Error : ", HttpStatus.BAD_REQUEST);
	}

	private ResponseEntity<String> exceptionHandling(Exception e) {
		e.printStackTrace();
		return new ResponseEntity<String>("Error : " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
	}

}
