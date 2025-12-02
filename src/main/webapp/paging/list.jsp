<%@ page contentType="text/html; charset=UTF-8"%>
<%
	//하나의 페이지에 많은 량의 데이터가 출력되면, 스크롤이 발생하므로 한페이지당 보여질 레코드수의 제한을 가하고,
	//나머지 데이터에 대해서는 여러 페이지 링크를 지원해주려면, 총 게시물 수에 대해 산수계산이 요구됨..
	
	//기본 전제 조건 - 총 레코드 수가 잇어야 한다..
	int totalRecord=1526; //총 레코드 수
	int pageSize=10; //페이지당 보여질 레코드 수 
	int totalPage=(int)Math.ceil((float)totalRecord/pageSize); //총 페이지 수 
	int blockSize=10; //블럭당 보여질 페이지 수 
	int currentPage=1; //현재 유저가 보고 있는 페이지 , 이 값은 클라이언트의 get 방식으로 전송된 파라미터로 대체
	if(request.getParameter("currentPage") !=null){//파라미터가 존재할때만...파라미터가 널이 아닌 경우..
		currentPage=Integer.parseInt(request.getParameter("currentPage")); //ex)  "7" --> 정수화시켜야함 
	}
%>
<%="totalRecord "+totalRecord +"<br>"%>
<%="pageSize "+pageSize +"<br>"%>
<%="totalPage "+totalPage+"<br>"%>
<%="현재 당신이 보고있는 currentPage= "+currentPage+"<br>"%>

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
a{text-decoration:none;}

/*유저가 현재 보고있는 페이지에 대한 시각적효과를 주기 위함..*/
.numStyle{
	font-size:30px;
	font-weight:bold;
	color:red;
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
		
		<%for(int i=1;i<=pageSize;i++){ %>
		<tr>
			<td>1</td>
			<td>오늘 점심 메뉴는?</td>
			<td>지노</td>
			<td>2025-12-02</td>
			<td>1</td>
		</tr>
		<%} %>
		<tr>
			<td colspan="5" align="center">
				prev
				<%for(int i=1;i<=blockSize;i++){ %>
				<a  <%if(currentPage==i){%> class="numStyle"<%}%>   href="/paging/list.jsp?currentPage=<%=i%>">[<%=i%>]</a>
				<%} %>
				next
			</td>
		</tr>
	</table>

</body>
</html>
