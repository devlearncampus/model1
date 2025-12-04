package com.ch.model1.util;

import java.security.spec.DSAGenParameterSpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

//DAO의 각 메서드마다 커넥션풀로부터 Connection을 얻어오는 코드를 중복 작성할 경우 유지보수성이 떨어짐..
//예) JNDI명칭이 바뀌거나, 연동할 db의 종류가 바뀌는 등,.외부의 어떤 변화원인에 의해 코드가 영향을 많이 받으면 안됨..
//따라서 앞으로는 커넥션풀로부터 Connection 을 얻거나 반납하는 중복된 코드는 아래의 클래스로 처리하면 유지보수성이 올라감..
public class PoolManager {
	private static PoolManager instance; //instance라는 변수명은 강제사항은 아니지만, 개발자들 사이에서는 싱글턴에 의해
															//인스턴스를 얻어갈수 있다는 약속때문에 많이 선언..
	DataSource ds;
	
	//외부에서 아무도 직접 new 못하게 막자
	private PoolManager() {
		try {
			InitialContext context = new InitialContext();
			ds=(DataSource)context.lookup("java:comp/env/jndi/mysql");
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}
	
	public static PoolManager getInstance() {
		//클래스변수인 instance 변수에 아무것도 존재하지 않을때는 아직 인스턴스가 없는것이므로
		//그때 한번만  new 해주자
		//PoolManager를 싱글턴으로 선언하면, 자바엔터프라지 개발에서 수많은DAO들이 PoolManager를 매번 인스턴스 생성하는 
		//낭비를 방지할 수 있다..
		if(instance==null) {
			instance = new PoolManager();
		}
		return instance;
	}
	
	//외부의 DAO 들이 직접 Connection을 얻는 코드를 작성하게 하지 않으려면, 이 PoolManager클래스에서 
	//DAO 대신 Connection 얻어와서 반환해주자 
	public Connection getConnection() {
		Connection con=null;
		try {
			con=ds.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return con;
	}
	
	//빌려간 커넥션을 반납!!
	public void freeConnection(Connection con) {
		if(con !=null) {
			try {
				//주의) 기존 JDBC코드는 다 사용한 커넥션을 닫았지만, 풀로부터 얻어온 커넥션은 닫으면 안됨...
				//이 객체는 DataSource 구현체로부터 얻어온 Connection 이기 때문에 일반적 JDBC 의 닫는 close()가 아님
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	//아래의 오버로딩된 메서드는 DML 수행후 반납할때 사용하기
	public void freeConnection(Connection con, PreparedStatement pstmt) {
		if(pstmt !=null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if(con !=null) {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void freeConnection(Connection con, PreparedStatement pstmt, ResultSet rs) {
		if(rs !=null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		if(pstmt !=null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if(con !=null) {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	
}





