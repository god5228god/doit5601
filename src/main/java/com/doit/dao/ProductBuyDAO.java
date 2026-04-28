package com.doit.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.doit.dto.AuctionResultViewDTO;
import com.doit.dto.BidActionDTO;
import com.doit.dto.CountViewDTO;
import com.doit.dto.MoneyChargeHistoryDTO;
import com.doit.dto.MoneyTransactionListDTO;
import com.doit.dto.PaymentDetailDTO;
import com.doit.util.DBCPConn;

public class ProductBuyDAO
{

	// 낙찰 결제
	public int paymentBid(BidActionDTO dto)
	{
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;
		String sql = "";
		int result = 0;
		try
		{
			sql = "{CALL PRC_WINNING_PAYMENT_CREATE(?,?,?)}";

			cstmt = conn.prepareCall(sql);

			cstmt.setInt(1, dto.getUserId());
			cstmt.setInt(2, dto.getBidResultId());
			cstmt.setInt(3, dto.getAmount());

			result = cstmt.executeUpdate();

		} catch (SQLException e)
		{
			e.printStackTrace();

		} finally
		{
			try
			{
				cstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}
		return result;
	}

	// 구매 확정
	public int confirmBid(BidActionDTO dto)
	{
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;
		String sql = "";

		int result = 0;
		try
		{
			sql = "{CALL PRC_PURCHASE_CONFIRM(?,?)}";

			cstmt = conn.prepareCall(sql);

			cstmt.setInt(1, dto.getUserId());
			cstmt.setInt(2, dto.getBidResultId());

			result = cstmt.executeUpdate();
			
			System.out.println("userId: " + dto.getUserId());
	        System.out.println("bidResultId: " + dto.getBidResultId());
			
			System.out.println("result: " + result);
		} catch (Exception e)
		{
			e.printStackTrace();

		} finally
		{
			try
			{
				cstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}
		return result;
	}

	// 낙찰 결제 취소
	public void failBid(BidActionDTO dto) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;

		String sql = "{CALL BID_FAILURE_HISTORY(?,?)";
		
		try
		{
			
			sql = "{CALL BID_FAILURE_HISTORY(?,?)}";
			cstmt = conn.prepareCall(sql);
			
			cstmt.setInt(1, dto.getUserId());
			cstmt.setInt(2, dto.getBidResultId());
			
			cstmt.executeUpdate();
			
		} catch (SQLException e)
		{
			e.printStackTrace();
			throw e;
		}finally
		{
			try
			{
				cstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}
	}

	// 머니 이력
	public ArrayList<MoneyTransactionListDTO> moneyTransectionList(int userId,int page,int viewCount,String part,String inout)
	{
		ArrayList<MoneyTransactionListDTO> result = new ArrayList<>();
		
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet res = null;
		String sql = "";
		ArrayList<MoneyTransactionListDTO> list = null;

		try
		{
			list = new ArrayList<>();

			
			if(part.equals("") && inout.equals(""))
			{
				sql = """
						SELECT USER_ID, TRANSACTION_TYPE
						,CASE WHEN  TRANSACTION_TYPE = '결제' THEN 1
						WHEN  TRANSACTION_TYPE = '결제 대금' THEN 2
						WHEN  TRANSACTION_TYPE = '판매 보증금 납부' THEN 3
						WHEN  TRANSACTION_TYPE = '판매 보증금 환급' THEN 4
						WHEN  TRANSACTION_TYPE = '구매 보증금 납부' THEN 5
						WHEN  TRANSACTION_TYPE = '구매 보증금 환급' THEN 6
						WHEN  TRANSACTION_TYPE = '보증금 몰수' THEN 7
						WHEN  TRANSACTION_TYPE = '충전' THEN 8
						ELSE 0
						END AS TRANSACTIONTYPECODE
						, AMOUNT, TRANSACTION_DATE, DESCRIPTION
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN '입금'
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN '출금'
						ELSE '-'
						END AS INOUT
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN 1
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN 2
						ELSE 0
						END AS INOUTTYPE      
						,CASE WHEN  TRANSACTION_TYPE IN('구매 보증금 환급','구매 보증금 납부','결제')
						THEN '구매자'
						WHEN  TRANSACTION_TYPE IN('판매 보증금 환급','판매 보증금 납부','결제 대금')
						THEN '판매자'
						WHEN  TRANSACTION_TYPE = '충전'
						THEN DESCRIPTION
						ELSE '-'
						END AS PART
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						ORDER BY TRANSACTION_DATE DESC
						OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
						""";
			}else if(part.equals("") && inout != null)
			{
				sql = """
						SELECT USER_ID, TRANSACTION_TYPE, AMOUNT, TRANSACTION_DATE, DESCRIPTION,INOUT,PART,TRANSACTIONTYPECODE,INOUTTYPE
						FROM(
						SELECT USER_ID, TRANSACTION_TYPE
						,CASE WHEN  TRANSACTION_TYPE = '결제' THEN 1
						WHEN  TRANSACTION_TYPE = '결제 대금' THEN 2
						WHEN  TRANSACTION_TYPE = '판매 보증금 납부' THEN 3
						WHEN  TRANSACTION_TYPE = '판매 보증금 환급' THEN 4
						WHEN  TRANSACTION_TYPE = '구매 보증금 납부' THEN 5
						WHEN  TRANSACTION_TYPE = '구매 보증금 환급' THEN 6
						WHEN  TRANSACTION_TYPE = '보증금 몰수' THEN 7
						WHEN  TRANSACTION_TYPE = '충전' THEN 8
						ELSE 0
						END AS TRANSACTIONTYPECODE
						, AMOUNT, TRANSACTION_DATE, DESCRIPTION
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN '입금'
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN '출금'
						ELSE '-'
						END AS INOUT
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN 1
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN 2
						ELSE 0
						END AS INOUTTYPE      
						,CASE WHEN  TRANSACTION_TYPE IN('구매 보증금 환급','구매 보증금 납부','결제')
						THEN '구매자'
						WHEN  TRANSACTION_TYPE IN('판매 보증금 환급','판매 보증금 납부','결제 대금')
						THEN '판매자'
						WHEN  TRANSACTION_TYPE = '충전'
						THEN DESCRIPTION
						ELSE '-'
						END AS PART
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						ORDER BY TRANSACTION_DATE DESC
						OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
						)
						WHERE INOUTTYPE = ? 
						""";
			}else if(part != null && inout.equals(""))
			{
				sql = """
						SELECT USER_ID, TRANSACTION_TYPE, AMOUNT, TRANSACTION_DATE, DESCRIPTION,INOUT,PART,TRANSACTIONTYPECODE,INOUTTYPE
						FROM(
						SELECT USER_ID, TRANSACTION_TYPE
						,CASE WHEN  TRANSACTION_TYPE = '결제' THEN 1
						WHEN  TRANSACTION_TYPE = '결제 대금' THEN 2
						WHEN  TRANSACTION_TYPE = '판매 보증금 납부' THEN 3
						WHEN  TRANSACTION_TYPE = '판매 보증금 환급' THEN 4
						WHEN  TRANSACTION_TYPE = '구매 보증금 납부' THEN 5
						WHEN  TRANSACTION_TYPE = '구매 보증금 환급' THEN 6
						WHEN  TRANSACTION_TYPE = '보증금 몰수' THEN 7
						WHEN  TRANSACTION_TYPE = '충전' THEN 8
						ELSE 0
						END AS TRANSACTIONTYPECODE
						, AMOUNT, TRANSACTION_DATE, DESCRIPTION
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN '입금'
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN '출금'
						ELSE '-'
						END AS INOUT
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN 1
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN 2
						ELSE 0
						END AS INOUTTYPE      
						,CASE WHEN  TRANSACTION_TYPE IN('구매 보증금 환급','구매 보증금 납부','결제')
						THEN '구매자'
						WHEN  TRANSACTION_TYPE IN('판매 보증금 환급','판매 보증금 납부','결제 대금')
						THEN '판매자'
						WHEN  TRANSACTION_TYPE = '충전'
						THEN DESCRIPTION
						ELSE '-'
						END AS PART
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						ORDER BY TRANSACTION_DATE DESC
						OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
						)
						WHERE TRANSACTIONTYPECODE = ? 
						""";
			}else if(part != null && inout != null)
			{
				sql = """
						SELECT USER_ID, TRANSACTION_TYPE, AMOUNT, TRANSACTION_DATE, DESCRIPTION,INOUT,PART,TRANSACTIONTYPECODE,INOUTTYPE
						FROM(
						SELECT USER_ID, TRANSACTION_TYPE
						,CASE WHEN  TRANSACTION_TYPE = '결제' THEN 1
						WHEN  TRANSACTION_TYPE = '결제 대금' THEN 2
						WHEN  TRANSACTION_TYPE = '판매 보증금 납부' THEN 3
						WHEN  TRANSACTION_TYPE = '판매 보증금 환급' THEN 4
						WHEN  TRANSACTION_TYPE = '구매 보증금 납부' THEN 5
						WHEN  TRANSACTION_TYPE = '구매 보증금 환급' THEN 6
						WHEN  TRANSACTION_TYPE = '보증금 몰수' THEN 7
						WHEN  TRANSACTION_TYPE = '충전' THEN 8
						ELSE 0
						END AS TRANSACTIONTYPECODE
						, AMOUNT, TRANSACTION_DATE, DESCRIPTION
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN '입금'
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN '출금'
						ELSE '-'
						END AS INOUT
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN 1
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN 2
						ELSE 0
						END AS INOUTTYPE      
						,CASE WHEN  TRANSACTION_TYPE IN('구매 보증금 환급','구매 보증금 납부','결제')
						THEN '구매자'
						WHEN  TRANSACTION_TYPE IN('판매 보증금 환급','판매 보증금 납부','결제 대금')
						THEN '판매자'
						WHEN  TRANSACTION_TYPE = '충전'
						THEN DESCRIPTION
						ELSE '-'
						END AS PART
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						ORDER BY TRANSACTION_DATE DESC
						OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
						)
						WHERE INOUTTYPE = ? 
						AND TRANSACTIONTYPECODE = ? 
						""";
			}


			pstmt = conn.prepareStatement(sql);
			
			
			
			if(part.equals("") && inout.equals(""))
			{
				pstmt.setInt(1, userId);
				pstmt.setInt(2, (page-1)*viewCount);
				pstmt.setInt(3, viewCount);
			}else if(part.equals("") && inout != null)
			{
				pstmt.setInt(1, userId);
				pstmt.setInt(2, (page-1)*viewCount);
				pstmt.setInt(3, viewCount);
				pstmt.setString(4, inout);
			}else if(part != null && inout.equals(""))
			{
				pstmt.setInt(1, userId);
				pstmt.setInt(2, (page-1)*viewCount);
				pstmt.setInt(3, viewCount);
				pstmt.setString(4, part);
			}else if(part != null && inout != null)
			{
				pstmt.setInt(1, userId);
				pstmt.setInt(2, (page-1)*viewCount);
				pstmt.setInt(3, viewCount);
				pstmt.setString(4, inout);
				pstmt.setString(5, part);
			}
			

			res = pstmt.executeQuery();

			while (res.next())
			{
				MoneyTransactionListDTO dto = new MoneyTransactionListDTO();

				dto.setUserId(res.getInt("USER_ID"));
				dto.setTransactionType(res.getString("TRANSACTION_TYPE"));
				dto.setAmount(res.getInt("AMOUNT"));
				dto.setTransactionDate(res.getTimestamp("TRANSACTION_DATE"));
				dto.setDescription(res.getString("DESCRIPTION"));
				dto.setInout(res.getString("INOUT"));
				dto.setPart(res.getString("PART"));
				dto.setInoutType(res.getInt("INOUTTYPE"));
				dto.setTransactionTypeCode(res.getInt("TRANSACTIONTYPECODE"));
				
				System.out.println(dto.getAmount());
				System.out.println(dto.getInout());
				list.add(dto);
			}

		} catch (Exception e)
		{
			e.printStackTrace();

		} finally
		{
			try
			{
				res.close();
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}

		return list;
	}
	
	// 머니이력 개수
	public int moneyTransectionListCount(int userId,String part,String inout)
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet res = null;
		String sql = "";
		int result = 0;

		try
		{
			
			if(part == "" && inout == "")
			{
				sql = """
						SELECT COUNT(*) AS COUNT
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						""";
			}else if(part == "" && inout != "")
			{
				sql = """
						SELECT COUNT(*) AS COUNT
						FROM
						(
						SELECT USER_ID, TRANSACTION_TYPE
						,CASE WHEN  TRANSACTION_TYPE = '결제' THEN 1
						WHEN  TRANSACTION_TYPE = '결제 대금' THEN 2
						WHEN  TRANSACTION_TYPE = '판매 보증금 납부' THEN 3
						WHEN  TRANSACTION_TYPE = '판매 보증금 환급' THEN 4
						WHEN  TRANSACTION_TYPE = '구매 보증금 납부' THEN 5
						WHEN  TRANSACTION_TYPE = '구매 보증금 환급' THEN 6
						WHEN  TRANSACTION_TYPE = '보증금 몰수' THEN 7
						WHEN  TRANSACTION_TYPE = '충전' THEN 8
						ELSE 0
						END AS TRANSACTIONTYPECODE
						, AMOUNT, TRANSACTION_DATE, DESCRIPTION
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN '입금'
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN '출금'
						ELSE '-'
						END AS INOUT
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN 1
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN 2
						ELSE 0
						END AS INOUTTYPE      
						,CASE WHEN  TRANSACTION_TYPE IN('구매 보증금 환급','구매 보증금 납부','결제')
						THEN '구매자'
						WHEN  TRANSACTION_TYPE IN('판매 보증금 환급','판매 보증금 납부','결제 대금')
						THEN '판매자'
						WHEN  TRANSACTION_TYPE = '충전'
						THEN DESCRIPTION
						ELSE '-'
						END AS PART
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						)
						WHERE INOUTTYPE = ?
						""";
			}else if(part != "" && inout == "")
			{
				sql = """
						SELECT COUNT(*) AS COUNT
						FROM
						(
						SELECT USER_ID, TRANSACTION_TYPE
						,CASE WHEN  TRANSACTION_TYPE = '결제' THEN 1
						WHEN  TRANSACTION_TYPE = '결제 대금' THEN 2
						WHEN  TRANSACTION_TYPE = '판매 보증금 납부' THEN 3
						WHEN  TRANSACTION_TYPE = '판매 보증금 환급' THEN 4
						WHEN  TRANSACTION_TYPE = '구매 보증금 납부' THEN 5
						WHEN  TRANSACTION_TYPE = '구매 보증금 환급' THEN 6
						WHEN  TRANSACTION_TYPE = '보증금 몰수' THEN 7
						WHEN  TRANSACTION_TYPE = '충전' THEN 8
						ELSE 0
						END AS TRANSACTIONTYPECODE
						, AMOUNT, TRANSACTION_DATE, DESCRIPTION
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN '입금'
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN '출금'
						ELSE '-'
						END AS INOUT
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN 1
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN 2
						ELSE 0
						END AS INOUTTYPE      
						,CASE WHEN  TRANSACTION_TYPE IN('구매 보증금 환급','구매 보증금 납부','결제')
						THEN '구매자'
						WHEN  TRANSACTION_TYPE IN('판매 보증금 환급','판매 보증금 납부','결제 대금')
						THEN '판매자'
						WHEN  TRANSACTION_TYPE = '충전'
						THEN DESCRIPTION
						ELSE '-'
						END AS PART
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						)
						WHERE TRANSACTIONTYPECODE = ?
						""";
			}else if(part != "" && inout != "")
			{
				sql = """
						SELECT COUNT(*) AS COUNT
						FROM
						(
						SELECT USER_ID, TRANSACTION_TYPE
						,CASE WHEN  TRANSACTION_TYPE = '결제' THEN 1
						WHEN  TRANSACTION_TYPE = '결제 대금' THEN 2
						WHEN  TRANSACTION_TYPE = '판매 보증금 납부' THEN 3
						WHEN  TRANSACTION_TYPE = '판매 보증금 환급' THEN 4
						WHEN  TRANSACTION_TYPE = '구매 보증금 납부' THEN 5
						WHEN  TRANSACTION_TYPE = '구매 보증금 환급' THEN 6
						WHEN  TRANSACTION_TYPE = '보증금 몰수' THEN 7
						WHEN  TRANSACTION_TYPE = '충전' THEN 8
						ELSE 0
						END AS TRANSACTIONTYPECODE
						, AMOUNT, TRANSACTION_DATE, DESCRIPTION
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN '입금'
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN '출금'
						ELSE '-'
						END AS INOUT
						,CASE WHEN  TRANSACTION_TYPE IN('충전','판매 보증금 환급','구매 보증금 환급','결제 대금')
						THEN 1
						WHEN  TRANSACTION_TYPE IN('결제','판매 보증금 납부','구매 보증금 납부')
						THEN 2
						ELSE 0
						END AS INOUTTYPE      
						,CASE WHEN  TRANSACTION_TYPE IN('구매 보증금 환급','구매 보증금 납부','결제')
						THEN '구매자'
						WHEN  TRANSACTION_TYPE IN('판매 보증금 환급','판매 보증금 납부','결제 대금')
						THEN '판매자'
						WHEN  TRANSACTION_TYPE = '충전'
						THEN DESCRIPTION
						ELSE '-'
						END AS PART
						FROM VW_MONEY_HISTORY 
						WHERE USER_ID = ?
						)
						WHERE INOUTTYPE = ? 
						AND TRANSACTIONTYPECODE = ? 
						""";
			}
			


			pstmt = conn.prepareStatement(sql);
			
			
			if(part.equals("") && inout.equals(""))
			{
				pstmt.setInt(1, userId);
			}else if(part.equals("") && inout != null)
			{
				pstmt.setInt(1, userId);
				pstmt.setString(2, inout);
			}else if(part != null && inout.equals(""))
			{
				pstmt.setInt(1, userId);
				pstmt.setString(2, part);
			}else if(part != null && inout != null)
			{
				pstmt.setInt(1, userId);
				pstmt.setString(2, inout);
				pstmt.setString(3, part);
			}
		

			res = pstmt.executeQuery();

			while (res.next())
			{
				result = res.getInt("COUNT");
			}

		} catch (Exception e)
		{
			e.printStackTrace();

		} finally
		{
			try
			{
				res.close();
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}

		return result;
	}

	// 머니 충전
	public boolean moneyCharge(MoneyChargeHistoryDTO dto) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		String sql = "";
		boolean result = false;
		try
		{
			sql = "INSERT INTO MONEY_CHARGE_HISTORY(MONEY_CHARGE_ID,USER_ID,MONEY_CHARGE_METHOD_ID,CHARGE_AMOUNT)"
					+ " VALUES(MONEY_CHARGE_SEQ.NEXTVAL,?,?,?)";

			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, dto.getUserId());
			pstmt.setInt(2, dto.getMoneyChargeMethodId());
			pstmt.setInt(3, dto.getChargeAmount());

			int resultInt = pstmt.executeUpdate();
			
			if(resultInt > 0)
			{
				result = true;
			}

		} catch (SQLException e)
		{
			e.printStackTrace();
			throw e;
		} finally
		{
			try
			{
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}
		
		return result;
	}

	// 낙찰 조회
	public ArrayList<AuctionResultViewDTO> auctionResultList(int userId,int page,int viewCount,int type)
	{
		ArrayList<AuctionResultViewDTO> result = new ArrayList<>();
		
		Connection conn = DBCPConn.getConnection();
		
		if (conn != null) {
            System.out.println("데이터베이스 연결 성공!");
        }else
        {
        	System.out.println("실패!");
        }
		PreparedStatement pstmt = null;
		ResultSet res = null;
		String sql = "";
		ArrayList<AuctionResultViewDTO> list = null;
		try
		{
			list = new ArrayList<AuctionResultViewDTO>();

			sql =   """
					SELECT 경매번호,경매제목,낙찰자번호,낙찰자ID,낙찰금액,낙찰일시,낙찰결과번호
					,C.PRODUCT_ID AS 제품ID,C.IMAGE_PATH_1 AS 이미지,START_PRICE AS 시작가,B.CREATED_AT AS 경매생성일
					,AUCTION_PERIOD_ID AS 경매기간,WINNING_BID_ID AS 낙찰자입찰번호,WINNING_BID_TIME AS 낙찰시간,AUCTION_FINAL_PRICE AS 결제낙찰금액
					,AUCTION_STATUS AS 경매상태, WINNING_STATUS AS 낙찰상태, WINNING_PAYMENT_STATUS AS 낙찰자결제상태, WINNING_PAYMENT_MONEY_ID AS 머니ID
					,WINNING_PAYMENT_DATE AS 결제일자, BID_FAIL_YN AS 실패여부, BID_FAIL_TYPE AS 실패타입, SHIPPING_YN AS 배송여부, SHIPPING_DATE AS 배송일자
					,PURCHASE_CONFIRM_YN AS 구매확정여부, PURCHASE_CONFIRM_DATE AS 구매확정일자
					FROM VW_UNPAID_WINNING_TARGET_1 A
					LEFT JOIN VW_AUCTION_WINNING_RESULT B
					ON B.AUCTION_ID = A.경매번호
                    JOIN PRODUCT C
                    ON B.PRODUCT_ID = C.PRODUCT_ID
					WHERE A.낙찰자번호 = ?
					
					""";
			if(type == 1)
			{
				sql += " AND BID_FAIL_YN = 'Y'";
			}else if(type == 2)
			{
				sql += " AND WINNING_PAYMENT_STATUS = 'Pending' AND BID_FAIL_YN = 'N'";
			}else if(type == 3)
			{
				sql += " AND WINNING_PAYMENT_STATUS = 'Completed' AND BID_FAIL_YN = 'N' AND SHIPPING_YN = 'N'";
			}else if(type == 4)
			{
				sql += " AND SHIPPING_YN = 'Y' AND PURCHASE_CONFIRM_YN = 'N'";
			}else if(type == 5)
			{
				sql += " AND PURCHASE_CONFIRM_YN = 'Y'";
			}
			
			sql += " ORDER BY 낙찰일시"
				+  " OFFSET ? ROWS FETCH FIRST ? ROWS ONLY";

			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, userId);
			pstmt.setInt(2, (page-1)*viewCount);
			pstmt.setInt(3, viewCount);

			res = pstmt.executeQuery();

			while (res.next())
			{
				AuctionResultViewDTO dto = new AuctionResultViewDTO();

				dto.setImg(res.getString("이미지"));
				dto.setAuctionId(res.getInt("경매번호"));
				dto.setWinnerUserId(res.getInt("낙찰자번호"));
				dto.setWinnerAmount(res.getInt("낙찰금액"));
				dto.setProductId(res.getInt("제품ID"));
				dto.setStartPrice(res.getInt("시작가"));
				dto.setAuctionUseDate(res.getInt("경매기간"));
				dto.setWinnerBidId(res.getInt("낙찰결과번호"));
				dto.setFinalPrice(res.getInt("결제낙찰금액"));
				dto.setWinnerId(res.getInt("낙찰자입찰번호"));
				dto.setPaymentId(res.getInt("머니ID"));
				dto.setFailType(res.getInt("실패타입"));
				dto.setWinner(res.getString("낙찰자ID"));
				dto.setAuctionTitle(res.getString("경매제목"));
				dto.setWinnerDate(res.getString("낙찰일시"));
				dto.setAuctionStartDate(res.getString("경매생성일"));
				dto.setWinnerBidDate(res.getString("낙찰시간"));
				dto.setAuctionStat(res.getString("경매상태"));
				dto.setWinnerStat(res.getString("낙찰상태"));
				dto.setPaymentStat(res.getString("낙찰자결제상태"));
				dto.setPaymentDate(res.getString("결제일자"));
				dto.setFail(res.getString("실패여부"));
				dto.setShipping(res.getString("배송여부"));
				dto.setShippingDate(res.getString("배송일자"));
				dto.setConfirm(res.getString("구매확정여부"));
				dto.setConfirmDate(res.getString("구매확정일자"));
				
				System.out.println(dto.getConfirm());
				System.out.println(dto.getAuctionId());
				System.out.println(dto.getConfirm());
				System.out.println(dto.getConfirm());
				list.add(dto);
			}

		} catch (Exception e)
		{
			e.printStackTrace();
		} finally
		{
			try
			{
				res.close();
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}
		return list;

	}

	
	// 낙찰타입별 개수 조회
	public CountViewDTO auctionResultCountAll(int userId)
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet res = null;
		String sql = "";
		
		CountViewDTO dto = new CountViewDTO();
		
		try
		{
			sql =   """
					SELECT COUNT(*) AS TOTAL
					,COUNT(CASE WHEN BID_FAIL_YN = 'Y' THEN 1 END) AS FAIL
					,COUNT(CASE WHEN WINNING_PAYMENT_STATUS = 'Pending' AND BID_FAIL_YN = 'N' THEN 1 END) AS UNPAYMENT
					,COUNT(CASE WHEN WINNING_PAYMENT_STATUS = 'Completed' AND BID_FAIL_YN = 'N' AND SHIPPING_YN = 'N' THEN 1 END) AS UNSHIPPING
					,COUNT(CASE WHEN SHIPPING_YN = 'Y' AND PURCHASE_CONFIRM_YN = 'N' THEN 1 END) AS SHIPPING
					,COUNT(CASE WHEN PURCHASE_CONFIRM_YN = 'Y' THEN 1 END) AS CONFIRM
					FROM VW_UNPAID_WINNING_TARGET_1 A
					LEFT JOIN VW_AUCTION_WINNING_RESULT B
					ON B.AUCTION_ID = A.경매번호
					WHERE A.낙찰자번호 = ?
					""";                                                 
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, userId);
			
			res = pstmt.executeQuery();
			
			while(res.next())
			{
				dto.setTotal(res.getInt("TOTAL"));
				dto.setFail(res.getInt("FAIL"));
				dto.setUnpayment(res.getInt("UNPAYMENT"));
				dto.setUnshipping(res.getInt("UNSHIPPING"));
				dto.setShipping(res.getInt("SHIPPING"));
				dto.setConfirm(res.getInt("CONFIRM"));
				
				System.out.println(dto.getTotal());
			}
					
		} catch (Exception e)
		{
			e.printStackTrace();
		}finally {
			try
			{
				res.close();
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}
		
		return dto;
	}
	
	// 타입별 카운트 조회(view용)
	public int auctionResultCount(int userId,int type)
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet res = null;
		String sql = "";
		
		int result = 0;
		
		try
		{
			sql =   """
					SELECT COUNT(*) AS TOTAL
					FROM VW_UNPAID_WINNING_TARGET_1 A
					LEFT JOIN VW_AUCTION_WINNING_RESULT B
					ON B.AUCTION_ID = A.경매번호
					WHERE A.낙찰자번호 = ?
					""";                                                 
			if(type == 1)
			{
				sql += " AND BID_FAIL_YN = 'Y'";
			}else if(type == 2)
			{
				sql += " AND WINNING_PAYMENT_STATUS = 'Pending' AND BID_FAIL_YN = 'N'";
			}else if(type == 3)
			{
				sql += " AND WINNING_PAYMENT_STATUS = 'Completed' AND BID_FAIL_YN = 'N' AND SHIPPING_YN = 'N'";
			}else if(type == 4)
			{
				sql += " AND SHIPPING_YN = 'Y' AND PURCHASE_CONFIRM_YN = 'N'";
			}else if(type == 5)
			{
				sql += " AND PURCHASE_CONFIRM_YN = 'Y'";
			}
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, userId);
			
			res = pstmt.executeQuery();
			
			while(res.next())
			{
				result = res.getInt("TOTAL");
			}
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}finally {
			try
			{
				res.close();
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}
		
		return result;
	}
	
	
	// 회원 머니 확인
	public int moneyCheck(int userId)
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet res = null;
		String sql = "";
		int result = 0;

		try
		{
			sql = "SELECT FN_GET_USER_MONEY_BALANCE(?) AS RESULT FROM DUAL";

			pstmt = conn.prepareCall(sql);

			pstmt.setInt(1, userId);

			res = pstmt.executeQuery();

			while (res.next())
			{
				result = res.getInt("RESULT");
			}


		} catch (Exception e)
		{
			e.printStackTrace();
		} finally
		{
			try
			{
				res.close();
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}

		return result;
	}

	// 결제 품목에대한 정보
	public PaymentDetailDTO takeItem(int resultId)
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet res = null;
		String sql = "";
		PaymentDetailDTO dto = new PaymentDetailDTO();
		try
		{
			sql = """
					SELECT M.BID_RESULT_ID,A.USER_ID, A.AUCTION_ID, AUCTION_TITLE,START_PRICE,BID_CURRENT_PRICE,BID_MAX_PRICE,AUCTION_START_DATE,AUCTION_END_DATE,IS_FINISHED,PRODUCT_ID
					,PRODUCT_ALIAS,MANUFACTURER_NAME,PRODUCT_GRADE_NAME,IMAGE_PATH_1,USER_NAME,USER_EMAIL,USER_PHONE,USER_ZIPCODE,USER_ADDRESS,USER_ADDRESS_DETAIL
					FROM  AUCTION_WINNING_RESULT M
					LEFT JOIN AUCTION_BID_PARTICIPATION Q
					ON M.BID_ID = Q.BID_ID
					LEFT JOIN VW_AUCTION_LIST A 
					ON Q.AUCTION_ID = A.AUCTION_ID
					LEFT JOIN USER_PROFILE B
					ON A.USER_ID = B.USER_ID
					WHERE BID_RESULT_ID = ?
					""";

			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, resultId);

			res = pstmt.executeQuery();

			while (res.next())
			{
				dto.setAddress(res.getString("USER_ADDRESS"));
				dto.setAddressDetail(res.getString("USER_ADDRESS_DETAIL"));
				dto.setAuctionEndDate(res.getString("AUCTION_END_DATE"));
				dto.setAuctionId(res.getInt("AUCTION_ID"));
				dto.setAuctionStartDate(res.getString("AUCTION_START_DATE"));
				dto.setAuctionTitle(res.getString("AUCTION_TITLE"));
				dto.setBidResult(res.getInt("BID_RESULT_ID"));
				dto.setCurrentPrice(res.getInt("BID_CURRENT_PRICE"));
				dto.setEmail(res.getString("USER_EMAIL"));
				dto.setGradeName(res.getString("PRODUCT_GRADE_NAME"));
				dto.setImg(res.getString("IMAGE_PATH_1"));
				dto.setIsFinish(res.getString("IS_FINISHED"));
				dto.setManudacturerName(res.getString("MANUFACTURER_NAME"));
				dto.setMaxPrice(res.getInt("BID_MAX_PRICE"));
				dto.setProducAlias(res.getString("PRODUCT_ALIAS"));
				dto.setProducId(res.getInt("PRODUCT_ID"));
				dto.setStartPrice(res.getInt("START_PRICE"));
				dto.setUserId(res.getInt("USER_ID"));
				dto.setUserName(res.getString("USER_NAME"));
				dto.setZipcode(res.getInt("USER_ZIPCODE"));
				dto.setPhone(res.getString("USER_PHONE"));
				
				System.out.println(dto.getAddress());
			}
		} catch (Exception e)
		{
			e.printStackTrace();
		} finally
		{
			try
			{
				res.close();
				pstmt.close();
				DBCPConn.close(conn);
			} catch (Exception e)
			{
				e.printStackTrace();
				System.out.println(e);
			}
		}

		return dto;
	}

}
