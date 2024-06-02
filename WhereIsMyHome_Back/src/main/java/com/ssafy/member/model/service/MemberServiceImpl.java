package com.ssafy.member.model.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ssafy.member.model.MemberDto;
import com.ssafy.member.model.mapper.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService {
	private final MemberMapper memberMapper;

	public MemberServiceImpl(MemberMapper memberMapper) {
		super();
		this.memberMapper = memberMapper;
	}
	@Override
	public MemberDto login(Map<String, String> map) throws Exception {
		MemberDto memberDto =  memberMapper.loginMember(map);
		return memberDto;
	}
	@Override
	public void join(Map<String, String> map)throws Exception {
		memberMapper.join(map);
	}
	@Override
	public String findPassword(Map<String, String> map) throws Exception {
		return memberMapper.findPassword(map);
	}
	@Override
	public void editUserInfo(Map<String, String> map) throws Exception {
		memberMapper.editUserInfo(map);
	}
	@Override
	public MemberDto getUserInfo(Map<String, String> map)throws Exception  {
		return memberMapper.getUserInfo(map);
	}
	@Override
	public boolean isCheckedPasswordBeforeDelete(String user_password,String user_id) throws Exception {
		System.out.println("service - delete :" +user_password+" "+user_id);
		Map<String, String> map = new HashMap<>();
		map.put("user_password", user_password);
		map.put("user_id", user_id);
		return  memberMapper.isCheckedPasswordBeforeDelete(map);
	}
	@Override
	public void deleteMember(String user_id) throws Exception {
		System.out.println("deleteMember");
		memberMapper.deleteMember(user_id);
		
	}
	@Override
	public MemberDto userInfo(String userId) throws Exception {
		return memberMapper.userInfo(userId);
	}

	@Override
	public void saveRefreshToken(String userId, String refreshToken) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("userId", userId);
		map.put("token", refreshToken);
		memberMapper.saveRefreshToken(map);
	}

	@Override
	public Object getRefreshToken(String userId) throws Exception {
		return memberMapper.getRefreshToken(userId);
	}

	@Override
	public void deleRefreshToken(String userId) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("user_id", userId);
		map.put("token", null);
		memberMapper.deleteRefreshToken(map);
	}
	@Override
	public boolean emailCofirm(Map<String, String> email) {
		return memberMapper.emailCofirm(email);
	}
	@Override
	public boolean confirmUserId(String user_id) {
		
		return memberMapper.confirmUserId(user_id);
	}
	@Override
	public boolean isMatchPassword(Map<String, String> map) {
		return memberMapper.isMatchPassword(map);
	}
	@Override
	public void setForeignKeyToNull(String user_id) {
		memberMapper.setForeignKeyToNull(user_id);
		
	}
	@Override
	public List<String> getHighLighted(String user_id) {
		return memberMapper.getHighLighted(user_id);
	}
	@Override
	public void addHighLighted(Map<String, String> map) {
		memberMapper.addHighLighted(map);
	}
	@Override
	public void deleteHighLighted(Map<String, String> map) {
		memberMapper.deleteHighLighted(map);
	}



}
