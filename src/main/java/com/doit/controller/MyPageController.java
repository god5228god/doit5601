package com.doit.controller;

import java.io.IOException;
import java.util.Map;

import com.doit.dao.MyPageDAO;
import com.doit.dto.UserInfoDTO;
import com.doit.service.MyPageService;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/*")
public class MyPageController extends HttpServlet{

	private static final long serialVersionUID = 1L;

	private final MyPageDAO dao = new MyPageDAO();
    private final MyPageService service = new MyPageService(dao);
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		process(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		process(request, response);
	}

	protected void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String uri = request.getRequestURI();
		String cp = request.getContextPath();
		
		HttpSession session = request.getSession();
		UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");

		
		if (user == null) { 
            response.sendRedirect(cp + "/user/auth/login");
            return;
        }
		
		int userId = user.getUserId();
		
		
		// 마이페이지 이동
		if(uri.endsWith("/user/my")) {
			
			
			int auctionCnt = dao.auctionDataCount(userId);
			int bidCnt = dao.bidDataCount(userId);
			int wishCnt = dao.wishlistDataCount(userId);
			
			request.setAttribute("auctionCnt", auctionCnt);
			request.setAttribute("bidCnt", bidCnt);
			request.setAttribute("wishCnt", wishCnt);
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/my/mypage.jsp");
			dispatcher.forward(request, response);
			
		// 내정보수정 페이지 이동
		}else if(uri.endsWith("/user/my/change-info")) {
			
			request.setAttribute("user", user);
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/my/info/changeInfo.jsp");
			dispatcher.forward(request, response);
		
			
		// 비밀번호 수정 페이지 이동
		}else if(uri.endsWith("/user/my/change-pw")) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/my/info/changePwd.jsp");
			dispatcher.forward(request, response);
			
			
		// 내정보수정 요청	
		}else if(uri.endsWith("/user/my/changeInfo-action")) {
			
						
			String userLoginId = user.getUserLoginId();
			
			String userPwd = request.getParameter("userPwd");
			String userEmail = request.getParameter("userEmail");
			String userPhone = request.getParameter("userPhone1") + request.getParameter("userPhone2") +request.getParameter("userPhone3"); 
			String userZipcode = request.getParameter("userZipcode");
			String userAddr1 = request.getParameter("userAddr1");
			String userAddr2 = request.getParameter("userAddr2");
			
			UserInfoDTO dto = new UserInfoDTO();
			dto.setUserEmail(userEmail);
			dto.setUserPhone(userPhone);
			dto.setUserZipcode(userZipcode);
			dto.setUserAddress(userAddr1);
			dto.setUserAddressDetail(userAddr2);
			dto.setUserId(userId);
			
			MyPageDAO dao = new MyPageDAO();
			MyPageService service = new MyPageService(dao);
			
			String result = service.changeInfo(userLoginId, userPwd, dto);
			if("정보 수정이 완료되었습니다.".equals(result)) {
				// 수정 성공 시 세션에 있는 기본 정보를 꺼내서 바뀐 값들만 덮어쓰기
				UserInfoDTO loginUser = (UserInfoDTO)session.getAttribute("loginUser");
				
				loginUser.setUserEmail(dto.getUserEmail());
				loginUser.setUserPhone(dto.getUserPhone());
				loginUser.setUserZipcode(dto.getUserZipcode());
				loginUser.setUserAddress(dto.getUserAddress());
				loginUser.setUserAddressDetail(dto.getUserAddressDetail());
				
				session.setAttribute("loginUser", loginUser);
			}	
			request.setAttribute("result", result);
			request.getRequestDispatcher("/WEB-INF/views/user/my/info/changeInfo.jsp").forward(request, response);
			
		
		// 비밀번호 수정 요청
		}else if(uri.endsWith("/user/my/info/change-pw-action")) {
			
	
			String userLoginId = user.getUserLoginId();
			String userPwd = request.getParameter("userPwd");
			String changePwd = request.getParameter("changePwd");
			
			MyPageDAO dao = new MyPageDAO();
			MyPageService service = new MyPageService(dao);
			String result = service.changePw(userLoginId, userPwd, changePwd);
			request.setAttribute("result", result);
			request.getRequestDispatcher("/WEB-INF/views/user/my/info/changePwd.jsp").forward(request, response);
		
		// 내 등록상품 페이지 이동
		}else if(uri.endsWith("/user/product")) {
			
			String page = request.getParameter("page");
			String type = request.getParameter("type");
			// ALL, PUBLIC, PRIVATE
			
			Map<String, Object> result = service.myProductList(page, type, userId, cp);
			
			request.setAttribute("list", result.get("list"));
			request.setAttribute("paging", result.get("paging"));
			request.setAttribute("dataCount", result.get("dataCount"));
			request.setAttribute("page", result.get("page")); 
			request.setAttribute("size", result.get("size")); 
			request.setAttribute("totalPage", result.get("totalPage")); 
			request.setAttribute("query", result.get("query")); 
			request.setAttribute("actualCount", result.get("actualCount"));
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/product/myProduct.jsp");
			dispatcher.forward(request, response);
		
		// 내 경매 현황 페이지 이동 
		}else if(uri.endsWith("/user/auctions/active")) {
			
			String page = request.getParameter("page");
			Map<String, Object> result = service.myAuctionStatus(page, userId, cp);
			
			request.setAttribute("list", result.get("list"));
			request.setAttribute("paging", result.get("paging"));
			request.setAttribute("dataCount", result.get("dataCount"));
			request.setAttribute("page", result.get("page")); 
			request.setAttribute("size", result.get("size")); 
			request.setAttribute("totalPage", result.get("totalPage")); 
			request.setAttribute("query", result.get("query")); 
			request.setAttribute("actualCount", result.get("actualCount"));
			
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/auctions/auctionStatus.jsp");
			dispatcher.forward(request, response);
			
		// 내 경매 이력 페이지 이동
		}else if(uri.endsWith("/user/auctions/closed")) {
			
			
			String page = request.getParameter("page");
			Map<String, Object> result = service.myAuctionHistory(page, userId, cp);
		
			request.setAttribute("list", result.get("list"));
			request.setAttribute("paging", result.get("paging"));
			request.setAttribute("dataCount", result.get("dataCount"));
			request.setAttribute("page", result.get("page")); 
			request.setAttribute("size", result.get("size")); 
			request.setAttribute("totalPage", result.get("totalPage")); 
			request.setAttribute("query", result.get("query")); 
			request.setAttribute("actualCount", result.get("actualCount"));
			
			
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/auctions/auctionHistory.jsp");
			dispatcher.forward(request, response);
			
		
			// 내 입찰 현황 페이지 이동
		}else if(uri.endsWith("/user/bids/active")) {
			
			String page = request.getParameter("page");
			Map<String, Object> result = service.myBidStatus(page, userId, cp);
			
			request.setAttribute("list", result.get("list"));
			request.setAttribute("paging", result.get("paging"));
			request.setAttribute("dataCount", result.get("dataCount"));
			request.setAttribute("page", result.get("page")); 
			request.setAttribute("size", result.get("size")); 
			request.setAttribute("totalPage", result.get("totalPage")); 
			request.setAttribute("query", result.get("query")); 
			request.setAttribute("actualCount", result.get("actualCount"));
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/bids/bidStatus.jsp");
			dispatcher.forward(request, response);
			
			
			// 내 입찰 이력 페이지 이동
		}else if(uri.endsWith("/user/bids/closed")) {
			
			String page = request.getParameter("page");
			Map<String, Object> result = service.myBidHistory(page, userId, cp);
			
			request.setAttribute("list", result.get("list"));
			request.setAttribute("paging", result.get("paging"));
			request.setAttribute("dataCount", result.get("dataCount"));
			request.setAttribute("page", result.get("page")); 
			request.setAttribute("size", result.get("size")); 
			request.setAttribute("totalPage", result.get("totalPage")); 
			request.setAttribute("query", result.get("query")); 
			request.setAttribute("actualCount", result.get("actualCount"));
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/bids/bidHistory.jsp");
			dispatcher.forward(request, response);
		
			// 내 패널티 내역 페이지 이동
		}else if(uri.endsWith("/user/penalty")){
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/penalties/penaltyHistory.jsp");
			dispatcher.forward(request, response);
		
			// 내 관심 상품 페이지 이동
		}else if(uri.endsWith("/user/product/wishlist")){
			
			String page = request.getParameter("page");
			
			Map<String, Object> result = service.myWishList(page, userId, cp);
			
			request.setAttribute("list", result.get("list"));
			request.setAttribute("paging", result.get("paging"));
			request.setAttribute("dataCount", result.get("dataCount"));
			request.setAttribute("page", result.get("page")); 
			request.setAttribute("size", result.get("size")); 
			request.setAttribute("totalPage", result.get("totalPage")); 
			request.setAttribute("query", result.get("query")); 
			request.setAttribute("actualCount", result.get("actualCount"));
			
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/product/wishlist.jsp");
			dispatcher.forward(request, response);
		
		}else if(uri.endsWith("/user/product/wishlist/delete")) {
			int wishId = Integer.parseInt(request.getParameter("wishId"));
			dao.deleteWishlist(wishId);
			response.sendRedirect(cp + "/user/product/wishlist");

		}else if(uri.endsWith("/user/product/wishlist/add")) {
		    int productId = Integer.parseInt(request.getParameter("productId"));

		    int already = dao.checkWishlist(userId, productId);

		    if (already > 0) {
		        dao.deleteWishlistByProduct(userId, productId);
		        response.sendRedirect(cp + "/product/detail?productId=" + productId + "&wish=cancel");
		    } else {
		        dao.insertWishlist(userId, productId);
		        response.sendRedirect(cp + "/product/detail?productId=" + productId + "&wish=ok");
		    }
		}else if(uri.endsWith("/user/auctions/shipping")) {
			
			
			
			response.sendRedirect(cp+"/user/auctions/closed");
		}
		
		
		
	}
}
