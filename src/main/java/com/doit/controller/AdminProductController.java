package com.doit.controller;

import java.io.IOException;
import java.util.List;

import com.doit.dto.ProductDTO;
import com.doit.service.AdminProductService;
import com.doit.util.Pagination;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/product/*")
public class AdminProductController extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		process(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		process(req, resp);
	}

//------------------------------------------------------------------------------------------------------------------------------
	
	protected void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		String methodType = request.getMethod();
		String uri = request.getRequestURI();
		String path = uri.substring(request.getContextPath().length());
		
		String viewPath = "/WEB-INF/views";

		try
		{
			//-- GET 방식 요청 처리 --//
			if (methodType.equalsIgnoreCase("GET"))
			{
				//-- 상품 --//
				// 상품 전체 조회
				if (path.equalsIgnoreCase("/admin/product/list"))
				{
					// 요청 파라미터 수신
					//-- productStatus, page
					
					// 현재 페이지
					String strPage = request.getParameter("page") == null ? "1" : request.getParameter("page");
					int page = Integer.parseInt(strPage);
					
					// 상품 공개 여부 필터값
					//-- null → 페이지 최초 진입 → 전체 리스트 출력
					String productStatus = request.getParameter("productStatus") == null ? "all" : request.getParameter("productStatus");
					//-- 전체: all
					//   공개: public
					//   비공개: privete

					
					
					// Service 객체 생성
					AdminProductService apService = new AdminProductService();
					
					// 전체 상품 갯수 가져오기
					int productTotalCount = apService.getProductCount(productStatus);
					
					// 상품 리스트 가져오기
					int sizePerPage = 10;
					List<ProductDTO> productList = apService.getProductList(productStatus, page, sizePerPage);
					
					
					// 페이지 엘리먼트 생성
					Pagination pagination = new Pagination();
					int totalPageCount = pagination.pageCount(productTotalCount, sizePerPage);
					
					// String listUrl = request.getContextPath() + "/admin/product/list?productStatus=" + productStatus;
					String listUrl =  uri + "?productStatus=" + productStatus;
					
					String pageElement = pagination.paging(page, totalPageCount, listUrl);
					
					
					// 필요한 파라미터들 바인딩
					request.setAttribute("productTotalCount", productTotalCount);
					request.setAttribute("productList", productList);
					request.setAttribute("productStatus", productStatus);
					request.setAttribute("pageElement", pageElement);
					
					
					// 포워드 할 경로 설정
					viewPath = viewPath + "/admin/productList.jsp";
				}
				
				
				// 포워드 처리
				request.getRequestDispatcher(viewPath).forward(request, response);
			}
			
			
			
			// POST 방식 요청 처리
			else if (methodType.equalsIgnoreCase("POST"))
			{
				// 상품 비공개로 전환
				if (path.equalsIgnoreCase("/admin/product/hideProduct"))
				{
					// 전달된 데이터 수신
					//-- productId, url
					String strProductId = request.getParameter("productId");
					int productId = Integer.parseInt(strProductId);
					
					String url = request.getParameter("url");
					
					
					// Service 객체 생성
					AdminProductService apService = new AdminProductService();
					
					// 로직 수행
					int result = apService.changProductHide(productId);
					
					
					// 이전 페이지(=상품 목록) 다시 이동
					response.sendRedirect(url);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}// process(...) END

}// class AdminProductController END
