package com.doit.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.doit.dto.ProductDTO;
import com.doit.dto.ProductGenreDTO;
import com.doit.dto.ProductGradeDTO;
import com.doit.dto.ProductManufacturerDTO;
import com.doit.dto.ProductSizeDTO;
import com.doit.dto.ReportDTO;
import com.doit.dto.ReportTypeDTO;
import com.doit.util.DBCPConn;

public class ProductDAO
{
	public static final int ERR_DUPLICATE_REPORT = 20020;

	// 상품 등록 - PRC_PRODUCT_CREATE 프로시저 호출
	public void insertProduct(ProductDTO dto) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;

		try
		{
			String sql = "{CALL PRC_PRODUCT_INSERT(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
			cstmt = conn.prepareCall(sql);

			cstmt.setInt(1, dto.getUserId());
			cstmt.setString(2, dto.getProductReleaseName());
			cstmt.setString(3, dto.getProductAlias());
			cstmt.setInt(4, dto.getManufacturerId());
			cstmt.setInt(5, dto.getProductGradeId());
			cstmt.setInt(6, dto.getProductGenreId());
			cstmt.setInt(7, dto.getProductSizeId());
			cstmt.setString(8, dto.getWorkName());
			cstmt.setString(9, dto.getCharacterName());
			cstmt.setString(10, dto.getPurchaseDateTime());
			cstmt.setInt(11, dto.getIsOpened());
			cstmt.setInt(12, dto.getIsPartsMissing());
			cstmt.setString(13, dto.getDescriptions());
			cstmt.setString(14, dto.getImagePath1());
			cstmt.setString(15, dto.getImagePath2());
			cstmt.setString(16, dto.getImagePath3());
			cstmt.setInt(17, dto.getIsPublic());

			cstmt.executeUpdate();
		} catch (SQLException e)
		{
			e.printStackTrace();
			throw e;
		} finally
		{
			if (cstmt != null)
				try
				{
					cstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
	}

	// 상품 수정 - PRC_PRODUCT_UPDATE 프로시저 호출
	public void updateProduct(ProductDTO dto) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;

		try
		{
			String sql = "{CALL PRC_PRODUCT_UPDATE(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
			cstmt = conn.prepareCall(sql);

			cstmt.setInt(1, dto.getProductId());
			cstmt.setInt(2, dto.getUserId());
			cstmt.setString(3, dto.getProductReleaseName());
			cstmt.setString(4, dto.getProductAlias());
			cstmt.setInt(5, dto.getManufacturerId());
			cstmt.setInt(6, dto.getProductGradeId());
			cstmt.setInt(7, dto.getProductGenreId());
			cstmt.setInt(8, dto.getProductSizeId());
			cstmt.setString(9, dto.getWorkName());
			cstmt.setString(10, dto.getCharacterName());
			cstmt.setString(11, dto.getPurchaseDateTime());
			cstmt.setInt(12, dto.getIsOpened());
			cstmt.setInt(13, dto.getIsPartsMissing());
			cstmt.setString(14, dto.getDescriptions());
			cstmt.setString(15, dto.getImagePath1());
			cstmt.setString(16, dto.getImagePath2());
			cstmt.setString(17, dto.getImagePath3());
			cstmt.setInt(18, dto.getIsPublic());

			cstmt.executeUpdate();
		} catch (SQLException e)
		{
			e.printStackTrace();
			throw e;
		} finally
		{
			if (cstmt != null)
				try
				{
					cstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
	}

	// 상품 삭제 - PRC_PRODUCT_DELETE 호출
	public void deleteProduct(int productId, int userId) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;

		try
		{
			String sql = "{CALL PRC_PRODUCT_DELETE(?, ?)}";
			cstmt = conn.prepareCall(sql);
			cstmt.setInt(1, productId);
			cstmt.setInt(2, userId);

			cstmt.executeUpdate();
		} catch (SQLException e)
		{
			e.printStackTrace();
			throw e;
		} finally
		{
			if (cstmt != null)
				try
				{
					cstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
	}

	// ─────────────────────────────────────────────────────────────
	// 공개 상품 목록 조회 - 페이징 + 키워드 + 필터(장르/등급/사이즈/제조사) + 정렬
	
	// sort
	// "newest" (기본) : PRODUCT_ID DESC
	// "grade" : PRODUCT_GRADE_ID ASC (S > A > B > C 가정, DB 순서에 맞게 조정 가능)
	// ─────────────────────────────────────────────────────────────
	public List<ProductDTO> selectProductList(int start, int end, String searchKeyword, Integer genreId,
			Integer gradeId, Integer sizeId, Integer manufacturerId, String sort) throws SQLException
	{
		List<ProductDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 동적 WHERE + ORDER BY 구성
		StringBuilder where = new StringBuilder(" WHERE IS_PUBLIC = '공개' ");
		where.append(" AND PRODUCT_RELEASE_NAME LIKE ? ");
		if (genreId != null)
			where.append(" AND PRODUCT_GENRE_ID = ? ");
		if (gradeId != null)
			where.append(" AND PRODUCT_GRADE_ID = ? ");
		if (sizeId != null)
			where.append(" AND PRODUCT_SIZE_ID = ? ");
		if (manufacturerId != null)
			where.append(" AND MANUFACTURER_ID = ? ");

		String orderBy;
		if ("grade".equals(sort))
			orderBy = " ORDER BY PRODUCT_GRADE_ID ASC, PRODUCT_ID DESC ";
		else if ("popular".equals(sort))
			orderBy = " ORDER BY PRODUCT_ID DESC "; // TODO: 찜/조회수 기준으로 교체
		else
			orderBy = " ORDER BY PRODUCT_ID DESC ";

		String sql = "SELECT * FROM ( " + "   SELECT ROWNUM rnum, p.* FROM ( "
				+ "       SELECT PRODUCT_ID, PRODUCT_RELEASE_NAME, PRODUCT_ALIAS, "
				+ "              MANUFACTURER_ID, MANUFACTURER_NAME, "
				+ "              PRODUCT_GRADE_ID, PRODUCT_GRADE_NAME, "
				+ "              PRODUCT_GENRE_ID, PRODUCT_GENRE_NAME, "
				+ "              PRODUCT_SIZE_ID, PRODUCT_SIZE_NAME, " + "              IMAGE_PATH_1, IS_PUBLIC "
				+ "       FROM VW_PRODUCT_LIST " + where.toString() + orderBy + "   ) p "
				+ ") WHERE rnum BETWEEN ? AND ?";

		try
		{
			pstmt = conn.prepareStatement(sql);
			int idx = 1;
			pstmt.setString(idx++,
					(searchKeyword == null || searchKeyword.trim().isEmpty()) ? "%" : "%" + searchKeyword.trim() + "%");
			if (genreId != null)
				pstmt.setInt(idx++, genreId);
			if (gradeId != null)
				pstmt.setInt(idx++, gradeId);
			if (sizeId != null)
				pstmt.setInt(idx++, sizeId);
			if (manufacturerId != null)
				pstmt.setInt(idx++, manufacturerId);
			pstmt.setInt(idx++, start);
			pstmt.setInt(idx++, end);

			rs = pstmt.executeQuery();

			while (rs.next())
			{
				ProductDTO dto = new ProductDTO();
				dto.setProductId(rs.getInt("PRODUCT_ID"));
				dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
				dto.setProductAlias(rs.getString("PRODUCT_ALIAS"));
				dto.setManufacturerId(rs.getInt("MANUFACTURER_ID"));
				dto.setManufacturerName(rs.getString("MANUFACTURER_NAME"));
				dto.setProductGradeId(rs.getInt("PRODUCT_GRADE_ID"));
				dto.setProductGradeName(rs.getString("PRODUCT_GRADE_NAME"));
				dto.setProductGenreId(rs.getInt("PRODUCT_GENRE_ID"));
				dto.setProductGenreName(rs.getString("PRODUCT_GENRE_NAME"));
				dto.setProductSizeId(rs.getInt("PRODUCT_SIZE_ID"));
				dto.setProductSizeName(rs.getString("PRODUCT_SIZE_NAME"));
				dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
				dto.setIsPublicName(rs.getString("IS_PUBLIC"));
				list.add(dto);
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 공개 상품 전체 건수 조회 (페이징 계산용) - 필터 포함
	public int selectProductCount(String searchKeyword, Integer genreId, Integer gradeId, Integer sizeId,
			Integer manufacturerId) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		StringBuilder where = new StringBuilder(" WHERE IS_PUBLIC = '공개' ");
		where.append(" AND PRODUCT_RELEASE_NAME LIKE ? ");
		if (genreId != null)
			where.append(" AND PRODUCT_GENRE_ID = ? ");
		if (gradeId != null)
			where.append(" AND PRODUCT_GRADE_ID = ? ");
		if (sizeId != null)
			where.append(" AND PRODUCT_SIZE_ID = ? ");
		if (manufacturerId != null)
			where.append(" AND MANUFACTURER_ID = ? ");

		String sql = "SELECT COUNT(*) FROM VW_PRODUCT_LIST" + where.toString();

		try
		{
			pstmt = conn.prepareStatement(sql);
			int idx = 1;
			pstmt.setString(idx++,
					(searchKeyword == null || searchKeyword.trim().isEmpty()) ? "%" : "%" + searchKeyword.trim() + "%");
			if (genreId != null)
				pstmt.setInt(idx++, genreId);
			if (gradeId != null)
				pstmt.setInt(idx++, gradeId);
			if (sizeId != null)
				pstmt.setInt(idx++, sizeId);
			if (manufacturerId != null)
				pstmt.setInt(idx++, manufacturerId);

			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return count;
	}

	// 내 상품 목록 조회 (마이페이지) - 페이징
	public List<ProductDTO> selectMyProductList(int userId, int start, int end) throws SQLException
	{
		List<ProductDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT * FROM (" + "    SELECT ROWNUM rnum, p.* FROM ("
				+ "        SELECT PRODUCT_ID, PRODUCT_RELEASE_NAME, PRODUCT_ALIAS,"
				+ "               MANUFACTURER_NAME, PRODUCT_GRADE_NAME, PRODUCT_GENRE_NAME,"
				+ "               IMAGE_PATH_1, IS_OPENED, IS_PUBLIC, CREATED_AT" + "        FROM VW_PRODUCT_LIST"
				+ "        WHERE USER_ID = ?" + "        ORDER BY PRODUCT_ID DESC" + "    ) p"
				+ ") WHERE rnum BETWEEN ? AND ?";

		try
		{
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);

			rs = pstmt.executeQuery();

			while (rs.next())
			{
				ProductDTO dto = new ProductDTO();
				dto.setProductId(rs.getInt("PRODUCT_ID"));
				dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
				dto.setProductAlias(rs.getString("PRODUCT_ALIAS"));
				dto.setManufacturerName(rs.getString("MANUFACTURER_NAME"));
				dto.setProductGradeName(rs.getString("PRODUCT_GRADE_NAME"));
				dto.setProductGenreName(rs.getString("PRODUCT_GENRE_NAME"));
				dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
				dto.setIsOpenedName(rs.getString("IS_OPENED"));
				dto.setIsPublicName(rs.getString("IS_PUBLIC"));
				dto.setCreatedAt(rs.getString("CREATED_AT"));
				list.add(dto);
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 내 상품 전체 건수 조회 (페이징 계산용)
	public int selectMyProductCount(int userId) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String sql = "SELECT COUNT(*) FROM VW_PRODUCT_LIST WHERE USER_ID = ?";

		try
		{
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);

			rs = pstmt.executeQuery();
			if (rs.next())
				count = rs.getInt(1);
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return count;
	}

	// 상품 상세 조회 - VW_PRODUCT_LIST 뷰 사용
	public ProductDTO selectProductDetail(int productId) throws SQLException
	{
		ProductDTO dto = null;
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT PRODUCT_ID, USER_ID, PRODUCT_RELEASE_NAME, PRODUCT_ALIAS,"
				+ "       MANUFACTURER_ID, MANUFACTURER_NAME," + "       PRODUCT_COUNTRY_ID, PRODUCT_COUNTRY_NAME,"
				+ "       PRODUCT_GRADE_ID, PRODUCT_GRADE_NAME," + "       PRODUCT_GENRE_ID, PRODUCT_GENRE_NAME,"
				+ "       PRODUCT_SIZE_ID, PRODUCT_SIZE_NAME," + "       WORK_NAME, CHARACTER_NAME, PURCHASE_DATETIME,"
				+ "       IS_OPENED, IS_PARTS_MISSING, DESCRIPTIONS,"
				+ "       IMAGE_PATH_1, IMAGE_PATH_2, IMAGE_PATH_3,"
				+ "       IMAGE_PATH_4, IMAGE_PATH_5, IMAGE_PATH_6, IMAGE_PATH_7,"
				+ "       IMAGE_PATH_8, IMAGE_PATH_9, IMAGE_PATH_10," + "       IS_PUBLIC, CREATED_AT"
				+ " FROM VW_PRODUCT_LIST" + " WHERE PRODUCT_ID = ?";

		try
		{
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, productId);
			rs = pstmt.executeQuery();

			if (rs.next())
			{
				dto = new ProductDTO();
				dto.setProductId(rs.getInt("PRODUCT_ID"));
				dto.setUserId(rs.getInt("USER_ID"));
				dto.setProductReleaseName(rs.getString("PRODUCT_RELEASE_NAME"));
				dto.setProductAlias(rs.getString("PRODUCT_ALIAS"));

				dto.setManufacturerId(rs.getInt("MANUFACTURER_ID"));
				dto.setManufacturerName(rs.getString("MANUFACTURER_NAME"));
				dto.setProductCountryId(rs.getString("PRODUCT_COUNTRY_ID"));
				dto.setProductCountryName(rs.getString("PRODUCT_COUNTRY_NAME"));

				dto.setProductGradeId(rs.getInt("PRODUCT_GRADE_ID"));
				dto.setProductGradeName(rs.getString("PRODUCT_GRADE_NAME"));
				dto.setProductGenreId(rs.getInt("PRODUCT_GENRE_ID"));
				dto.setProductGenreName(rs.getString("PRODUCT_GENRE_NAME"));
				dto.setProductSizeId(rs.getInt("PRODUCT_SIZE_ID"));
				dto.setProductSizeName(rs.getString("PRODUCT_SIZE_NAME"));

				dto.setWorkName(rs.getString("WORK_NAME"));
				dto.setCharacterName(rs.getString("CHARACTER_NAME"));
				dto.setPurchaseDateTime(rs.getString("PURCHASE_DATETIME"));

				// 뷰에서 문자열로 나옴
				dto.setIsOpenedName(rs.getString("IS_OPENED"));
				dto.setIsPartsMissingName(rs.getString("IS_PARTS_MISSING"));
				dto.setDescriptions(rs.getString("DESCRIPTIONS"));

				dto.setImagePath1(rs.getString("IMAGE_PATH_1"));
				dto.setImagePath2(rs.getString("IMAGE_PATH_2"));
				dto.setImagePath3(rs.getString("IMAGE_PATH_3"));
				dto.setImagePath4(rs.getString("IMAGE_PATH_4"));
				dto.setImagePath5(rs.getString("IMAGE_PATH_5"));
				dto.setImagePath6(rs.getString("IMAGE_PATH_6"));
				dto.setImagePath7(rs.getString("IMAGE_PATH_7"));
				dto.setImagePath8(rs.getString("IMAGE_PATH_8"));
				dto.setImagePath9(rs.getString("IMAGE_PATH_9"));
				dto.setImagePath10(rs.getString("IMAGE_PATH_10"));

				dto.setIsPublicName(rs.getString("IS_PUBLIC"));
				dto.setCreatedAt(rs.getString("CREATED_AT"));
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return dto;
	}

	// 상품 신고 등록 - PRC_REPORT_CREATE 프로시저 호출
	public void insertProductReport(ReportDTO dto) throws SQLException
	{
		Connection conn = DBCPConn.getConnection();
		CallableStatement cstmt = null;

		try
		{
			String sql = "{CALL PRC_REPORT_CREATE(?, ?, ?, ?, ?)}";
			cstmt = conn.prepareCall(sql);

			cstmt.setInt(1, dto.getUserId()); // P_USER_ID
			cstmt.setInt(2, dto.getReportTypeId()); // P_REPORT_TYPE
			cstmt.setInt(3, dto.getProductId()); // P_TARGET_ID (상품 ID)
			cstmt.setInt(4, 1); // P_TARGET_TYPE (상품 고정)
			cstmt.setString(5, dto.getReportReason()); // P_REPORT_REASON

			cstmt.executeUpdate();
		} catch (SQLException e)
		{
			e.printStackTrace();
			throw e;
		} finally
		{
			if (cstmt != null)
				try
				{
					cstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
	}

	// 제조사 목록 조회
	public List<ProductManufacturerDTO> selectManufacturerList() throws SQLException
	{
		List<ProductManufacturerDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT MANUFACTURER_ID, PRODUCT_COUNTRY_ID, MANUFACTURER_NAME"
				+ " FROM PRODUCT_MANUFACTURER ORDER BY MANUFACTURER_ID ASC";

		try
		{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				ProductManufacturerDTO dto = new ProductManufacturerDTO();
				dto.setManufacturerId(rs.getInt("MANUFACTURER_ID"));
				dto.setProductCountryId(rs.getString("PRODUCT_COUNTRY_ID"));
				dto.setManufacturerName(rs.getString("MANUFACTURER_NAME"));
				list.add(dto);
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 장르 목록 조회
	public List<ProductGenreDTO> selectGenreList() throws SQLException
	{
		List<ProductGenreDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT PRODUCT_GENRE_ID, PRODUCT_GENRE_NAME"
				+ " FROM PRODUCT_GENRE ORDER BY PRODUCT_GENRE_ID ASC";

		try
		{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				ProductGenreDTO dto = new ProductGenreDTO();
				dto.setProductGenreId(rs.getInt("PRODUCT_GENRE_ID"));
				dto.setProductGenreName(rs.getString("PRODUCT_GENRE_NAME"));
				list.add(dto);
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 등급 목록 조회
	public List<ProductGradeDTO> selectGradeList() throws SQLException
	{
		List<ProductGradeDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT PRODUCT_GRADE_ID, PRODUCT_GRADE_NAME"
				+ " FROM PRODUCT_GRADE ORDER BY PRODUCT_GRADE_ID ASC";

		try
		{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				ProductGradeDTO dto = new ProductGradeDTO();
				dto.setProductGradeId(rs.getInt("PRODUCT_GRADE_ID"));
				dto.setProductGradeName(rs.getString("PRODUCT_GRADE_NAME"));
				list.add(dto);
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 사이즈 목록 조회
	public List<ProductSizeDTO> selectSizeList() throws SQLException
	{
		List<ProductSizeDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT PRODUCT_SIZE_ID, PRODUCT_SIZE_NAME" + " FROM PRODUCT_SIZE ORDER BY PRODUCT_SIZE_ID ASC";

		try
		{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				ProductSizeDTO dto = new ProductSizeDTO();
				dto.setProductSizeId(rs.getInt("PRODUCT_SIZE_ID"));
				dto.setProductSizeName(rs.getString("PRODUCT_SIZE_NAME"));
				list.add(dto);
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return list;
	}

	// 신고 유형 목록 조회 (productReport.jsp 드롭다운용)
	public List<ReportTypeDTO> selectReportTypeList() throws SQLException
	{
		List<ReportTypeDTO> list = new ArrayList<>();
		Connection conn = DBCPConn.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT REPORT_TYPE_ID, REPORT_TYPE_NAME" + " FROM REPORT_TYPE ORDER BY REPORT_TYPE_ID ASC";

		try
		{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				ReportTypeDTO dto = new ReportTypeDTO();
				dto.setReportTypeId(rs.getInt("REPORT_TYPE_ID"));
				dto.setReportTypeName(rs.getString("REPORT_TYPE_NAME"));
				list.add(dto);
			}
		} finally
		{
			if (rs != null)
				try
				{
					rs.close();
				} catch (Exception e)
				{
				}
			if (pstmt != null)
				try
				{
					pstmt.close();
				} catch (Exception e)
				{
				}
			DBCPConn.close(conn);
		}
		return list;
	}
}
