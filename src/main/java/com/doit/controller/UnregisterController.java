package com.doit.controller;

import java.io.IOException;

import com.doit.dao.ProductBuyDAO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/unregister/*")
public class UnregisterController extends HttpServlet{

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

		ProductBuyDAO dao = new ProductBuyDAO();
		
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/mypage/unregister.jsp");
		dispatcher.forward(request, response);
	}
}
