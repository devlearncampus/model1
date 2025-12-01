<%@page import="javax.naming.InitialContext"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%

	//톰켓에 JNDI로 설정해 놓은 커넥션풀 사용해보기 
	
	//Tomcat 설정해 놓은 자원을 이름으로 검색 
	InitialContext ctx = new InitialContext(); //JNDI 검색 객체 
	DataSource pool =(DataSource)ctx.lookup("java:comp/env/jndi/mysql");
	
	Connection con=pool.getConnection(); //풀에 들어있는 Connection 객체 꺼내기 
	
	out.print("풀로부터 얻어온 커넥션 객체는 "+con);
%>