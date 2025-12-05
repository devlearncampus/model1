<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ch.model1.repository.Member2DAO" %>
<%@ page import="com.ch.model1.dto.Member2" %>
<%@ page import="java.util.List" %>
<%!
	Member2DAO dao = new Member2DAO();
%>
<%
	//클라이언트의 비동기적 요청이 들어오면, 서버는 HTML(X), 데이터(O) 만 보내야 한다 
	//목록 가져오기 
	List<Member2> list=dao.selectAll();
	
	//클라이언트가 이해할 수 있는 데이터형식으로 응답, 여기서는 클라이언트가 웹브라우저 이므로 
	//JSON으로 응답하겠다(JSON은 중립적 문자열이기 때문에, 스마트폰, 각종 디바이스에 이해할 수 있는 형식의 데이터이다)
	//아래의 json 문자열은 말 그대로 문자열이므로, java는 그냥 String으로 처리한다..
	StringBuffer data= new StringBuffer();

	data.append("[");
	for(int i=0; i<list.size();i++){
		Member2 obj=(Member2)list.get(i);
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

%>