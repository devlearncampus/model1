<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ch.model1.repository.BoardDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ch.model1.dto.Board" %>
<%!
	//!를 표기하면, 선언부를 의미...선언부란 이 jsp가 추후 서블릿으로 변경될때 멤버영역
	BoardDAO boardDAO=new BoardDAO();
%>
<%
	//이 영역은 스크립틀릿이기 때문에, 이 jsp파일이 서블릿으로 변환될때 service() 영역이므로
	//얼마든지 DB연동 가능하다..
	//하지만 하면 안됨!!!!!  그 이유?? 디자인 코드와 데이터베이스 연동코드가 하나로 합쳐(스파게티)져 있으면 
	//추후 DB연동 코드를 재사용할 수 없다...
	List<Board> list=boardDAO.selectAll(); //모든 레코드 가져오기!!!
	out.print("등록된 게시물 수는 "+ list.size());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8>

<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
table {
	border-collapse: collapse;
	border-spacing: 0;
	width: 100%;
	border: 1px solid #ddd;
}

th, td {
	text-align: left;
	padding: 16px;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}
</style>
</head>
<body>

	<table>
		<tr>
			<th>No</th>
			<th>제목</th>
			<th>작성자</th>
			<th>등록일</th>
			<th>조회수</th>
		</tr>
		
		<%
			//rs에 들어있는 레코드들을 한칸씩 이동하면서 꺼내자 출력하자
			//rs.next()가 true인 동아(즉 레코드가 존재하는 만큼..)
			//java List 신축성있는 배열..
			for(int i=0;i<list.size();i++){
			Board board=(Board)list.get(i);
		%>
		<tr>
			<td>Jill</td>
			<td><a href="/board/detail.jsp?board_id=<%=board.getBoard_id() %>"><%=board.getTitle() %></a></td>
			<td><%=board.getWriter()%></td>
			<td><%=board.getRegdate() %></td>
			<td><%=board.getHit() %></td>
		</tr>
		<%} %>
	</table>

</body>
</html>




