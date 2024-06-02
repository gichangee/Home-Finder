package com.ssafy.building.model.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ssafy.building.model.BuildingDto;
import com.ssafy.building.model.BusstopDto;
import com.ssafy.building.model.mapper.BuildingMapper;

@Service
public class BuildingServiceImpl implements BuildingService{
	
	private BuildingMapper buildingMapper;
	public BuildingServiceImpl(BuildingMapper buildingMapper) {
		this.buildingMapper = buildingMapper;
	}
	@Override
	public List<BuildingDto> findBuildingList(String medium_business_category,String dongCode) {
		return buildingMapper.findBuildingList(medium_business_category,dongCode);
	}
	@Override
	public List<BusstopDto> findBusstopList(String city) {
		
		return buildingMapper.findBusstopList(city);
	}

}
