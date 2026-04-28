package com.doit.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.doit.dao.AuctionDAO;
import com.doit.dto.UserInfoDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/mypage/auction")
public class AuctionRegistController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productId = req.getParameter("productId");
        req.setAttribute("productId", productId);
        req.getRequestDispatcher("/WEB-INF/views/user/mypage/auctionRegist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user/auth/login");
            return;
        }

        long userNo = loginUser.getUserId(); 

        String productId = req.getParameter("productId");
        String title = req.getParameter("AUCTION_TITLE");
        String startPriceStr = req.getParameter("START_PRICE");
        String periodStr = req.getParameter("PERIOD_CODE");
        String info = req.getParameter("AUCTION_INFO");

        if (productId != null && !productId.isEmpty()) {
            try {
                int startPrice = Integer.parseInt(startPriceStr);
                int period = Integer.parseInt(periodStr);

                AuctionDAO dao = new AuctionDAO();
                int result = dao.insertAuction(userNo, productId, title, startPrice, period, info);

                if (result > 0) {
                    resp.sendRedirect(req.getContextPath() + "/user/product");
                } else {
                    // 실패 시 (보증금 부족 등)
                    resp.sendRedirect(req.getContextPath() + "/user/mypage/auction?productId=" + productId + "&error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/user/mypage/auction?productId=" + productId + "&error=2");
            }
        }
    }
}
