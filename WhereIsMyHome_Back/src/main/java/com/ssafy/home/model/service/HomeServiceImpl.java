package com.ssafy.home.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ssafy.home.model.HomedealDto;
import com.ssafy.home.model.HouseinfoDto;
import com.ssafy.home.model.mapper.HomeMapper;

@Service
public class HomeServiceImpl implements HomeService {

	private final HomeMapper homemapper;

	public HomeServiceImpl(HomeMapper homemapper) {
		this.homemapper = homemapper;
	}

	@Override
	public List<String> findSido() {
		return homemapper.findSido();
	}

	@Override
	public List<String> findGugunBySido(String sido) {
		return homemapper.findGugunBySido(sido);
	}



	@Override
	public List<HouseinfoDto> findApartByDong(String dong) {
		return homemapper.findApartByDong(dong);
	}

	

	@Override
	public String findDongCodeByfullname(Map<String, String> map) {
		return homemapper.findDongCodeByfullname(map);
	}

	@Override
	public String findAmount(String aptCode) {
		return homemapper.findAmount(aptCode);
	}

	@Override
	public List<String> findDongByGugun(Map<String, String> map) {
		return homemapper.findDongByGugun(map);
	}

	@Override
	public List<HomedealDto> getHomeInfo(String aptCode) {
		return homemapper.getHomeInfo(aptCode);
	}

	@Override
	public List<String> findAptList(String dongCode) {
	
		return homemapper.findAptList(dongCode);
	}

	@Override
	public String findAptCode(Map<String, String> map) {
		
		return  homemapper.findAptCode(map);
	}

	@Override
	public HouseinfoDto findApartByAptCode(String aptCode) {
		return homemapper.findApartByAptCode(aptCode);
	}

}
