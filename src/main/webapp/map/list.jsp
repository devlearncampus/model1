<%@ page contentType="application/json; charset=UTF-8"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.ch.model1.dto.ApiResponse"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%
	StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B553662/sghtngPoiInfoService/getSghtngPoiInfoList"); /*URL*/
	urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=db45e823d56f47bf849ad81b0ad31ef2fca196f7ab842bd3922b9c0182bc9d28"); /*Service Key*/        
	urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*한 페이지 결과 수*/
	urlBuilder.append("&" + URLEncoder.encode("type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*응답 결과의 출력 방식을 xml, json 형태로 변환 제공될 수 있도록 함*/
	urlBuilder.append("&" + URLEncoder.encode("srchFrtrlNm","UTF-8") + "=" + URLEncoder.encode("가지산", "UTF-8")); /*검색하고자 하는 숲길명 “TEXT”*/
	urlBuilder.append("&" + URLEncoder.encode("srchPlaceTpeCd","UTF-8") + "=" + URLEncoder.encode("CULTURAL", "UTF-8")); /*검색하고자 하는 장소유형코드 “TEXT” CULTURAL:문화자원*/
	URL url = new URL(urlBuilder.toString());
	HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	conn.setRequestMethod("GET");
	conn.setRequestProperty("Content-type", "application/json");
	System.out.println("Response code: " + conn.getResponseCode());
	BufferedReader rd;
	if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	    rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	} else {
	    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	}
	StringBuilder sb = new StringBuilder();
	String line;
	while ((line = rd.readLine()) != null) {
	    sb.append(line);
	}
	rd.close();
	conn.disconnect();
	
	//오픈 API 서버로부터 응답받은 결과는 결국 웹상으로 받앗기 때문에, 문자열에 불과하다..
	//하지만 문자열은 현실의 반영한 객체가 아니므로(그냥글씨) 객체처럼 .(점) 찍고 사용할 수 없다!!
	//이 시점부터 서버로부터 받은 문자열이 만일 JSON문자열 표기법을 준수했다면, 자바의 객체로 자동매핑할 기회가 있다..
	//우리가 받은 데이터를 json 검증기 에서 확인했기에, 문자열을 자바 객체로 자동변환하는 라이브러리인 jackson 을 사용해보자 
	ObjectMapper mapper=new ObjectMapper();
	ApiResponse data=mapper.readValue(sb.toString(), ApiResponse.class); //첫번째 매개변수엔 서버로부터 가져온 json문자열을 넣고, 
																										//두번째 매개변수엔 그 결과를 받을  DTO를 대입해야 한다..
	
	//이제 모든 데이터가 각각 자동으로 채워진 상태이며 데이터에 대한 접근은 최상위 객체로부터 점차적으로 접근하면 된다.
	//String placeNm=data.getResponse().getBody().getItems().getItem().get(0).getPlaceNm();
	
	//웹브라우저인 클라이언트에게 결과 문자열을 전송해야 함...
	//결과정보가 현재 문자열 형태가 아닌 자바의 객체로 담겨져 있다..하지만 웹상의 응답정보는 반드시 문자열로 변환하여 보내야 한다!!
	//마치 오전 수업에서 JSON내장객체가 객체를 문자열로 바꾸거나(JSON.stringify()), 문자열로 된 JSON을 객체리터럴로 변환하듯
	//(JSON.parse()), 자바에서도 jackson 라이브러리가 동일한 기능을 지원해준다.. 
	String json=mapper.writeValueAsString(data); //Java --> json 
	out.println(json);
%>





