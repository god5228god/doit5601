package com.doit.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.doit.dao.ProductBuyDAO;
import com.doit.dto.AuctionResultViewDTO;
import com.doit.dto.CountViewDTO;
import com.doit.dto.UserInfoDTO;
import com.doit.service.PageControl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/products")
public class MySuccessfulBidController extends HttpServlet{

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		process(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		process(request, response);
	}

	protected void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String cp = request.getContextPath();
		
		HttpSession session = request.getSession();
		UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");

		
		if (user == null) { 
            response.sendRedirect(cp + "/user/auth/login");
            return;
        }
		
		int userId = user.getUserId();
		
		String typeStr = request.getParameter("type");

		
		int type = 0; 

		if (typeStr != null && !typeStr.trim().isEmpty()) {
		    try {
		    	type = Integer.parseInt(typeStr);
		    } catch (NumberFormatException e) {
		       
		    	type = 0;
		    }
		}
		
		String pageStr = request.getParameter("page");

		
		int page = 1; 

		if (pageStr != null && !pageStr.trim().isEmpty()) {
		    try {
		        page = Integer.parseInt(pageStr);
		    } catch (NumberFormatException e) {
		       
		        page = 1;
		    }
		}
		
		ProductBuyDAO dao = new ProductBuyDAO();
		
		
		CountViewDTO dto = dao.auctionResultCountAll(userId);
		
		int viewCount = 12;
		
		int selCount = dao.auctionResultCount(userId,type);
		
		ArrayList<AuctionResultViewDTO> list = dao.auctionResultList(userId,page,viewCount,type);
		
		for(AuctionResultViewDTO d : list) {
		    System.out.println("newconfirm: " + d.getConfirm());
		    System.out.println("newshipping: " + d.getShipping());
		}
		
		request.setAttribute("winnerCount", dto);
		request.setAttribute("winnerList", list);

		
		PageControl pageM = new PageControl();
		
		int totalPage = pageM.totalPage(selCount, viewCount);
		
		int blockSize = 10;
		int startPage = ((page-1)/blockSize)*blockSize + 1;
		int endPage = startPage + blockSize - 1;
		
		if(endPage > totalPage)
		{
			endPage = totalPage;
		}
		
		request.setAttribute("blockSize",blockSize);
		request.setAttribute("startPage", startPage);
		request.setAttribute("endPage", endPage);
		request.setAttribute("totalPage", totalPage);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/mypage/mySuccessBid.jsp");
		dispatcher.forward(request, response);
	}
	
}
