package com.ssafy.building.model;

public class BusstopDto {

	private String no;
	private String busstopname;
	private String lat;
	private String lng;
	private String city;
	@Override
	public String toString() {
		return "BusstopDto [no=" + no + ", busstopname=" + busstopname + ", lat=" + lat + ", lng=" + lng + ", city="
				+ city + "]";
	}
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getBusstopname() {
		return busstopname;
	}
	public void setBusstopname(String busstopname) {
		this.busstopname = busstopname;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getLng() {
		return lng;
	}
	public void setLng(String lng) {
		this.lng = lng;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
}
