<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ch.model1.repository.CommentDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ch.model1.dto.Comment" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%! CommentDAO commentDAO = new CommentDAO();%>
<%
	//특정 뉴스기사에 딸려있는 코멘트 게시물 모두 가져오기 
	//select * from comment where news_id=13
	String news_id=request.getParameter("news_id");

	//결과로 반환 리스트를 클라이언트에게 전송 시 , 순수 데이터 형태로 보내주자 (클라이언트는 페이지 새로고침을 원하지 않고 순수 데이터만을 원함..)
	List<Comment> commentList=commentDAO.selectByNewsId(Integer.parseInt(news_id));
	//아래와 같이 그냥 List의 레퍼런스 변수 자체를 출력해버리면, 클라이언트가 원하는 파싱 대상이 되는 JSON형태가 아니므로, 파싱 자체가 불가능하다..
	//out.print(commentList);
	
	//해결책? 클라이언트가 해석 가능한 형태의 문자열인 JSON으로 전송해야 한다!!
	//개발자가 직접 리스트 안에 있는 DTO들을 꺼내어 json문자열로 변환하는 작업은 너무나 비효율적임. 실수 가능성이 높다..
	//따라서 외부 라이브러리를 적극 활용해야 함(참고 스프링 프레임워크에서는 내장하고 있을 정도..)
	//Jackson 라이브러리를 활용하면 객체와 JSON 문자열간 변환을 자동으로 처리해줌 (JS에서도 jackson과 비슷한 용도의 내장객체가 있다..JSON 내장객체 )
	ObjectMapper objectMapper = new ObjectMapper();
	
	//네트워크상에서는 데이터를 전송하려면 반드시 문자열로 변환해야하므로, 객체를 문자열로 바꾸자
	String result=objectMapper.writeValueAsString(commentList);
	out.print(result);
%>










