package com.ch.model1.dto;

import java.util.List;

import lombok.Data;

@Data
public class Items {
	
	//검색 결과 인 Item 배열이기 여러개의 자식을 
	//아래와 같이 List 로 표현
	private List<Item> item;
}
