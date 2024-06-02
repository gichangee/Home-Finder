package com.ssafy.board.model;

import java.util.List;

public class BoardDto {
	int article_no;
	String user_id;
	String subject;
	String content;
	int hit;
	String register_time;
	int article_type;
	public int getArticle_no() {
		return article_no;
	}
	public String getUser_id() {
		return user_id;
	}
	public String getSubject() {
		return subject;
	}
	public String getContent() {
		return content;
	}
	public int getHit() {
		return hit;
	}
	public String getRegister_time() {
		return register_time;
	}
	public int getArticle_type() {
		return article_type;
	}
	public void setArticle_no(int article_no) {
		this.article_no = article_no;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	public void setRegister_time(String register_time) {
		this.register_time = register_time;
	}
	public void setArticle_type(int article_type) {
		this.article_type = article_type;
	}
	
}
