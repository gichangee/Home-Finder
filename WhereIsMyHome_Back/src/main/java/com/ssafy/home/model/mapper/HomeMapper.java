package com.ssafy.home.model.mapper;

import java.util.List;
import java.util.Map;

import com.ssafy.home.model.HomedealDto;
import com.ssafy.home.model.HouseinfoDto;

public interface HomeMapper {
	List<String> findSido();
	List<String> findGugunBySido(String sido);
	List<String> findDongByGugun(Map<String, String> map);
	List<HouseinfoDto> findApartByDong(String dong);
	String findDongCodeByfullname(Map<String, String> map);
	String findAmount(String aptCode);
	List<HomedealDto> getHomeInfo(String aptCode);
	List<String> findAptList(String dongCode);
	String findAptCode(Map<String, String> map);
	HouseinfoDto findApartByAptCode(String aptCode);
}
