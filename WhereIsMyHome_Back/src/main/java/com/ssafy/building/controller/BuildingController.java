package com.ssafy.building.controller;

import java.util.List;


import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.building.model.BuildingDto;
import com.ssafy.building.model.BusstopDto;
import com.ssafy.building.model.service.BuildingService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/building")
public class BuildingController {

	private BuildingService buildingservice;
	public BuildingController(BuildingService buildingservice) {
		this.buildingservice =  buildingservice;
	}
	
	@GetMapping("/list")
	public ResponseEntity<?> getList(@RequestParam("medium_business_category") String medium_business_category,@RequestParam("dongCode") String dongCode,HttpServletRequest request, HttpServletResponse response) {
		try {
	
			List<BuildingDto> list = buildingservice.findBuildingList(medium_business_category,dongCode);
			
			return new ResponseEntity<List<BuildingDto>>(list, HttpStatus.OK);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	@GetMapping("/bus")
	public ResponseEntity<?> getBus(@RequestParam("city") String city,HttpServletRequest request, HttpServletResponse response) {
		try {
	
			List<BusstopDto> list = buildingservice.findBusstopList(city);
			
			return new ResponseEntity<List<BusstopDto>>(list, HttpStatus.OK);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
}
