package com.doit.controller;

import java.io.IOException;

import com.doit.dao.ProductBuyDAO;
import com.doit.dto.BidActionDTO;
import com.doit.dto.MoneyChargeHistoryDTO;
import com.doit.dto.PaymentDetailDTO;
import com.doit.dto.UserInfoDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;

@WebServlet("/payment/*")
public class PaymentController extends HttpServlet
{

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		process(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		process(request, response);
	}
	
	protected void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		String uri = request.getRequestURI();
		
		if(uri.endsWith("/charge"))
		{
			charge(request, response);
		}
		
		if(uri.endsWith("/success"))
		{
			success(request, response);
		}
		
		if(uri.endsWith("/takefail"))
		{
			takefail(request, response);
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/money/moneyChargeHome.jsp");
		dispatcher.forward(request, response);
	}
	
	protected void charge(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		String cp = request.getContextPath();
		
		HttpSession session = request.getSession();
		UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");

		
		if (user == null) { 
            response.sendRedirect(cp + "/user/auth/login");
            return;
        }
		
		int userId = user.getUserId();
		
		Integer paymentType = Integer.parseInt(request.getParameter("btnradio"));
		Integer chargeMoney = Integer.parseInt(request.getParameter("chargeMoney"));
		
		ProductBuyDAO dao = new ProductBuyDAO();
		
		MoneyChargeHistoryDTO dto = new MoneyChargeHistoryDTO();
		
		dto.setUserId(userId);
		dto.setMoneyChargeMethodId(paymentType);
		dto.setChargeAmount(chargeMoney);
		
		boolean result = false;
		try
		{
			result = dao.moneyCharge(dto);
			
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
		
		int totalMoney = dao.moneyCheck(userId);
		
		request.setAttribute("chargeMoney", chargeMoney);
		request.setAttribute("totalMoney", totalMoney);
	
		if(result)
		{
			request.setAttribute("message", "충전이 완료되었습니다");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/money/charge.jsp");
			dispatcher.forward(request, response);
		}else
		{
			request.setAttribute("message", "충전이 완료되지않았습니다");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/money/charge.jsp");
			dispatcher.forward(request, response);
		}
	}
	
	protected void success(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		
		String cp = request.getContextPath();
		HttpSession session = request.getSession();
		UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");

		if (user == null) { 
            response.sendRedirect(cp + "/user/auth/login");
            return;
        }
		int userId = user.getUserId();
		
		String bidStr = request.getParameter("bid");
		String amountStr = request.getParameter("price");
		
		int bid = 1; 

		if (bidStr != null && !bidStr.trim().isEmpty()) {
		    try {
		    	bid = Integer.parseInt(request.getParameter("bid"));
		    } catch (NumberFormatException e) {
		       
		    	bid = 1;
		    }
		}
		
		int amount = 1; 

		if (amountStr != null && !amountStr.trim().isEmpty()) {
		    try {
		    	amount = Integer.parseInt(request.getParameter("price"));
		    } catch (NumberFormatException e) {
		       
		    	amount = 1;
		    }
		}
		
		ProductBuyDAO dao = new ProductBuyDAO();
		BidActionDTO dto = new BidActionDTO(userId, bid, amount);
		
		request.setAttribute("today", new java.util.Date());
		
		int result = dao.paymentBid(dto);
		System.out.println(dto.getAmount());
		System.out.println(dto.getBidResultId());
		System.out.println(dto.getUserId());
		System.out.println(result);
		
		if(result > 0)
		{
			request.setAttribute("massage", "결제가 완료되었습니다!");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/mypage/success.jsp");
			dispatcher.forward(request, response);
		}else
		{
			request.setAttribute("massage", "결제가 실패하였습니다..");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/mypage/success.jsp");
			dispatcher.forward(request, response);
		}
		
		
		
	}
	
	protected void takefail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		Integer userId = Integer.parseInt(request.getParameter("user"));
		Integer bid = Integer.parseInt(request.getParameter("bid"));
		Integer amount = Integer.parseInt(request.getParameter("price"));
		
		ProductBuyDAO dao = new ProductBuyDAO();
		
		
		
		request.setAttribute("massage", "결제가 성공하였습니다..");
		

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/mypage/takefail.jsp");
		dispatcher.forward(request, response);
		
		
		
		
	}
}
