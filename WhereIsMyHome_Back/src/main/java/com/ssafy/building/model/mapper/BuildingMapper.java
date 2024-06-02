package com.ssafy.building.model.mapper;

import java.util.List;

import com.ssafy.building.model.BuildingDto;
import com.ssafy.building.model.BusstopDto;

public interface BuildingMapper {

	List<BuildingDto> findBuildingList(String medium_business_category, String dongCode);

	List<BusstopDto> findBusstopList(String city);


}
