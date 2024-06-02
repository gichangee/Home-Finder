package com.ssafy.member.model.service;

import java.util.List;
import java.util.Map;

import com.ssafy.member.model.MemberDto;

public interface MemberService {

	MemberDto login(Map<String, String> map) throws Exception;

	void join(Map<String, String> map)throws Exception;

	String findPassword(Map<String, String> map)throws Exception;

	void editUserInfo(Map<String, String> map)throws Exception;

	MemberDto getUserInfo(Map<String, String> map)throws Exception;

	boolean isCheckedPasswordBeforeDelete(String user_password,String user_id)throws Exception;

	void deleteMember(String user_id)throws Exception;
	
	MemberDto userInfo(String userId) throws Exception;
	void saveRefreshToken(String userId, String refreshToken) throws Exception;
	Object getRefreshToken(String userId) throws Exception;
	void deleRefreshToken(String userId) throws Exception;

	boolean emailCofirm(Map<String, String> email);

	boolean confirmUserId(String user_id);

	boolean isMatchPassword(Map<String, String> map);
	
	void setForeignKeyToNull(String user_id);

	List<String> getHighLighted(String user_id);

	void addHighLighted(Map<String, String> map);

	void deleteHighLighted(Map<String, String> map);
}
