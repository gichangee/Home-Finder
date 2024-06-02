package com.ssafy.building.model;

public class BuildingDto {

	private String business_name;
	private String major_business_category;
	private String medium_business_category;
	private String minor_business_category;
	private String sidoname;
	private String sigunguCode;
	private String sigungu;
	private String dongCode;
	private String dong;
	private String jibun_address;
	private String street_name;
	private String street_address;
	private String lng;
	private String lat;
	public String getBusiness_name() {
		return business_name;
	}
	public void setBusiness_name(String business_name) {
		this.business_name = business_name;
	}
	public String getMajor_business_category() {
		return major_business_category;
	}
	public void setMajor_business_category(String major_business_category) {
		this.major_business_category = major_business_category;
	}
	public String getMedium_business_category() {
		return medium_business_category;
	}
	public void setMedium_business_category(String medium_business_category) {
		this.medium_business_category = medium_business_category;
	}
	public String getMinor_business_category() {
		return minor_business_category;
	}
	public void setMinor_business_category(String minor_business_category) {
		this.minor_business_category = minor_business_category;
	}
	public String getSidoname() {
		return sidoname;
	}
	public void setSidoname(String sidoname) {
		this.sidoname = sidoname;
	}
	public String getSigunguCode() {
		return sigunguCode;
	}
	public void setSigunguCode(String sigunguCode) {
		this.sigunguCode = sigunguCode;
	}
	public String getSigungu() {
		return sigungu;
	}
	public void setSigungu(String sigungu) {
		this.sigungu = sigungu;
	}
	public String getDongCode() {
		return dongCode;
	}
	public void setDongCode(String dongCode) {
		this.dongCode = dongCode;
	}
	public String getDong() {
		return dong;
	}
	public void setDong(String dong) {
		this.dong = dong;
	}
	public String getJibun_address() {
		return jibun_address;
	}
	public void setJibun_address(String jibun_address) {
		this.jibun_address = jibun_address;
	}
	public String getStreet_name() {
		return street_name;
	}
	public void setStreet_name(String street_name) {
		this.street_name = street_name;
	}
	public String getStreet_address() {
		return street_address;
	}
	public void setStreet_address(String street_address) {
		this.street_address = street_address;
	}
	public String getLng() {
		return lng;
	}
	public void setLng(String lng) {
		this.lng = lng;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	@Override
	public String toString() {
		return "BuildingDto [business_name=" + business_name + ", major_business_category=" + major_business_category
				+ ", medium_business_category=" + medium_business_category + ", minor_business_category="
				+ minor_business_category + ", sidoname=" + sidoname + ", sigunguCode=" + sigunguCode + ", sigungu="
				+ sigungu + ", dongCode=" + dongCode + ", dong=" + dong + ", jibun_address=" + jibun_address
				+ ", street_name=" + street_name + ", street_address=" + street_address + ", lng=" + lng + ", lat="
				+ lat + "]";
	}

	
}


