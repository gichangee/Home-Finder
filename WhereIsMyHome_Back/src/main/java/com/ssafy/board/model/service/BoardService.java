package com.ssafy.board.model.service;

import java.util.List;
import java.util.Map;

import com.ssafy.board.model.BoardDto;
import com.ssafy.board.model.ReviewDto;

public interface BoardService {

	int articleListSize(Map<String, Object> info);

	void registArticle(BoardDto boardDto);


	BoardDto getBoardbyarticle(String article_no);

	void deletebyarticle(String article_no);

	void updatebyarticle(String article_no);

	void modifyArticle(BoardDto boardDto) throws Exception;
	
	void modify(Map<String, String> map);

	void updateHit(int articleno);

	List<ReviewDto> reviewlist();

	void registReview(ReviewDto reviewDto);

	void updateReviewHit(int review_no);

	ReviewDto getReviewbyarticle(String string);

	void deleteReview(String string);

	void modifyReview(ReviewDto reviewDto);

	List<BoardDto> listPage(Map<String, Object> info);

	List<BoardDto> list(int article_type);

	int reviewListSize(Map<String, Object> info);

	List<ReviewDto> reviewListPage(Map<String, Object> info);

	List<BoardDto> multipleSearch(Map<String, String> map);

	List<ReviewDto> multipleReviewSearch(Map<String, String> map);

	List<BoardDto> getFreeBoardListLimit(Map<String, Integer> info);

	List<ReviewDto> getReviewBoardListLimit(Map<String, Integer> info);


	List<ReviewDto> reviewDetailList(String aptCode);


}
