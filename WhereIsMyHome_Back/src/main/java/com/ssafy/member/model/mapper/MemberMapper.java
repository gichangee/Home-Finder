package com.ssafy.member.model.mapper;


import java.sql.SQLException;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.ssafy.member.model.MemberDto;
public interface MemberMapper {

	MemberDto loginMember(Map<String, String> map) throws SQLException;

	void join(Map<String, String> map)throws SQLException;

	String findPassword(Map<String, String> map)throws SQLException;

	void editUserInfo(Map<String, String> map)throws SQLException;

	MemberDto getUserInfo(Map<String, String> map)throws SQLException;

	boolean isCheckedPasswordBeforeDelete(Map<String,String> map)throws SQLException;

	void deleteMember(String user_id)throws SQLException;
	
	MemberDto userInfo(String userId) throws SQLException;
	
	void saveRefreshToken(Map<String, String> map) throws SQLException;
	
	Object getRefreshToken(String userid) throws SQLException;
	
	void deleteRefreshToken(Map<String, String> map) throws SQLException;

	boolean emailCofirm(Map<String, String> email);

	boolean confirmUserId(String user_id);

	boolean isMatchPassword(Map<String, String> map);
	
	void setForeignKeyToNull(String user_id);

	List<String> getHighLighted(String user_id);

	void addHighLighted(Map<String, String> map);

	void deleteHighLighted(Map<String, String> map);

}
