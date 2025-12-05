<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ch.model1.repository.NewsDAO" %>
<%!
	//목록 가져오기 
	NewsDAO newsDAO=new NewsDAO();
%>
<%
	
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
		
		<tr>
			<td><%//=num-- %></td>
			<td><a href="/board/detail.jsp?board_id=<%//=board.getBoard_id() %>"><%//=board.getTitle() %></a></td>
			<td><%//=board.getWriter()%></td>
			<td><%//=board.getRegdate() %></td>
			<td><%//=board.getHit() %></td>
		</tr>
		
		<tr>
			<td>
				<button onClick="location.href='/board/write.jsp';">글등록</button>
			</td>
			<td colspan="4">
				
			</td>		
		</tr>
		
	</table>

</body>
</html>




