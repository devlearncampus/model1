package com.ch.model1.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.ch.model1.dto.Board;
import com.ch.model1.util.PoolManager;
import com.mysql.cj.exceptions.CJOperationNotSupportedException;

//데이터베이스의 Board table 에 대한 CURD를 수행하는 객체 
public class BoardDAO {
	
	PoolManager pool=new PoolManager();
	
	//Create(=insert)
	//글 1건을 등록하는 메서드 
	public int insert(Board board) {//개발 시 파라미터의 수가 많을때는 낱개로 처리하지 않음,
														//특히 데이터베이스 연동 로직에서는 DTO 를 이용..
		//이 메서드 호출 시 마다, 접속을 일으키는 것이 아니라, Tomcat 이 접속자가 없더라도
		//미리 Connection 들을 확보해 놓은 커넥션풀(Connection Pool)로부터 대여해보자 
		//또한 쿼리문 수행이 완료되더라도, 얻어온 Connection 절대로 닫지 말아야 한다, 반납해야 한다
		Connection con=null;
		PreparedStatement pstmt=null;
		int result=0;  // return 할 예정이므로 try문 밖에 선언!!
		
		try {
			InitialContext context = new InitialContext();
			DataSource pool=(DataSource)context.lookup("java:comp/env/jndi/mysql");
			con=pool.getConnection();
			
			//쿼리수행
			String sql="insert into board(title, writer, content) values(?,?,?)";
			pstmt=con.prepareStatement(sql);
			
			pstmt.setString(1, board.getTitle());
			pstmt.setString(2, board.getWriter());
			pstmt.setString(3, board.getContent());
			
			result = pstmt.executeUpdate();//쿼리 수행 
			
			/* 아래의 코드를 작성하면 않되는 이유?  out을 쓰려고 하는 순간 부터 BoardDAO의 중립성이 사라짐..
			 * 해결책, DAO는 디자인 영역과는 분리된 오직 DB만을 전담하므로, 절대로 디자인코드를 넣어서는 안됨!!
			 *         따라서 디자인 처리는 이 메서드를 호출한자가 처리하도록 , 여기서는 결과만 반환하면 됨...
			if(result <1) {
				System..print("실패");
			}else {
				out.print("성공");
			}
			*/
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(pstmt!=null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}	
			if(con !=null) {
				try {
					//주의 기존 JDBC코드는 다 사용한 커넥션을 닫았지만, 풀로부터 얻어온 커넥션은 닫으면 안됨...
					//이 객체는 DataSource 구현체로부터 얻어온 Connection 이기 때문에 일반적 JDBC 의 닫는 close()가 아님
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				} 
			}
			
		}
		
		return result;
		
	}
	
	
	//Read(=select) - 모든 데이터 가져오기 
	public List selectAll() {
		//커넥션 얻는 코드를 이 메서드에서 손수하지말자!! PoolManager 가 대신 해주므로...
		Connection con=pool.getConnection();//풀매니저로부터 커넥션 객체를 얻어옴!! ,여기서 직접 검색하면 jndi 검색코드 중복되므로..
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		List<Board> list=new ArrayList();//모든 게시물을 모아놓을 리스트...여기에 들어가는 객체는 바로 DTO 인스턴스 들이다..
														//현재까지는 아무것도 채워넣지 않았기 때문에 size 가 0 이다!
		
		try {
			String sql="select board_id, title, writer, regdate, hit from  board ";
			pstmt=con.prepareStatement(sql);
			rs=pstmt.executeQuery();//select문 의 반환값은 ResultSet 임 
			
			//rs는 무조건 이 메서드에서 닫아야 하므로, 외부의 jsp는 디자인을 담당하는 코드이지, ResultSet의 존재를 알필요도 없고,
			//또한 ResulSet db연동기술이므로, 오직 DAO에서만 제어해야 한다..따라서 finally에서 rs를 닫는것은 DAO의 의무이다!!
			//모순 - rs를 닫아버린 상태에서 외부 객체에게 전달해주면 외부객체는 이 rs를 사용할 수 없다 closed되어 있으므로,.
			//해결책?? rs가 죽어도 상관없는 비슷한 유형의 객체로 데이터를 표현하면 된다...
			//	         이 문제를 해결하기 위해 필요한 객체들의 조건 
			//			1) 현실에 존재하는 사물을 표현할 수 잇는 객체가 필요하다..(예- 게시물 1건을 담을수 있는 존재) -Board  DTO
			//			2) Board DTO로부터 생성된 게시물을 표현한 인스턴스들을 모아놓을 객체가 필요하다(순서O, 객체를 담을수 있어야함)
			//              이 조건을 만족하는 객체는? 자바의 컬렉션 프레임웍 중 List 이다!!
			// collection framework 이란? java.util 에서 지원하는 라이브러리로서, 오직 객체만을 모아서 처리할때 유용한 api	
			
			while(rs.next()) { //커서를 이동하면서 true 인 동안만...즉 모든 레코드 만큼...
				Board board = new Board();  //게시물 한건을 담을 수 잇는 Board DTO 클래스의 인스턴스 1개 준비..(텅..) 
				board.setBoard_id(rs.getInt("board_id")); //pk 담기 
				board.setTitle(rs.getString("title")); //title 담기 
				board.setWriter(rs.getString("writer"));//작성자 담기 
				board.setRegdate(rs.getString("regdate"));
				board.setHit(rs.getInt("hit"));
				
				list.add(board); //List에 인스턴스 1개 추가
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			//con, pstmt, rs를 대신 닫아주는 메서드 호출 
			pool.freeConnection(con, pstmt, rs);
		}
		return list; //rs를 대용할 수 잇는 더욱 객체지향적인 형태로 반환...
	}
	
	//레코드 한건 가져오기 
	public Board select(int board_id) {
		//쿼리 실행을 하기 위한 데이터베이스 접속은 현재 코드에서 시도하지 말고, 
		//서버 가동과 동시에 확보해놓은 커넥션풀로부터 가져오자!!
		Connection con=pool.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Board board=null;
		
		try {
			String sql="select * from board where board_id=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, board_id);
			rs=pstmt.executeQuery();//select문 실행!!!!
			
			//rs가 죽어도 상관없으려면, 게시물 1건을 표현할 수 있는 대체제를 사용해야 함 
			//DB의 레코드 1건은 java의 DTO 인스턴스 1개와 매핑...
			if(rs.next()) { //next()가 true인 경우 즉 쿼리 실행에 의해 조건에 맞는 레코드가  존재할때만 DTO를 반환하자
				board = new Board(); //empty 텅빈 상태
				
				//ResultSet 이 보유하고 있었던 데이터를 DTO로 옮기기 
				board.setBoard_id(rs.getInt("board_id")); //board_id
				board.setTitle(rs.getString("title")); //title
				board.setWriter(rs.getString("writer")); //writer
				board.setContent(rs.getString("content")); //content
				board.setRegdate(rs.getString("regdate")); //regdate
				board.setHit(rs.getInt("hit")); //hit
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return board;
	}
	
	//U(=update) , 레코드 1건 수정 
	public int update(Board board) {//호출자로 하여금 파라미터를 모아서 달라는 뜻~~
		Connection con=null;
		PreparedStatement pstmt=null;
		int result=0;//쿼리 실행 결과를 반환할 지역변수 , 지역변수이다 보니 개발자가 직접 초기화해야 한다..
		
		con=pool.getConnection(); //새로운 접속이 아니라, 이미 접속이 확보된 풀로부터 대여!!
		String sql="update board set title=?, writer=?, content=? where board_id=?";
		
		try {
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, board.getTitle());
			pstmt.setString(2, board.getWriter());
			pstmt.setString(3, board.getContent());
			pstmt.setInt(4,board.getBoard_id());
			
			result=pstmt.executeUpdate();//DML 수행
			
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt);
		}
		return result;
	}
	
	//D(=delete)  레코드 한건 삭제 
	public int delete(int board_id) {
		Connection con=null;
		PreparedStatement pstmt=null;
		int result=0; //삭제 후 반환할 값  
		
		con=pool.getConnection();
		
		String sql="delete from board where board_id=?";
		try {
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, board_id);
			result=pstmt.executeUpdate();//쿼리수행
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt); //DML 수행 후 반납 
		}
		return result;
		
	}
	
	
}






















