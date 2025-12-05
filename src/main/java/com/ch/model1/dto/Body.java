package com.ch.model1.dto;

import lombok.Data;

@Data
public class Body {
	
	private Items items;
	private int numOfRows;
	private int pageNo;
	private int totalCount;
	
}
