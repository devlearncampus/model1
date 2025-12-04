<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ch.model1.repository.Member2DAO" %>
<%@ page import="com.ch.model1.dto.Member2"%>
<%! 
	Member2DAO dao = new Member2DAO();
%>
<%
	//스크립틀릿 (이 jsp가 서블릿으로 변환될때 service(request, response)메서드 영역)
	//넘어온 파라미터를 받아서 mysql의 member2 테이블에 insert !!!
	
	//jsp에서는 개발자가 요청객체, 응답 객체를 별도로 변수명을 바꿀 수 없다..
	//이유? 이미 결정되어 잇다..(내장객체라 한다) built-in object 
	request.setCharacterEncoding("utf-8"); //파라미터 받기 전에 인코딩 지정해야 함  
	String id=request.getParameter("id");
	String name=request.getParameter("name");
	String email=request.getParameter("email");
	
	//PrintWriter 조차도 이미 내장객체로 지원되므로, 명칭은 out으로 정해져있다..
	out.print("id="+id+"<br>");
	out.print("name="+name+"<br>");
	out.print("email="+email+"<br>");
	
	//낱개로 되어 있는 파라미터들을 전달하기 편하게끔 하나의 DTO로 모아서 전달하자 
	Member2 dto = new Member2();
	dto.setId(id);
	dto.setName(name);
	dto.setEmail(email);

	int result = dao.insert(dto);
%>

<script>
<%if(result<1){%>
	out.print("실패입니다 ");
<%}else{%>
	location.href="/ajax/main.jsp";
<%} %>
</script>

















