package com.doit.dao;
import com.doit.jydto.*;
import com.doit.util.DBCPConn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class AdminUserDAO
{
	// 관리자가 모든 회원을 조회하는 메소드
	public List<ShowUserDTO> showAllUsers() throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		
		List<ShowUserDTO> list = new ArrayList<>();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		ShowUserDTO dto = null;
		
		try
		{
			String sql = "SELECT USERKEY, USERID, USERNAME, USERTEL, USERCREATED, USERSTATUS"
					+ " FROM VIEW_ADMIN_USER_LIST"
					+ " ORDER BY USERKEY DESC";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				dto = new ShowUserDTO();
				
				dto.setUserKey(rs.getInt("USERKEY"));
				dto.setUserId(rs.getString("USERID"));
				dto.setUserName(rs.getString("USERNAME"));
				dto.setUserTel(rs.getString("USERTEL"));
				dto.setUserCreated(rs.getString("USERCREATED"));
				dto.setUserStatus(rs.getString("USERSTATUS"));
				
				list.add(dto);
			}
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if (rs != null) {
                rs.close();
            }
			if (pstmt != null) {
                pstmt.close();
            }
			if (conn != null) {
	            DBCPConn.close(conn);
	        }
		}
		return list;
	}
	
	// 1. 페이징 + 검색 포함 리스트 조회
	public List<ShowUserDTO> showAllUsers(int start, int end, String searchType, String searchKeyword) throws SQLException {
	    List<ShowUserDTO> list = new ArrayList<>();
	    
	    // 검색 조건 동적 생성 (null 및 빈 문자열 체크)
	    String searchCondition = "";
	    boolean isSearch = (searchKeyword != null && !searchKeyword.trim().isEmpty());

	    if (isSearch) {
	        if ("id".equals(searchType)) {
	            searchCondition = " WHERE USERID LIKE ? ";
	        } else if ("name".equals(searchType)) {
	            searchCondition = " WHERE USERNAME LIKE ? ";
	        }
	    }

	    // 쿼리 조립 (ORDER BY를 USERKEY로 변경)
	    String sql = "SELECT * FROM ("
	               + "  SELECT rownum AS rnum, a.* FROM ("
	               + "    SELECT * FROM VIEW_ADMIN_USER_LIST " + searchCondition + " ORDER BY USERKEY DESC"
	               + "  ) a WHERE rownum <= ?"
	               + ") WHERE rnum >= ?";

	    try (Connection conn = DBCPConn.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        int paramIdx = 1;
	        if (isSearch) {
	            pstmt.setString(paramIdx++, "%" + searchKeyword + "%");
	        }
	        pstmt.setInt(paramIdx++, end);
	        pstmt.setInt(paramIdx++, start);

	        ResultSet rs = pstmt.executeQuery();
	        while (rs.next()) {
	            ShowUserDTO dto = new ShowUserDTO();
	            // 뷰 컬럼명(USERKEY, USERID 등)에 맞춰 데이터 매핑
	            dto.setUserKey(rs.getInt("USERKEY"));
	            dto.setUserId(rs.getString("USERID"));
	            dto.setUserName(rs.getString("USERNAME"));
	            dto.setUserTel(rs.getString("USERTEL"));
	            dto.setUserCreated(rs.getString("USERCREATED"));
	            dto.setUserStatus(rs.getString("USERSTATUS"));
	            list.add(dto);
	        }
	    }
	    return list;
	}
	
	
	// 2. 전체 데이터 개수 조회 (검색 조건 포함)
	public int getTotalCount(String searchType, String searchKeyword) throws SQLException {
	    boolean isSearch = (searchKeyword != null && !searchKeyword.trim().isEmpty());
	    String sql = "SELECT COUNT(*) FROM VIEW_ADMIN_USER_LIST";
	    
	    if (isSearch) {
	        if ("id".equals(searchType)) sql += " WHERE USERID LIKE ?";
	        else if ("name".equals(searchType)) sql += " WHERE USERNAME LIKE ?";
	    }

	    try (Connection conn = DBCPConn.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        if (isSearch) {
	            pstmt.setString(1, "%" + searchKeyword + "%");
	        }
	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) return rs.getInt(1);
	    }
	    return 0;
	}
	
	
	// 관리자가 회원 상세 정보를 조회하는 메소드
	public ShowUserDTO showUserDetail(int userKey) throws SQLException {
	    Connection conn = DBCPConn.getConnection();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ShowUserDTO dto = null;
	    
	    try {
	        String sql = "SELECT USER_ID, USER_LOGIN_ID, USER_NAME, USER_SSN,"
	                + " USER_EMAIL, USER_PHONE, USER_ADDRESS, USER_ADDRESS_DETAIL,"
	                + " CREATED_AT, USER_STATUS"
	                + " FROM VIEW_USER_INFO"
	                + " WHERE USER_ID = ?";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, userKey);
	        
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) { // 한 명의 정보이므로 while 대신 if 사용
	            dto = new ShowUserDTO(); // 객체 생성 필수!
	            
	            dto.setUserKey(rs.getInt("USER_ID"));
	            dto.setUserId(rs.getString("USER_LOGIN_ID"));
	            dto.setUserName(rs.getString("USER_NAME"));
	            dto.setUserSsn(rs.getString("USER_SSN"));
	            dto.setUserEmail(rs.getString("USER_EMAIL"));
	            dto.setUserTel(rs.getString("USER_PHONE"));
	            dto.setUserAddress(rs.getString("USER_ADDRESS") + " " + rs.getString("USER_ADDRESS_DETAIL"));
	            dto.setUserCreated(rs.getString("CREATED_AT"));
	            dto.setUserStatus(rs.getString("USER_STATUS"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        if (conn != null) DBCPConn.close(conn);
	    }
	    return dto; 
	}
	
	// 전체 회원 수 조회
	public int getTotalCount() throws SQLException {
		
	    String sql = "SELECT COUNT(*) FROM VIEW_ADMIN_USER_LIST";
	    
	    try (Connection conn = DBCPConn.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) 
	    {
	        if (rs.next())
	        	return rs.getInt(1);
	    }
	    return 0;
	}
	
	
	// 1. 패널티 내역 목록 조회 (페이징 + 아이디 검색)
	public List<ShowUserPenaltyDTO> getPenaltyList(int start, int end, String searchKeyword) throws SQLException {
	    List<ShowUserPenaltyDTO> list = new ArrayList<>();
	    
	    // [수정] 검색 대상을 USER_ID(숫자)가 아닌 USER_LOGIN_ID(문자열 아이디)로 변경
	    String searchCondition = (searchKeyword != null && !searchKeyword.trim().isEmpty()) 
	                             ? " WHERE USER_LOGIN_ID LIKE ? " : "";

	    String sql = "SELECT * FROM ("
	               + "  SELECT rownum AS rnum, a.* FROM ("
	               + "    SELECT * FROM VW_PENALTY_LIST " + searchCondition + " ORDER BY PENALTY_ID DESC"
	               + "  ) a WHERE rownum <= ?"
	               + ") WHERE rnum >= ?";

	    try (Connection conn = DBCPConn.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        int paramIdx = 1;
	        if (!searchCondition.isEmpty()) {
	            pstmt.setString(paramIdx++, "%" + searchKeyword + "%");
	        }
	        pstmt.setInt(paramIdx++, end);
	        pstmt.setInt(paramIdx++, start);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                ShowUserPenaltyDTO dto = new ShowUserPenaltyDTO();
	                // [추가] 뷰에서 조인해서 가져온 실제 로그인 아이디 세팅
	                dto.setUserLoginId(rs.getString("USER_LOGIN_ID")); 
	                
	                dto.setUserId(rs.getString("USER_ID")); // 고유키(숫자)는 그대로 유지
	                dto.setPenaltyId(rs.getInt("PENALTY_ID"));
	                dto.setGivenScore(rs.getInt("GIVEN_SCORE"));
	                dto.setAccumulatedScore(rs.getInt("ACCUMULATED_SCORE"));
	                dto.setTotalScore(rs.getInt("TOTAL_SCORE"));
	                dto.setPenaltyStatus(rs.getString("PENALTY_STATUS"));
	                dto.setStartDate(rs.getString("START_DATE"));
	                dto.setEndDate(rs.getString("END_DATE"));
	                dto.setHistoryStatus(rs.getString("HISTORY_STATUS"));
	                list.add(dto);
	            }
	        }
	    }
	    return list;
	}

	// 2. 전체 내역 개수 조회 (검색 조건 포함)
	public int getTotalPenaltyCount(String searchKeyword) throws SQLException {
	    // [수정] 여기도 USER_LOGIN_ID로 검색하도록 변경
	    String sql = "SELECT COUNT(*) FROM VW_PENALTY_LIST";
	    boolean isSearch = (searchKeyword != null && !searchKeyword.trim().isEmpty());
	    
	    if (isSearch) sql += " WHERE USER_LOGIN_ID LIKE ?";

	    try (Connection conn = DBCPConn.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        if (isSearch) pstmt.setString(1, "%" + searchKeyword + "%");
	        
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) return rs.getInt(1);
	        }
	    }
	    return 0;
	}
	
	
	
}
