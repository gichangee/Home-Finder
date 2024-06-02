package com.ssafy.member.model;


public class MemberDto {
	String permission_level;
	String user_password;
	String user_name;
	String user_id;
	String email_id;
	String email_domain;
	String join_date;
	String token;
	public String gettoken() {
		return token;
	}
	public String getPermission_level() {
		return permission_level;
	}
	public String getUser_password() {
		return user_password;
	}
	public String getUser_name() {
		return user_name;
	}
	public String getUser_id() {
		return user_id;
	}
	public String getEmail_id() {
		return email_id;
	}
	public String getEmail_domain() {
		return email_domain;
	}
	public String getJoin_date() {
		return join_date;
	}
	public void setPermission_level(String permission_level) {
		this.permission_level = permission_level;
	}
	public void setUser_password(String user_password) {
		this.user_password = user_password;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public void setEmail_id(String email_id) {
		this.email_id = email_id;
	}
	public void setEmail_domain(String email_domain) {
		this.email_domain = email_domain;
	}
	public void setJoin_date(String join_date) {
		this.join_date = join_date;
	}
	public void settoken(String token) {
		this.token = token;
	}
	
	
}
