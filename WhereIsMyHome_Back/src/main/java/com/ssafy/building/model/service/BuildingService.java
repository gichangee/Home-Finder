package com.ssafy.building.model.service;

import java.util.List;

import com.ssafy.building.model.BuildingDto;
import com.ssafy.building.model.BusstopDto;
import com.ssafy.building.model.mapper.BuildingMapper;

public interface BuildingService {

	
	
	
	List<BuildingDto> findBuildingList(String medium_business_category, String dongCode);

	List<BusstopDto> findBusstopList(String city);

}
