<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ch.model1.dto.Board" %>
<%@ page import="com.ch.model1.repository.BoardDAO" %>
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
	
	int totalRecord=list.size(); //총게시물 수 대입
	int pageSize=10; //총 레코드수만큼 출력하면 스크롤이 생기므로, 한 페이지당 보여질 레코드 수 정한다(입맛에 맞게 바꿀수 있음)
	int totalPage=(int)Math.ceil((float)totalRecord/pageSize); //pageSize를 적용해버리면 26건일 경우, 
							//나머지 16건은 볼 기회가 없기 때문에, 나머지 페이지를 보여줄 페이지 링크를 만들어야 하므로, 총 페이지수를 구해야 한다 
	int blockSize=10;//총 페이지수만큼 반복문을 수행하면, 화면에 너무나 많은 페이지가 출력되므로, 블락의 개념을 도입하여 블럭당 보여질 
								//페이지수를 제한하자
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage  = Integer.parseInt(request.getParameter("currentPage"));
	}
	int firstPage=currentPage - (currentPage-1)%blockSize;
	int lastPage=firstPage+(blockSize-1);
	int curPos=(currentPage-1)*pageSize;//페이지당 가져올 List의 시작 인덱스,현재 페이지와 비례하여 10씩 (10은 pageSize)
	int num=totalRecord-curPos;
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
			for(int i=1;i<pageSize;i++){
			if(num<1)break;	//게시물번호가 1보다 작아지면, 더이상 데이터가 없으므로 만일break를 걸지 않으면 List에서 존재하지 않는
										//데이터를 접근하려고 함...out of bounds...
			Board board=(Board)list.get(curPos++);
		%>
		<tr>
			<td><%=num-- %></td>
			<td><a href="/board/detail.jsp?board_id=<%=board.getBoard_id() %>"><%=board.getTitle() %></a></td>
			<td><%=board.getWriter()%></td>
			<td><%=board.getRegdate() %></td>
			<td><%=board.getHit() %></td>
		</tr>
		<%} %>
		<tr>
			<td>
				<button onClick="location.href='/board/write.jsp';">글등록</button>
			</td>
			<td colspan="4">
				<%for(int i=firstPage;i<=lastPage;i++){ %>
					<%if(i>totalPage)break; //총 페이지수 만큼만 돌아라..즉 넘어서면 빠져나오기 %>
					<a href="/board/list.jsp?currentPage=<%=i%>">[<%=i %>]</a>
				<%} %>
			</td>		
		</tr>
		
	</table>

</body>
</html>




