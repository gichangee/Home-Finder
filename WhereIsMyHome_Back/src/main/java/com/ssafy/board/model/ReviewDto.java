package com.ssafy.board.model;

import java.sql.Date;

public class ReviewDto {

	private int review_no;
	private String subject;
	private String apartmentName;
	private String content;
	private String user_id;
	private String aptCode;
	private int star;
	private int hit;
	private String register_time;

	public String getRegister_time() {
		return register_time;
	}
	public void setRegister_time(String register_time) {
		this.register_time = register_time;
	}
	public int getReview_no() {
		return review_no;
	}
	public void setReview_no(int review_no) {
		this.review_no = review_no;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getApartmentName() {
		return apartmentName;
	}
	public void setApartmentName(String apartmentName) {
		this.apartmentName = apartmentName;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getAptCode() {
		return aptCode;
	}
	public void setAptCode(String aptCode) {
		this.aptCode = aptCode;
	}
	public int getStar() {
		return star;
	}
	public void setStar(int star) {
		this.star = star;
	}
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	
}
