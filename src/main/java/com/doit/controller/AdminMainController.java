package com.doit.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin")
public class AdminMainController extends HttpServlet
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

//------------------------------------------------------------------------------------------------------------------------
	
	protected void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		
		String viewPath = "/WEB-INF/views/admin/mainDashBoard";
		
		//----------
		// 개발용) 임시 경로
		viewPath = "/JY/mainDashBoard.jsp";
		//----------
		
		request.getRequestDispatcher(viewPath).forward(request, response);
		return;

		
		/*
			
			
			
			
			// 상품 상세 조회
			else if (path.equalsIgnoreCase("/admin/product/detail"))
			{
				viewPath = viewPath + "/admin/productDetail.jsp";
			}
			
			//-- 경매 --//
			// 경매 전체 조회
			else if (path.equalsIgnoreCase("/admin/show-all-auctions"))
			{
				viewPath = viewPath + "/admin/showAllAuctions.jsp";
			}
			// 경매 상세 조회
			else if (path.equalsIgnoreCase("/admin/auction/detail"))
			{
				viewPath = viewPath + "/admin/auctionDetail.jsp";
			}
						
			//-- 신고 --//
			// 전체 신고 목록
			else if (path.equalsIgnoreCase("/admin/show-all-reports"))
			{
				viewPath = viewPath + "/admin/showAllReports.jsp";
			}
			// 접수 신고건 처리
			else if (path.equalsIgnoreCase("/admin/report/process"))
			{
				viewPath = viewPath + "/admin/reportsProcess.jsp";
			}

			
			
			


			request.getRequestDispatcher(viewPath).forward(request, response);
			return;
		}
		
		*/
	}// process(...) END
	
}// class AdminController END