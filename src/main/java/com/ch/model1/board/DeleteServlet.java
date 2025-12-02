package com.ch.model1.board;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ch.model1.repository.BoardDAO;

//삭제 요청을 처리하는 서블릿 
//delete from board where board_id=8;
public class DeleteServlet extends HttpServlet{
	BoardDAO boardDAO=new BoardDAO();
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
		
		//파라미터 받기 (파라미터값에 한글이 포함되지 않았으므로, 굳이 request.setCharacterEncoding() 처리는 불필요!!
		String board_id = request.getParameter("board_id");
		
		//DAO 에게 일 시키고 삭제를 처리...
		int result=boardDAO.delete(Integer.parseInt(board_id));
		
		StringBuffer tag=new StringBuffer();
		
		tag.append("<script>");
		if(result<1) {
			tag.append("alert('삭제 실패');");
			tag.append("history.back();");
		}else {
			tag.append("alert('삭제 성공');");
			tag.append("location.href='/board/list.jsp';");
		}
		tag.append("</script>");
		
		PrintWriter out = response.getWriter();
		out.print(tag.toString());
	}
	
}






