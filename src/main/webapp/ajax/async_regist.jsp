<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ch.model1.repository.Member2DAO" %>
<%@ page import="com.ch.model1.dto.Member2"%>
<%@ page import="java.util.List"%>
<%!
	Member2DAO dao = new Member2DAO();
%>
<%

	//System.out.println("클라이언트의 요청 감지"); //Tomcat 로그에 출력되지만, 우리의 경우
	//이클립스 내부 톰켓이므로, 이클립스 콘솔에 출력 ..
	
	//파라미터 받기 
	request.setCharacterEncoding("utf-8"); //파라미터가 깨지지 않도록 인코딩 지정 
	
	String id=request.getParameter("id");
	String name=request.getParameter("name");
	String email=request.getParameter("email");
	
	System.out.println("id="+id);
	System.out.println("name="+name);
	System.out.println("email="+email);
	
	//DTO 에 모으기 
	Member2 dto = new Member2();
	dto.setId(id);
	dto.setName(name);
	dto.setEmail(email);
	
	int result=dao.insert(dto);
	
	System.out.println(result);
	
	//입력 성공 후 페이지 보여주기
	//아래와 같이 비동기 요청에 대해, 응답 정보로서 페이지 접속을 일으키는 코드를 작성하게 되면 
	//클라이언의 브라우저가 지정한 URL로 재접속을 시도하기 때문에, 그 재접속의 결과인 html을 서버로 부터 받게되고
	//html 을 전송받은 브라우저는 해당 html을 화면에 렌더링 해버리므로, 새로고침 효과가 나버린다..즉 새로고침 없는 
	//without reloading 기능이 상실..
	//response.sendRedirect("/ajax/main.jsp");
	
	//해결책- 서버에서는 화면전체를 보내지 말고, 순수하게 목록 데이터만을 전송해주면, 클라이언트는 그 데이터를 js로 동적 처리...
		
	//게시물 목록 가져오기!!
	List<Member2> list=dao.selectAll();
	
	//클라이언트에게 목록 데이터 보내기 
	//out.print(list);
	
	/*
	클라이언트에게 응답 정보를 보낼때, 어차피 모두 문자열로 밖에 방법이 없다..
	하지만, 이 문자열을 넘겨받은 클라이언트의 브라우저의 자바스크립트는 아래와 같은 문자열로 구성되어  있을 경우 
	원하는 데이터를 추출하기가 많이 불편하다...
	참고로, 아래와 같은 형식은 강의 편의상, 전송한 문자열의 예를 보여주기 위함이엇기 때문에, 또 다른 개발자들에 의해서
	저 아래의 데이터 형식은 임의로 바뀔수 있다..
	문제점) 앞으로 우리는 REST API 다룰 것이므로, 추후 REST 서버를 구축하여, 우리의 서버에 요청을 시도하는 다양한 종류의
				클라이언트(스마트폰, 웹브라우저, 자동차,,로봇..) 들에게 데이터를 제공해줄예정인데, 이때 사용할 데이터형식은 전세계적으로 XML 또는 JSON이 압도적이다
	해결책? 전세계 개발자들이 주로 사용하는 표준형식의 데이터를 사용하자 ( 추천-JSON)
	
	JSON 이란? 문자열을 내의 데이터가 유달리 자바스크립트의 객체 리터럴정의 기법을 따르는 경우,  JSON 문자열이라 한다..
	*/
	
	//아래의 json 문자열은 말 그대로 문자열이므로, java는 그냥 String으로 처리한다..
	StringBuffer data= new StringBuffer();


	data.append("[");
	for(int i=0; i<list.size();i++){
		Member2 obj=list.get(i);
		data.append("{");
		data.append(" \"member2_id\" : "+obj.getMember2_id()+" , ");
		data.append("  \"id\" : \"" + obj.getId() +  "\" ,  ");
		data.append("  \"name\" : \""+obj.getName()+ "\" ,  ");
		data.append("  \"email\" : \""+obj.getEmail()+"\" ");
		data.append("}");
		if( i < list.size()-1){
			data.append(","); //쉼표는 리스트의 총 길이-1 보다 작은 경우
		}
	}
	data.append("]");
	System.out.println(data.toString()); 
	
	out.print(data.toString()); //클라이언트인 웹브라우저에게 보내기 
	
	//만일 요청의 유형이 동기방식이 이었다면, 유저는 목록화면을 보아야 하므로, 아래와 같은 코드를 작성해야 함 
	//out.print("location.href=list.jsp;"); 브라우저로 하여금 list.jsp로 다시 들어오라는 명령이므로, 유저의 브라우저는
	//새로운 html을 화면에 렌더링 하게 되어, 유저가 느끼기에는 새로고침(깜빡임)이 발생해버림..
	//따라서 비동기 요청이 들어오면 서버는 절대로 문서 또는 링크를 보내면 안되고, 순수한 데이터만을 보내야 한다..
	//어떤 데이터를 보내야 하나? 응답을 받은 html은 자바스크립트 코드가 관여되기 때문에, js에서 객체를 다룰 수 있는 형태일 경우
	//개발자에게 많은 이점이 있다...그렇다면..보내야 할 데이터의 유형은?? xml--> json 이 대세다!!
			
%>













