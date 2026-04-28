package com.doit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.doit.dto.ProductDTO;
import com.doit.util.DBCPConn;
import com.doit.util.Pagination;

public class AdminProductDAO
{
//-- 메서드 --//
	
	// 상품 갯수 가져오기
	public int selectProductCount(String productStatus)
	{
		int result = 0;
		
		
		// 쿼리문 준비
		String sql = "SELECT COUNT(*) AS PROD_TOT_CNT FROM PRODUCT";

		// 공개 상품만 조회하려는 경우
		if (productStatus.equalsIgnoreCase("public"))
		{
			sql = sql + " WHERE IS_PUBLIC = 1";
		}
		// 비공개 상품만 조회하려는 경우
		else if (productStatus.equalsIgnoreCase("privete"))
		{
			sql = sql + " WHERE IS_PUBLIC = 0";
		}
		
		
		// DB 작업 수행
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			)
		{
			if(rs.next())
			{
				result = rs.getInt("PROD_TOT_CNT");
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException("DB 작업 오류 발생" + e.getMessage(), e);
		}
		
		
		return result;
	}// selectProductCount() END
	
	
	
	// 상품 리스트 가져오기
	public List<ProductDTO> selectProductList(String productStatus, int page, int sizePerPage)
	{
		List<ProductDTO> result = new ArrayList<>();
		
		// 현재 페이지의 데이터 시작 번호, 끝 번호 구하기
		int dataStartNum = (page - 1) * sizePerPage + 1;
		int dataEndNum = page * sizePerPage;
		
		// 쿼리문 준비
		String sql = "SELECT *"
					+ " FROM ("
					+ "		SELECT"
					+ "			ROW_NUMBER() OVER(ORDER BY VPL.PRODUCT_ID DESC) AS PRODUCT_NUM,"
					+ "			VPL.*,"
					+ "			UA.USER_LOGIN_ID"
					+ "		FROM"
					+ "			VW_PRODUCT_LIST VPL JOIN USER_ACCOUNT UA"
					+ "			ON VPL.USER_ID = UA.USER_ID";
		
		// 공개 상품만 조회하려는 경우
		if (productStatus.equalsIgnoreCase("public"))
		{
			sql = sql + " WHERE IS_PUBLIC = '공개'";
		}
		// 비공개 상품만 조회하려는 경우
		else if (productStatus.equalsIgnoreCase("privete"))
		{
			sql = sql + " WHERE IS_PUBLIC = '비공개'";
		}
		
		
		sql = sql + " )"
				  + " WHERE PRODUCT_NUM >= ?" // 시작 번호
				  + "  AND PRODUCT_NUM <= ?"; // 끝 번호

		
		// DB 작업 수행
		try(Connection conn = DBCPConn.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			)
		{
			pstmt.setInt(1, dataStartNum);
			pstmt.setInt(2, dataEndNum);
			
			try(ResultSet rs = pstmt.executeQuery();)
			{
				while(rs.next())
				{
					ProductDTO dto = new ProductDTO();
					
					dto.setProductId(rs.getInt("PRODUCT_ID"));
					dto.setUserId(rs.getInt("USER_ID"));
					dto.setManufacturerId(rs.getInt("MANUFACTURER_ID"));
					dto.setProductCountryId(rs.getString("PRODUCT_COUNTRY_ID"));
					dto.setProductGradeId(rs.getInt("PRODUCT_GRADE_ID"));
					dto.setProductGenreId(rs.getInt("PRODUCT_GENRE_ID"));
					dto.setProductSizeId(rs.getInt("PRODUCT_SIZE_ID"));
					dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
					dto.setProductAlias(rs.getString("PRODUCT_ALIAS"));
					dto.setWorkName(rs.getString("WORK_NAME"));
					dto.setCharacterName(rs.getString("CHARACTER_NAME"));
					dto.setPurchaseDateTime(rs.getString("PURCHASE_DATETIME"));
					dto.setDescriptions(rs.getString("DESCRIPTIONS"));
					dto.setCreatedAt(rs.getString("CREATED_AT"));
					dto.setManufacturerName(rs.getString("MANUFACTURER_NAME"));
					dto.setProductCountryName(rs.getString("PRODUCT_COUNTRY_NAME"));
					dto.setProductGradeName(rs.getString("PRODUCT_GRADE_NAME"));
					dto.setProductGenreName(rs.getString("PRODUCT_GENRE_NAME"));
					dto.setProductSizeName(rs.getString("PRODUCT_SIZE_NAME"));
					dto.setIsOpenedName(rs.getString("IS_OPENED"));
					dto.setIsPartsMissingName(rs.getString("IS_PARTS_MISSING"));
					dto.setIsPublicName(rs.getString("IS_PUBLIC"));
					
					// 기본 이미지
					dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
					dto.setImagePath2(rs.getString("IMAGE_PATH_2"));
					dto.setImagePath3(rs.getString("IMAGE_PATH_3"));

					// 추가 이미지
					dto.setImagePath4(rs.getString("IMAGE_PATH_4"));
					dto.setImagePath5(rs.getString("IMAGE_PATH_5"));
					dto.setImagePath6(rs.getString("IMAGE_PATH_6"));
					dto.setImagePath7(rs.getString("IMAGE_PATH_7"));
					dto.setImagePath8(rs.getString("IMAGE_PATH_8"));
					dto.setImagePath9(rs.getString("IMAGE_PATH_9"));
					dto.setImagePath10(rs.getString("IMAGE_PATH_10"));
					
					result.add(dto);
				}
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException("DB 작업 오류 발생: " + e.getMessage(), e);
		}

		return result;
	}
	
	// 상품 공개 여부를 비공개로 전환
	public int updateProductHide(int productId)
	{
		int result = 0;
		
		String sql = "UPDATE PRODUCT SET IS_PUBLIC = 0 WHERE PRODUCT_ID = ?";
		
		try (Connection conn = DBCPConn.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			)
		{
			pstmt.setInt(1, productId);
			
			result = pstmt.executeUpdate();
		}
		catch (Exception e)
		{
			throw new RuntimeException("DB 작업 오류 발생: " + e.getMessage(), e);
		}
		
		
		return result;
	}
	

}// class AdminProductDAO END