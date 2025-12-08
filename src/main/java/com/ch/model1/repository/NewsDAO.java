package com.ch.model1.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ch.model1.dto.News;
import com.ch.model1.util.PoolManager;

/*News 테이블에 대한 CRUD만을 수행하는 DAO*/
public class NewsDAO {
	PoolManager poolManager=PoolManager.getInstance();
	
	//게시물 한건 넣기!
	public int insert(News news) {
		Connection con=null;
		PreparedStatement pstmt=null;
		int result=0;
		
		con=poolManager.getConnection();//접속 객체 대여!!
		String sql="insert into news(title, writer, content) values(?,?,?)";
		
		try {
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, news.getTitle());
			pstmt.setString(2, news.getWriter());
			pstmt.setString(3, news.getContent());
			result=pstmt.executeUpdate();//쿼리 실행
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			poolManager.freeConnection(con, pstmt);
		}
		return result;
	}
	
	//모든 레코드 가져오기 
	public List selectAll() {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		List list=new ArrayList();
		
		con=poolManager.getConnection();
		
		StringBuffer sb = new StringBuffer();
		sb.append("select n.news_id as news_id, title, writer, regdate,hit, count(comment_id) as cnt");
		sb.append(" from news n left outer join comment c");
		sb.append(" on n.news_id = c.news_id");
		sb.append(" group by n.news_id, title, writer, regdate,hit");
		sb.append(" order by n.news_id desc");
		
		System.out.println(sb.toString());
		
		
		try {
			pstmt=con.prepareStatement(sb.toString());
			rs=pstmt.executeQuery();//rs 생성
			
			while (rs.next()) {
				News dto = new News();	
				dto.setNews_id(rs.getInt("news_id"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setHit(rs.getInt("hit"));
				dto.setCnt(rs.getInt("cnt"));
				
				list.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			poolManager.freeConnection(con, pstmt, rs);
		}
		return list;
	}
	
	//한컨 레코드 가져오기 
	public News select(int news_id) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		News dto=null; //한건 이므로 뉴스 1개를 반환 
		
		con=poolManager.getConnection();
		
		String sql="select * from news where news_id=?"; 
		try {
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, news_id);
			rs=pstmt.executeQuery();//rs 생성
			
			if(rs.next()) {//레코드가 있다면.. 
				dto = new News();	
				dto.setNews_id(rs.getInt("news_id"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setContent(rs.getString("content"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setHit(rs.getInt("hit"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			poolManager.freeConnection(con, pstmt, rs);
		}
		return dto;
	}
	
}









