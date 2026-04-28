package com.doit.service;

import java.util.ArrayList;
import java.util.List;

import com.doit.dao.AdminProductDAO;
import com.doit.dto.ProductDTO;

public class AdminProductService
{
//-- 속성 --//
	private final AdminProductDAO apDao;
	
//-- 생성자 --//
	public AdminProductService()
	{
		this.apDao = new AdminProductDAO();
	}
	
//-- 메서드 --//
	
	// 상품 갯수 가져오기
	public int getProductCount(String productStatus)
	{
		int result = 0;
		
		result = apDao.selectProductCount(productStatus);
		
		return result;
	}// getTotalProductCount() END
	
	
	// 상품 리스트 가져오기
	public List<ProductDTO> getProductList(String productStatus, int page, int sizePerPage)
	{
		List<ProductDTO> result = new ArrayList<>();
		
		result = apDao.selectProductList(productStatus, page, sizePerPage);
		
		return result;
	}
	
	// 상품 공개 여부를 비공개로 변경
	public int changProductHide(int productId)
	{
		int result = 0;
		
		result = apDao.updateProductHide(productId);
		
		return result;
	}

}// class AdminProductService END