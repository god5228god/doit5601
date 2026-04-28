package com.doit.controller;

import java.io.IOException;

import com.doit.dao.AdminDAO;
import com.doit.dto.AdminDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/auth/login")
public class AdminLoginController extends HttpServlet {
	
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	
    	String id = request.getParameter("adminId");
        String pw = request.getParameter("adminPwd");

        // DAO 호출해서 인증하기
        AdminDAO dao = new AdminDAO();
        AdminDTO adminInfo = dao.getAdmin(id, pw);

        if (adminInfo != null) {
            // 세션 생성 및 정보 저장
            HttpSession session = request.getSession();
            session.setAttribute("adminInfo", adminInfo); // 세션에 DTO 통째로 넣기
            
            // 대시보드로 이동
            response.sendRedirect(request.getContextPath() + "/JY/mainDashBoard.jsp");
        } else {
            // 로그인 페이지로 리턴
        	response.sendRedirect(request.getContextPath() + "/admin/auth/login?error=1");
        }
    }
    
    // GET 요청으로 오면 로그인 페이지로 그냥 보냄
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.getRequestDispatcher("/WEB-INF/views/admin/auth/login.jsp").forward(request, response);
    }
}