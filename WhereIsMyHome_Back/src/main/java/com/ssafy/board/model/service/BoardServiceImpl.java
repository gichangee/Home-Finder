package com.ssafy.board.model.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.board.model.BoardDto;
import com.ssafy.board.model.ReviewDto;
import com.ssafy.board.model.mapper.BoardMapper;



@Service
public class BoardServiceImpl implements BoardService {
	
	private final BoardMapper boardMapper;

	public BoardServiceImpl(BoardMapper boardMapper) {
		this.boardMapper = boardMapper;
	}

	@Override
	public int articleListSize(Map<String, Object> info) {
		return boardMapper.articleListSize(info);
	}



	@Override
	public void registArticle(BoardDto boardDto) {
		System.out.println(boardDto.getArticle_type());
		boardMapper.registArticle(boardDto);
	
		
	}



	@Override
	public BoardDto getBoardbyarticle(String article_no) {
		return boardMapper.getBoardbyarticle(article_no);
	}

	@Override
	public void deletebyarticle(String article_no) {
		boardMapper.deletebyarticle(article_no);
		
	}

	@Override
	public void updatebyarticle(String article_no) {
		boardMapper.updatebyarticle(article_no);
		
	}

	@Override
	public void modify(Map<String, String> map) {
		boardMapper.modify(map);
		
	}

	@Override
	public void updateHit(int article_no) {
		boardMapper.updateHit(article_no);
		
	}

	@Override
	public void modifyArticle(BoardDto boardDto) throws Exception {
		boardMapper.modifyArticle(boardDto);
		
	}

	@Override
	public List<ReviewDto> reviewlist() {
		return boardMapper.reviewlist();
	}

	@Override
	public void registReview(ReviewDto reviewDto) {
		// TODO Auto-generated method stub
		boardMapper.registReview(reviewDto);
		
	}

	@Override
	public void updateReviewHit(int review_no) {
		boardMapper.updateReviewHit(review_no);
		
	}

	@Override
	public ReviewDto getReviewbyarticle(String review_no) {
		
		return boardMapper.getReviewbyarticle(review_no);
	}

	@Override
	public void deleteReview(String review_no) {
		boardMapper.deleteReview(review_no);
		
	}

	@Override
	public void modifyReview(ReviewDto reviewDto) {
		boardMapper.modifyReview(reviewDto);
		
	}

	@Override
	public List<BoardDto> listPage(Map<String, Object> info) {
		
		return boardMapper.listPage(info);
	}

	@Override
	public List<BoardDto> list(int article_type) {
		return boardMapper.list(article_type);
	}

	@Override
	public int reviewListSize(Map<String, Object> info) {
		return boardMapper.reviewListSize(info);
	}

	@Override
	public List<ReviewDto> reviewListPage(Map<String, Object> info) {
		return boardMapper.reviewListPage(info);
	}

	@Override
	public List<BoardDto> multipleSearch(Map<String,String> map) {
		return boardMapper.multipleSearch(map);
	}

	@Override
	public List<ReviewDto> multipleReviewSearch(Map<String, String> map) {
		return boardMapper.multipleReviewSearch(map);
	}

	@Override
	public List<ReviewDto> reviewDetailList(String aptCode) {
		return boardMapper.reviewDetailList(aptCode);
	}
	@Override
	public List<BoardDto> getFreeBoardListLimit(Map<String, Integer> info) {
		return boardMapper.getFreeBoardListLimit(info);
	}

	@Override
	public List<ReviewDto> getReviewBoardListLimit(Map<String, Integer> info) {
		return boardMapper.getReviewBoardListLimit(info);
	}


}
