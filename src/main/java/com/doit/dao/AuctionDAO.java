package com.doit.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.doit.dto.AuctionDTO;
import com.doit.dto.ReportDTO;
import com.doit.dto.ReportTypeDTO;
import com.doit.util.DBCPConn;

public class AuctionDAO {

	// 경매 목록 조회 - 페이징 + 키워드
	public List<AuctionDTO> selectAuctionList(int start, int end, String searchKeyword) throws SQLException {
		List<AuctionDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT * FROM (" + "    SELECT ROWNUM rnum, a.* FROM ("
				+ "        SELECT AUCTION_ID, AUCTION_TITLE, START_PRICE,"
				+ "               AUCTION_START_DATE, AUCTION_END_DATE, IS_FINISHED,"
				+ "               PRODUCT_ID, PRODUCT_RELEASE_NAME,"
				+ "               MANUFACTURER_NAME, PRODUCT_GRADE_NAME, IMAGE_PATH_1,"
				+ "               BID_CURRENT_PRICE, BID_COUNT" + "        FROM VW_AUCTION_LIST"
				+ "        WHERE IS_FINISHED = '진행중'" + "        AND AUCTION_TITLE LIKE ?"
				+ "        ORDER BY AUCTION_ID DESC" + "    ) a" + ") WHERE rnum BETWEEN ? AND ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,
					(searchKeyword == null || searchKeyword.trim().isEmpty()) ? "%" : "%" + searchKeyword.trim() + "%");
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				AuctionDTO dto = new AuctionDTO();
				dto.setAuctionId(rs.getInt("AUCTION_ID"));
				dto.setAuctionTitle(rs.getString("AUCTION_TITLE"));
				dto.setStartPrice(rs.getInt("START_PRICE"));
				dto.setAuctionStartDate(rs.getString("AUCTION_START_DATE"));
				dto.setAuctionEndDate(rs.getString("AUCTION_END_DATE"));
				dto.setIsFinished(rs.getString("IS_FINISHED"));
				dto.setProductId(rs.getInt("PRODUCT_ID"));
				dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
				dto.setManufacturerName(rs.getString("MANUFACTURER_NAME"));
				dto.setProductGradeName(rs.getString("PRODUCT_GRADE_NAME"));
				dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
				dto.setBidCurrentPrice(rs.getInt("BID_CURRENT_PRICE"));
				dto.setBidCount(rs.getInt("BID_COUNT"));
				list.add(dto);
			}
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 경매 전체 건수 (페이징 계산용)
	public int selectAuctionCount(String searchKeyword) throws SQLException {
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String sql = "SELECT COUNT(*) FROM VW_AUCTION_LIST" + " WHERE IS_FINISHED = '진행중'"
				+ " AND AUCTION_TITLE LIKE ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,
					(searchKeyword == null || searchKeyword.trim().isEmpty()) ? "%" : "%" + searchKeyword.trim() + "%");
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			DBCPConn.close(conn);
		}
		return count;
	}

	// 경매 상세 조회
	public AuctionDTO selectAuctionDetail(int auctionId) throws SQLException {
		AuctionDTO dto = null;
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT AUCTION_ID, USER_ID, AUCTION_TITLE, AUCTION_CONTENT, START_PRICE,"
				+ "       AUCTION_PERIOD_ID, AUCTION_PERIOD_NAME,"
				+ "       AUCTION_START_DATE, AUCTION_END_DATE, IS_FINISHED,"
				+ "       PRODUCT_ID, PRODUCT_RELEASE_NAME, PRODUCT_ALIAS,"
				+ "       MANUFACTURER_NAME, PRODUCT_GRADE_NAME, IMAGE_PATH_1,"
				+ "       BID_CURRENT_PRICE, BID_MAX_PRICE, BID_COUNT" + " FROM VW_AUCTION_LIST"
				+ " WHERE AUCTION_ID = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, auctionId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				dto = new AuctionDTO();
				dto.setAuctionId(rs.getInt("AUCTION_ID"));
				dto.setAuctionTitle(rs.getString("AUCTION_TITLE"));
				dto.setAuctionContent(rs.getString("AUCTION_CONTENT"));
				dto.setStartPrice(rs.getInt("START_PRICE"));
				dto.setAuctionPeriodId(rs.getInt("AUCTION_PERIOD_ID"));
				dto.setAuctionPeriodName(rs.getString("AUCTION_PERIOD_NAME"));
				dto.setAuctionStartDate(rs.getString("AUCTION_START_DATE"));
				dto.setAuctionEndDate(rs.getString("AUCTION_END_DATE"));
				dto.setIsFinished(rs.getString("IS_FINISHED"));
				dto.setProductId(rs.getInt("PRODUCT_ID"));
				dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
				dto.setProductAlias(rs.getString("PRODUCT_ALIAS"));
				dto.setManufacturerName(rs.getString("MANUFACTURER_NAME"));
				dto.setProductGradeName(rs.getString("PRODUCT_GRADE_NAME"));
				dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
				dto.setBidCurrentPrice(rs.getInt("BID_CURRENT_PRICE"));
				dto.setBidCount(rs.getInt("BID_COUNT"));

				// 입찰이 없으면 NULL → Integer
				int maxPrice = rs.getInt("BID_MAX_PRICE");
				dto.setBidMaxPrice(rs.wasNull() ? null : maxPrice);
			}
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			DBCPConn.close(conn);
		}
		return dto;
	}

	// 경매 신고 등록 - PRC_REPORT_CREATE 프로시저 호출
	public void insertAuctionReport(ReportDTO dto) throws SQLException {
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;

		try {
			String sql = "{CALL PRC_REPORT_CREATE(?, ?, ?, ?, ?)}";
			cstmt = conn.prepareCall(sql);

			cstmt.setInt(1, dto.getUserId()); // P_USER_ID
			cstmt.setInt(2, dto.getReportTypeId()); // P_REPORT_TYPE
			cstmt.setInt(3, dto.getAuctionId()); // P_TARGET_ID
			cstmt.setInt(4, 2); // P_TARGET_TYPE (경매 고정)
			cstmt.setString(5, dto.getReportReason()); // P_REPORT_REASON

			cstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (cstmt != null)
				try {
					cstmt.close();
				} catch (Exception e) {
				}
			DBCPConn.close(conn);
		}
	}

	// 신고 유형 목록 조회 (auctionReport.jsp)
	public List<ReportTypeDTO> selectReportTypeList() throws SQLException {
		List<ReportTypeDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT REPORT_TYPE_ID, REPORT_TYPE_NAME" + " FROM REPORT_TYPE ORDER BY REPORT_TYPE_ID ASC";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ReportTypeDTO dto = new ReportTypeDTO();
				dto.setReportTypeId(rs.getInt("REPORT_TYPE_ID"));
				dto.setReportTypeName(rs.getString("REPORT_TYPE_NAME"));
				list.add(dto);
			}
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 현재 유저의 진행중 입찰 참여 수 10개 이상이면 auctionDetail.jsp 에서 입찰 참여 불가 처리
	public int selectActiveBidCount(int userId) throws SQLException {
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String sql = "SELECT COUNT(*) FROM AUCTION_BID_PARTICIPATION" + " WHERE USER_ID = ?"
				+ " AND FN_IS_AUCTION_FINISHED(AUCTION_ID) = 0";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			DBCPConn.close(conn);
		}
		return count;
	}

	// 경매 현재가 조회
	public int getAuctionCurrentPrice(int auctionId) throws SQLException {
		int price = 0;
		String sql = "SELECT FN_GET_AUCTION_CURRENT_PRICE(?) FROM DUAL";

		try (Connection conn = DBCPConn.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, auctionId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next())
					price = rs.getInt(1);
			}
		}
		return price;
	}

	// 입찰 단위 조회
	public int getBidUnit(int startPrice) throws SQLException {
		int unit = 0;
		String sql = "SELECT FN_GET_BID_UNIT(?) FROM DUAL";

		try (Connection conn = DBCPConn.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, startPrice);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next())
					unit = rs.getInt(1);
			}
		}
		return unit;
	}

	// 최초 입찰 여부 확인 ('Y' 또는 'N')
	public String isFirstBidder(int auctionId) throws SQLException {
		String result = "N";
		String sql = "SELECT FN_IS_FIRST_BIDDER(?) FROM DUAL";

		try (Connection conn = DBCPConn.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, auctionId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next())
					result = rs.getString(1);
			}
		}
		return result;
	}

	// 해당 경매의 낙찰자인지 확인
	public boolean isAuctionWinner(int auctionId, int userId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM AUCTION_WINNING_RESULT AWR"
				+ " JOIN AUCTION_BID_PARTICIPATION ABP ON AWR.BID_ID = ABP.BID_ID"
				+ " WHERE ABP.AUCTION_ID = ? AND ABP.USER_ID = ?";

		try (Connection conn = DBCPConn.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, auctionId);
			pstmt.setInt(2, userId);
			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}
		}
	}

	// 해당 경매에 입찰한 적 있는지 확인
	public boolean hasUserBid(int auctionId, int userId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM AUCTION_BID_PARTICIPATION"
				+ " WHERE AUCTION_ID = ? AND USER_ID = ?";

		try (Connection conn = DBCPConn.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, auctionId);
			pstmt.setInt(2, userId);
			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}
		}
	}

			// 경매 등록 메소드
			public int insertAuction(long userNo, String productId, String title, int startPrice, int period, String info) {
	        int result = 0;
	        Connection conn = null;
	        CallableStatement cstmt = null;

	        // DB에 작성하신 프로시저: PRC_AUCTION_CREATE(유저고유키, 상품코드, 제목, 내용, 시작가, 기간)
	        String sql = "{call PRC_AUCTION_CREATE(?, ?, ?, ?, ?, ?)}";

	        try {
	            conn = DBCPConn.getConnection();
	            cstmt = conn.prepareCall(sql);

	            cstmt.setLong(1, userNo);                     // P_USER_ID
	            cstmt.setLong(2, Long.parseLong(productId));  // P_PRODUCT_ID
	            cstmt.setString(3, title);                    // P_AUCTION_TITLE
	            cstmt.setString(4, info);                     // P_CONTENT (소개글)
	            cstmt.setInt(5, startPrice);                  // P_START_PRICE
	            cstmt.setInt(6, period);                      // P_PERIOD_CODE

	            cstmt.executeUpdate();
	            result = 1; // 성공 시 1 반환

	        } catch (SQLException e) {
	            // 보증금 부족(-20004) 등의 에러가 발생하면 콘솔에 출력
	            System.err.println("경매 등록 프로시저 실행 오류: " + e.getMessage());
	            e.printStackTrace();
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            try {
	                if (cstmt != null) cstmt.close();
	                if (conn != null) conn.close();
	            } catch (Exception e2) {
	                e2.printStackTrace();
	            }
	        }
	        return result;
	    }
			
			
			// 경매 취소 메소드
			public int cancelAuction(int auctionId, int userNo, String reason) {
				
			    int result = 0;
			    
			    Connection conn = null;
			    CallableStatement cstmt = null;

			    String sql = "{call PRC_AUCTION_CANCEL(?, ?, ?)}";

			    try {
			        conn = DBCPConn.getConnection();
			        cstmt = conn.prepareCall(sql);

			        cstmt.setInt(1, auctionId);
			        cstmt.setInt(2, userNo);
			        cstmt.setString(3, reason);

			        cstmt.executeUpdate();
			        result = 1; 

			    } catch (SQLException e) {
			        System.err.println("경매 취소 프로시저 오류: " + e.getMessage());
			        e.printStackTrace();
			    } finally {
			        try {
			            if (cstmt != null) cstmt.close();
			            if (conn != null) conn.close();
			        } catch (Exception e2) {}
			    }
			    return result;
			}

			
			// 입찰 메소드
			public String insertBid(long auctionId, long userNo, int bidPrice) {
			    String result = "";
			    Connection conn = null;
			    CallableStatement cstmt = null;

			    String sql = "{call PRC_AUCTION_BID_CREATE(?, ?, ?, ?)}";

			    try {
			        conn = DBCPConn.getConnection();
			        cstmt = conn.prepareCall(sql);

			        cstmt.setLong(1, auctionId);
			        cstmt.setLong(2, userNo);
			        cstmt.setInt(3, bidPrice);

			        // 2. OUT 파라미터 등록 (Oracle의 VARCHAR2는 Types.VARCHAR 매칭)
			        cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);

			        cstmt.executeUpdate();

			        result = cstmt.getString(4);

			    } catch (Exception e) {
			        System.err.println("입찰 프로시저 실행 중 예외 발생: " + e.getMessage());
			        e.printStackTrace();
			        result = "시스템 오류가 발생했습니다.";
			    } finally {
			        try {
			            if (cstmt != null) cstmt.close();
			            if (conn != null) conn.close();
			        } catch (Exception e2) {}
			    }

			    return result;
			}


}

	
	


