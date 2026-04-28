package com.doit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.doit.dto.AuctionDTO;
import com.doit.dto.AuctionHistoryDTO;
import com.doit.dto.BidRankDTO;
import com.doit.dto.MyBidStatusDTO;
import com.doit.dto.MyPenaltyDTO;
import com.doit.dto.MyWishlistDTO;
import com.doit.dto.ProductDTO;
import com.doit.dto.UserInfoDTO;
import com.doit.util.DBCPConn;

public class MyPageDAO {

	
	// 비밀번호 확인 메소드
	public int checkPwd(String userId, String userPwd) {
		int result = 0;
		String sql ="""
				SELECT COUNT(*) AS COUNT
				FROM USER_ACCOUNT
				WHERE USER_LOGIN_ID = ? AND USER_PASSWORD = ?
				""";
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setString(1, userId);
			pstmt.setString(2, userPwd);
			
			try(ResultSet rs = pstmt.executeQuery()){
				if(rs.next()) {
					result = rs.getInt("COUNT");
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	// 회원 정보 수정 메소드
	public int modifyUserProfile(UserInfoDTO dto) {
		int result = 0;
		
		String sql="""
				UPDATE USER_PROFILE
				SET USER_EMAIL = ? , USER_PHONE = ?, USER_ZIPCODE = ?, USER_ADDRESS =?, USER_ADDRESS_DETAIL = ?
				WHERE USER_ID = ?
				""";
		try (Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)){
			
			pstmt.setString(1, dto.getUserEmail());
			pstmt.setString(2, dto.getUserPhone());
			pstmt.setString(3, dto.getUserZipcode());
			pstmt.setString(4, dto.getUserAddress());
			pstmt.setString(5, dto.getUserAddressDetail());
			pstmt.setInt(6, dto.getUserId());

			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		 
		return result;
	}
	
	// 비밀번호 수정 메소드
	public int modifyUserPwd(String userLoginId, String changePwd) {
		int result = 0;
		String sql="""
				UPDATE USER_ACCOUNT
				SET USER_PASSWORD = ?
				WHERE USER_LOGIN_ID = ?
				""";
		try (Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, changePwd);
			pstmt.setString(2, userLoginId);
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	
	// 내 등록 상품 전체 데이터 갯수
	public int productDataCount(int userId) {
		int result = 0;
		
		String sql = """
				SELECT COUNT(*) AS COUNT
				FROM PRODUCT
				WHERE USER_ID = ?
				""";
		try (Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)){
			
			pstmt.setInt(1, userId);
			try(ResultSet rs = pstmt.executeQuery()){
				if(rs.next()) {
					result = rs.getInt("COUNT");
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	
	// 내 등록 상품 게시글 리스트
	public List<ProductDTO> myProductBoard(int offset, int size, int userId, String type){
		
		List<ProductDTO> result = new ArrayList<ProductDTO>();
		
		
		String sql = """
				SELECT P.PRODUCT_ID, P.PRODUCT_RELEASE_NAME
				, P.PRODUCT_ALIAS, P.IMAGE_PATH_1, P.IS_PUBLIC, P.CREATED_AT
				, VA.AUCTION_ID, VA.IS_FINISHED
				FROM PRODUCT P LEFT OUTER JOIN VW_AUCTION_LIST VA
				ON P.PRODUCT_ID = VA.PRODUCT_ID
				WHERE P.USER_ID = ?
				
				""";
		
				if("PUBLIC".equals(type)) {
					sql+= " AND IS_PUBLIC = 1";
				}else if("PRIVATE".equals(type)) {
					sql+= " AND IS_PUBLIC = 0";
				}
				sql+=" ORDER BY PRODUCT_ID DESC OFFSET ? ROWS FETCH FIRST ? ROWS ONLY";
		
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setInt(1, userId);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, size);

			try(ResultSet rs = pstmt.executeQuery()) {
				while(rs.next()) {
					
					ProductDTO dto = new ProductDTO();
					dto.setProductId(rs.getInt("PRODUCT_ID"));
					dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
					dto.setProductAlias(rs.getString("PRODUCT_ALIAS"));
					dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
					dto.setIsPublic(rs.getInt("IS_PUBLIC"));
					dto.setCreatedAt(rs.getString("CREATED_AT"));
					dto.setAuctionId(rs.getInt("AUCTION_ID"));
					dto.setIsFinished(rs.getString("IS_FINISHED"));
					
					result.add(dto);
					
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}	
	
	// 내 경매 전체 데이터 갯수
	public int auctionDataCount(int userId) {
		int result = 0;
		
		String sql = """
				SELECT COUNT(*) AS COUNT
				FROM AUCTION_REGISTRATION AR 
				JOIN PRODUCT P ON AR.PRODUCT_ID = P.PRODUCT_ID
				WHERE USER_ID=?
				""";
		try (Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)){
			
			pstmt.setInt(1, userId);
			try(ResultSet rs = pstmt.executeQuery()){
				if(rs.next()) {
					result = rs.getInt("COUNT");
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	// 내 경매 현황 게시글 리스트
	public List<AuctionDTO> myAuctionStatusBoard(int offset, int size, int userId){
		
		List<AuctionDTO> result = new ArrayList<AuctionDTO>();
		
		
		String sql = """
				SELECT AUCTION_ID, AUCTION_TITLE
				, AUCTION_START_DATE, AUCTION_END_DATE, IMAGE_PATH_1, BID_COUNT
				FROM VW_AUCTION_LIST
				WHERE USER_ID = ? AND AUCTION_END_DATE > SYSDATE AND IS_FINISHED = '진행중'
				ORDER BY AUCTION_ID DESC OFFSET ? ROWS FETCH FIRST ? ROWS ONLY""";
		
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setInt(1, userId);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, size);


			try(ResultSet rs = pstmt.executeQuery()) {
				while(rs.next()) {
					
					AuctionDTO dto = new AuctionDTO();
					
					dto.setAuctionId(rs.getInt("AUCTION_ID"));
					dto.setAuctionTitle(rs.getString("AUCTION_TITLE"));
					dto.setAuctionStartDate(rs.getString("AUCTION_START_DATE"));
					dto.setAuctionEndDate(rs.getString("AUCTION_END_DATE"));
					dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
					dto.setBidCount(rs.getInt("BID_COUNT"));
	
					result.add(dto);
					
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}	
	
	
	// 경매 상세 - 입찰 순위 조회
	public List<BidRankDTO> myAuctionBidRank(int auctionId){
		List<BidRankDTO> result = new ArrayList<BidRankDTO>();
		
		String sql = """
				SELECT AUCTION_ID, BID_PRICE, BID_TIME, CURRENT_RANK, TOTAL_BIDDERS
				FROM VW_AUCTION_BID_RANK
				WHERE AUCTION_ID = ?
				ORDER BY CURRENT_RANK
				""";
		
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setInt(1, auctionId);
			
			try(ResultSet rs = pstmt.executeQuery()){
				while(rs.next()) {
					BidRankDTO dto = new BidRankDTO();
					dto.setAuctionId(rs.getInt("AUCTION_ID"));
					dto.setBidPrice(rs.getInt("BID_PRICE"));
					dto.setBidTime(rs.getString("BID_TIME"));
					dto.setCurrentRank(rs.getInt("CURRENT_RANK"));
					dto.setTotalBidders(rs.getInt("TOTAL_BIDDERS"));
					
					result.add(dto);
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	
	// 경매 종료 이력 리스트 
	public List<AuctionHistoryDTO> myAuctionHistoryBoard(int offset, int size, int userId){
		
		List<AuctionHistoryDTO> result = new ArrayList<AuctionHistoryDTO>();
		
		
		String sql = """
				SELECT
				    AL.AUCTION_ID,
				    AL.AUCTION_TITLE,
				    NVL(VR.WINNING_BID_PRICE, 0) AS FINAL_PRICE,
				    TO_CHAR(AL.AUCTION_END_DATE, 'YYYY-MM-DD') AS AUCTION_END_DATE, 
				    CASE
				        WHEN AL.IS_FINISHED = '경매취소' THEN '경매취소'
				        WHEN VR.BID_FAIL_YN = 'N' AND VR.PURCHASE_CONFIRM_YN = 'N' THEN '거래진행중'
				        WHEN VR.BID_FAIL_YN = 'N' AND VR.PURCHASE_CONFIRM_YN = 'Y' THEN '거래완료'
				        ELSE '유찰'
				    END AS TRANSACTION_STATUS,
				    VR.PURCHASE_CONFIRM_DATE,
				    CASE
				        WHEN VR.BID_FAIL_TYPE = 1 THEN '결제기한만료'
				        WHEN VR.BID_FAIL_TYPE = 2 THEN '낙찰포기'
				    END AS BID_FAIL_TYPE
				    , VR.WINNING_PAYMENT_STATUS, VR.SHIPPING_YN
				FROM VW_AUCTION_LIST AL
				LEFT OUTER JOIN VW_AUCTION_WINNING_RESULT VR ON AL.AUCTION_ID = VR.AUCTION_ID
				WHERE AL.USER_ID = ?
				  AND (AL.AUCTION_END_DATE < SYSDATE OR AL.IS_FINISHED = '경매취소') 
				  AND AL.IS_FINISHED != '진행중'
				ORDER BY AL.AUCTION_END_DATE DESC
				OFFSET ? ROWS FETCH FIRST ? ROWS ONLY
				""";
		
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setInt(1, userId);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, size);

			try(ResultSet rs = pstmt.executeQuery()) {
				while(rs.next()) {
					
					AuctionHistoryDTO dto = new AuctionHistoryDTO();
					
					dto.setAuctionId(rs.getInt("AUCTION_ID"));
					dto.setAuctionTitle(rs.getString("AUCTION_TITLE"));
					dto.setFinalPrice(rs.getInt("FINAL_PRICE"));
					dto.setAuctionEndDate(rs.getString("AUCTION_END_DATE"));
					dto.setTransactionStatus(rs.getString("TRANSACTION_STATUS"));
					dto.setPurchaseConfirmDate(rs.getString("PURCHASE_CONFIRM_DATE"));
					dto.setBidFailType(rs.getString("BID_FAIL_TYPE"));
					dto.setWinningPaymentStatus(rs.getString("WINNING_PAYMENT_STATUS"));
					dto.setShippingYn(rs.getString("SHIPPING_YN"));
	
					result.add(dto);
					
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}	
	
	// 입찰 현황 리스트 
	public List<MyBidStatusDTO> myBidStatusBoard(int offset, int size, int userId){
		
		List<MyBidStatusDTO> result = new ArrayList<MyBidStatusDTO>();
		
		
		String sql = """
				SELECT BID_ID, BID_PRICE, BID_RANK, BIDDER_ID, USER_ID, AUCTION_ID, CURRENT_PRICE
				, BID_TIME, AUCTION_TITLE, AUCTION_END_DATE, AUCTION_STATUS
				FROM VW_BID_LIST
				WHERE USER_ID = ? AND AUCTION_END_DATE > SYSDATE
				ORDER BY AUCTION_END_DATE DESC
				OFFSET ? ROWS FETCH FIRST ? ROWS ONLY	
				
				""";
		
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setInt(1, userId);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, size);

			try(ResultSet rs = pstmt.executeQuery()) {
				while(rs.next()) {
					
					
					MyBidStatusDTO dto = new MyBidStatusDTO();
					
					dto.setBidId(rs.getInt("BID_ID"));
					dto.setBidPrice(rs.getInt("BID_PRICE"));
					dto.setBidRank(rs.getInt("BID_RANK"));
					dto.setBidderId(rs.getInt("BIDDER_ID"));
					dto.setAuctionId(rs.getInt("AUCTION_ID"));
					dto.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
					dto.setBidTime(rs.getString("BID_TIME"));
					dto.setAuctionTitle(rs.getString("AUCTION_TITLE"));
					dto.setAuctionEndDate(rs.getString("AUCTION_END_DATE"));
					dto.setAuctionStatus(rs.getString("AUCTION_STATUS"));
	
					result.add(dto);
					
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}	
	
	// 내 입찰 전체 데이터 갯수
	public int bidDataCount(int userId) {
		int result = 0;
		
		String sql = """
				SELECT COUNT(*) AS COUNT
				FROM AUCTION_BID_PARTICIPATION
				WHERE USER_ID = ?
				""";
		try (Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql)){
			
			pstmt.setInt(1, userId);
			try(ResultSet rs = pstmt.executeQuery()){
				if(rs.next()) {
					result = rs.getInt("COUNT");
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	// 입찰 이력 리스트 
		public List<MyBidStatusDTO> myBidHistoryBoard(int offset, int size, int userId){
			
			List<MyBidStatusDTO> result = new ArrayList<MyBidStatusDTO>();
			
			
			String sql = """
					SELECT AUCTION_TITLE, BID_PRICE, BID_RANK, AUCTION_END_DATE
					FROM VW_BID_LIST
					WHERE BIDDER_ID = ? AND AUCTION_STATUS= '마감'
					ORDER BY AUCTION_END_DATE DESC
					OFFSET ? ROWS FETCH FIRST ? ROWS ONLY	
					
					""";
			
			try(Connection conn = DBCPConn.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
				
				pstmt.setInt(1, userId);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, size);

				try(ResultSet rs = pstmt.executeQuery()) {
					while(rs.next()) {
						
						
						MyBidStatusDTO dto = new MyBidStatusDTO();
						
						dto.setAuctionTitle(rs.getString("AUCTION_TITLE"));
						dto.setBidPrice(rs.getInt("BID_PRICE"));
						dto.setBidRank(rs.getInt("BID_RANK"));
						dto.setAuctionEndDate(rs.getString("AUCTION_END_DATE"));
		
						result.add(dto);
						
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			return result;
			
		}	
		
		
		// 내 관심 상품 리스트 
		public List<MyWishlistDTO> myWishlistBoard(int offset, int size, int userId){
			
			List<MyWishlistDTO> result = new ArrayList<MyWishlistDTO>();
			
			
			String sql = """
			        SELECT 
			            PW.WISHLIST_ID,
			            P.PRODUCT_ID,
			            P.PRODUCT_RELEASE_NAME,
			            P.IMAGE_PATH_1,
			            AR.AUCTION_ID,
			            NULL AS AUCTION_END_DATE,
			            CASE WHEN AR.AUCTION_ID IS NOT NULL THEN '진행중' ELSE NULL END AS IS_FINISHED
			        FROM PRODUCT_WISHLIST PW
			        JOIN PRODUCT P ON PW.PRODUCT_ID = P.PRODUCT_ID
			        LEFT OUTER JOIN (
			            SELECT AUCTION_ID, PRODUCT_ID,
			                   ROW_NUMBER() OVER(PARTITION BY PRODUCT_ID ORDER BY AUCTION_ID DESC) AS rn
			            FROM AUCTION_REGISTRATION
			        ) AR ON P.PRODUCT_ID = AR.PRODUCT_ID AND AR.rn = 1
			        WHERE PW.USER_ID = ?
			        ORDER BY WISHLIST_ID DESC
			        OFFSET ? ROWS FETCH FIRST ? ROWS ONLY
			        """;
			
			try(Connection conn = DBCPConn.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
				
				pstmt.setInt(1, userId);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, size);

				try(ResultSet rs = pstmt.executeQuery()) {
					while(rs.next()) {
						
						
						MyWishlistDTO dto = new MyWishlistDTO();
						
						dto.setWishlistId(rs.getInt("WISHLIST_ID"));
						dto.setProductId(rs.getInt("PRODUCT_ID"));
						dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
						dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
						dto.setAuctionId(rs.getInt("AUCTION_ID"));
						dto.setAuctionEndDate(rs.getString("AUCTION_END_DATE"));
						dto.setIsFinished(rs.getString("IS_FINISHED"));
		
						result.add(dto);
						
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			return result;
			
		}
	
		// 내 관심상품  전체 데이터 갯수
		public int wishlistDataCount(int userId) {
			int result = 0;
			
			String sql = """
					SELECT COUNT(*) AS COUNT
					FROM PRODUCT_WISHLIST
					WHERE USER_ID = ?
					""";
			try (Connection conn = DBCPConn.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)){
				
				pstmt.setInt(1, userId);
				try(ResultSet rs = pstmt.executeQuery()){
					if(rs.next()) {
						result = rs.getInt("COUNT");
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			return result;
		}
	
		// 내 관심 상품 삭제
		public int deleteWishlist(int wishId) {
			int result = 0;
			String sql = """
					DELETE 
					FROM PRODUCT_WISHLIST
					WHERE WISHLIST_ID = ?
					""";
			try (Connection conn = DBCPConn.getConnection();
					PreparedStatement pstmt = conn.prepareStatement(sql)){
					pstmt.setInt(1, wishId);
					result = pstmt.executeUpdate();
					
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			
			
			return result;
		}
		
		// 관심상품 등록
		public int insertWishlist(int userId, int productId) {
		    int result = 0;
		    String sql = """
		            INSERT INTO PRODUCT_WISHLIST (WISHLIST_ID, USER_ID, PRODUCT_ID)
		            VALUES (WISHLIST_SEQ.NEXTVAL, ?, ?)
		            """;
		    try (Connection conn = DBCPConn.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
		        pstmt.setInt(1, userId);
		        pstmt.setInt(2, productId);
		        result = pstmt.executeUpdate();
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return result;
		}
		
		// 이미 찜했는지 확인
		public int checkWishlist(int userId, int productId) {
		    int result = 0;
		    String sql = """
		            SELECT COUNT(*) FROM PRODUCT_WISHLIST
		            WHERE USER_ID = ? AND PRODUCT_ID = ?
		            """;
		    try (Connection conn = DBCPConn.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
		        pstmt.setInt(1, userId);
		        pstmt.setInt(2, productId);
		        try (ResultSet rs = pstmt.executeQuery()) {
		            if (rs.next()) result = rs.getInt(1);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return result;
		}
		
		
	
	
	
		// 내 패널티 리스트
		public List<MyPenaltyDTO> myPenaltyBoard(int userId){
			List<MyPenaltyDTO> result = new ArrayList<MyPenaltyDTO>();
			String sql = """
					SELECT PENALTY_ID, PENALTY_TYPE_NAME, GIVEN_SCORE, ACCUMULATED_SCORE
					, TOTAL_SCORE, HISTORY_STATUS, PENALTY_CREATED_AT
					, PENALTY_START_DATE, PENALTY_END_DATE
					, PENALTY_ASSIGN_ADMIN
					, PENALTY_CANCEL_ID, CANCEL_REASON, CANCELED_AT
					, PENALTY_CANCEL_ADMIN
					FROM VW_PENALTY_DETAIL_LIST
					WHERE USER_ID = ?
					""";
			try(Connection conn = DBCPConn.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setInt(1, userId);
				try(ResultSet rs = pstmt.executeQuery()){
					while(rs.next()) {
						MyPenaltyDTO dto = new MyPenaltyDTO();
						dto.setPenaltyId(rs.getInt(""));
					}
				}
				
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			return result;
			
		}
	
	
	
	
	
	
	
	
	
	
	
	
	
	

		// productId + userId로 찜 해제
		public void deleteWishlistByProduct(int userId, int productId) {
		    String sql = """
		            DELETE FROM PRODUCT_WISHLIST
		            WHERE USER_ID = ? AND PRODUCT_ID = ?
		            """;
		    try (Connection conn = DBCPConn.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
		        pstmt.setInt(1, userId);
		        pstmt.setInt(2, productId);
		        pstmt.executeUpdate();
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}


}