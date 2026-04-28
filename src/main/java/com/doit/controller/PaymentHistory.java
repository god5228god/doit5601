package com.doit.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.doit.dao.ProductBuyDAO;
import com.doit.dto.AuctionResultViewDTO;
import com.doit.dto.CountViewDTO;
import com.doit.dto.MoneyTransactionListDTO;
import com.doit.dto.UserInfoDTO;
import com.doit.service.PageControl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payment.history")
public class PaymentHistory extends HttpServlet{

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
		
		String pageParam = request.getParameter("page");
	    int page = 1; 
	    
	    try {
	        if (pageParam != null && !pageParam.isEmpty()) {
	        	page = Integer.parseInt(pageParam);
	        }
	    } catch (NumberFormatException e) {
	    	page = 1; // 숫자가 아니면 1페이지로 처리
	    }
		
	
		
		int viewContent = 15;
		
		ProductBuyDAO dao = new ProductBuyDAO();
		
		String part = request.getParameter("part");
		String inout = request.getParameter("inout");
		
		if(part == null)
		{
			part = "";
		}
		if(inout == null)
		{
			inout = "";
		}
		
		int viewCount = dao.moneyTransectionListCount(userId, part, inout);
		
		
		ArrayList<MoneyTransactionListDTO> list = dao.moneyTransectionList(userId,page,viewContent,part,inout);
		
		request.setAttribute("moneyList", list);
		
		PageControl pageM = new PageControl();
		
		int totalPage = pageM.totalPage(viewCount, viewContent);
		
		System.out.println(totalPage);
		
		request.setAttribute("totalPage", totalPage);
		request.setAttribute("part", part);
		request.setAttribute("inout", inout);
		request.setAttribute("page", page);
		
		request.setAttribute("userMoney", dao.moneyCheck(userId));
		
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/mypage/moneyHistory.jsp");
		dispatcher.forward(request, response);
	}
	
}

