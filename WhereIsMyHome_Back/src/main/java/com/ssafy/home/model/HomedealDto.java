package com.ssafy.home.model;

public class HomedealDto {
	private int no;
	private String dealAmount;
	private String dealYear;
	private String dealMonth;
	private String dealDay;
	private String area;
	private String floor;
	private String cancelDealType;
	private int aptCode;
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	@Override
	public String toString() {
		return "HomedealDto [no=" + no + ", dealAmount=" + dealAmount + ", dealYear=" + dealYear + ", dealMonth="
				+ dealMonth + ", dealDay=" + dealDay + ", area=" + area + ", floor=" + floor + ", cancelDealType="
				+ cancelDealType + ", aptCode=" + aptCode + "]";
	}
	public String getDealAmount() {
		return dealAmount;
	}
	public void setDealAmount(String dealAmount) {
		this.dealAmount = dealAmount;
	}
	public String getDealYear() {
		return dealYear;
	}
	public void setDealYear(String dealYear) {
		this.dealYear = dealYear;
	}
	public String getDealMonth() {
		return dealMonth;
	}
	public void setDealMonth(String dealMonth) {
		this.dealMonth = dealMonth;
	}
	public String getDealDay() {
		return dealDay;
	}
	public void setDealDay(String dealDay) {
		this.dealDay = dealDay;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getFloor() {
		return floor;
	}
	public void setFloor(String floor) {
		this.floor = floor;
	}
	public String getCancelDealType() {
		return cancelDealType;
	}
	public void setCancelDealType(String cancelDealType) {
		this.cancelDealType = cancelDealType;
	}
	public int getAptCode() {
		return aptCode;
	}
	public void setAptCode(int aptCode) {
		this.aptCode = aptCode;
	}
}
