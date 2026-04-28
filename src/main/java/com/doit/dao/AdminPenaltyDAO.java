package com.doit.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.doit.dto.PenaltyHistoryDTO;
import com.doit.util.DBCPConn;

public class AdminPenaltyDAO
{
	// 패널티 등록
	public int insertPenalty(PenaltyHistoryDTO phDto) throws SQLException
	{
		int result = 0;
		
		String sql = "{ call PRC_PENALTY_ASSIGN(?, ?, ?, ?) }";
		
		try(Connection conn = DBCPConn.getConnection();
			CallableStatement cstmt = conn.prepareCall(sql);
		   )
		{
			cstmt.setInt(1, phDto.getUserId());
			cstmt.setInt(2, phDto.getAdminAccountId());
			cstmt.setInt(3, phDto.getPenaltyTypeId());
			cstmt.setInt(4, phDto.getPenaltyScore());

			result = cstmt.executeUpdate();
		}
		catch (SQLException e)
		{
			int errorCode = e.getErrorCode();
			
			if (errorCode >= 20100 && errorCode <= 20101)
			{
				throw new SQLException(e.getMessage(), e.getSQLState(), e.getErrorCode());
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException("DB 작업 에러 발생: " + e.getMessage(), e);
		}
		
		return result;
	}
	
	
	
	// 패널티 이력 리스트 가져오기 (패널티 취소 정보 포함)
	public List<PenaltyHistoryDTO> selectPenaltyHistoryList(int page, int sizePerPage)
	{
		List<PenaltyHistoryDTO> result = new ArrayList<>();
		
		String sql = "SELECT *"
					+ " FROM ("
					+ "		SELECT"
					+ "			ROW_NUMBER() OVER(ORDER BY PH.PENALTY_ID DESC) AS PENALTY_NUM,"
					+ "			PH.PENALTY_ID,"
					+ "			PH.USER_ID,"
					+ "			PH.PENALTY_TYPE_ID,"
					+ "			PH.ADMIN_ACCOUNT_ID,"
					+ "			PH.PENALTY_SCORE,"
					+ "			TO_CHAR(PH.CREATED_AT, 'YYYY-MM-DD HH24:MI:SS') AS CREATED_AT,"
					+ "			PC.PENALTY_CANCEL_ID,"
					+ "			PC.ADMIN_ACCOUNT_ID AS CANCEL_ADMIN_ACCOUNT_ID,"
					+ "			PC.CANCEL_REASON,"
					+ "			TO_CHAR(PC.CANCELED_AT, 'YYYY-MM-DD HH24:MI:SS') AS CANCELED_AT"
					+ "		FROM"
					+ "			PENALTY_HISTORY PH LEFT OUTER JOIN PENALTY_CANCEL PC"
					+ "	  		ON PH.PENALTY_ID = PC.PENALTY_ID"
					+ ") "
					+ " WHERE PENALTY_NUM >= ?"		// 시작번호
					+ "   AND PENALTY_NUM <= ?";	// 끝번호
		
		// 현재 페이지의 데이터 시작 번호, 끝 번호 구하기
		int dataStartNum = (page - 1) * sizePerPage + 1;
		int dataEndNum = page * sizePerPage;
		
		
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
		   )
		{
			pstmt.setInt(1, dataStartNum);
			pstmt.setInt(2, dataEndNum);
			
			try(ResultSet rs = pstmt.executeQuery();)
			{
				while (rs.next())
				{
					PenaltyHistoryDTO dto = new PenaltyHistoryDTO();
					
					// 패널티 등록 정보
					dto.setPenaltyId(rs.getInt("PENALTY_ID"));
					dto.setUserId(rs.getInt("USER_ID"));
					dto.setPenaltyTypeId(rs.getInt("PENALTY_TYPE_ID"));
					dto.setAdminAccountId(rs.getInt("ADMIN_ACCOUNT_ID"));
					dto.setPenaltyScore(rs.getInt("PENALTY_SCORE"));
					dto.setCreatedAt(rs.getString("CREATED_AT"));
					
					// 패널티 취소 정보
					dto.setPenaltyCancelId(rs.getInt("PENALTY_CANCEL_ID"));
					dto.setCancelAdminAccountId(rs.getInt("CANCEL_ADMIN_ACCOUNT_ID"));
					dto.setCancelReason(rs.getString("CANCEL_REASON"));
					dto.setCanceledAt(rs.getString("CANCELED_AT"));
					
					result.add(dto);
				}
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException("DB 작업 중 에러 발생: " + e.getMessage(), e);
		}
		
		
		return result;
	}
	
	
	
	// 패널티 이력 전체 갯수 가져오기
	public int selectPenaltyHistoryTotalCount()
	{
		int result = 0;
		
		String sql = "SELECT COUNT(*) AS TOTAL_COUNT FROM PENALTY_HISTORY";
		
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();)
		{
			if (rs.next())
			{
				result = rs.getInt("TOTAL_COUNT");
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException("DB 작업 중 에러 발생: " + e.getMessage(), e);
		}
		
		
		return result;
	}
	
	
	
	// 패널티 취소
	public int insertPenaltyCancel(int penaltyId, int adminAccountId, String cancelReason)
	{
		int result = 0;
		
		String sql = "{ call PRC_PENALTY_CANCEL(?, ?, ?) }";
		
		try(Connection conn = DBCPConn.getConnection();
			CallableStatement cstmt = conn.prepareCall(sql);
		   )
		{
			cstmt.setInt(1, penaltyId);
			cstmt.setInt(2, adminAccountId);
			cstmt.setString(3, cancelReason);
			
			result = cstmt.executeUpdate();
		}
		catch (Exception e)
		{
			throw new RuntimeException("DB 작업 중 에러 발생: " + e.getMessage(), e);
		}
		
		return result;
	}
	
}// class AdminPenaltyDAO END