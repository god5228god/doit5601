package com.doit.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;

import com.doit.dao.AuctionDAO;
import com.doit.dto.AuctionDTO;
import com.doit.dto.UserInfoDTO;
import com.doit.util.Pagination;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/auction/*")
public class AuctionController extends HttpServlet
{
	private static final long serialVersionUID = 1L;

	private static final int PAGE_SIZE = 12; // 한 페이지당 경매 수

	private AuctionDAO auctionDAO = new AuctionDAO();
	private Pagination pagination = new Pagination();

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

	protected void process(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		String uri = req.getRequestURI();

		try
		{
			if (uri.endsWith("/auction/list"))
			{
				listAction(req, resp);
			} else if (uri.endsWith("/auction/detail"))
			{
				detailAction(req, resp);
			} else if (uri.endsWith("/auction/report"))
			{
				reportFormAction(req, resp);
			}
		} catch (SQLException e)
		{
			e.printStackTrace();
		}

	}

	// 경매 목록
	private void listAction(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException, SQLException
	{
		String keyword = req.getParameter("keyword");

		String pageStr = req.getParameter("page");
		int page = 1;

		if (pageStr != null && !pageStr.trim().isEmpty())
		{
			try
			{
				page = Integer.parseInt(pageStr);
			} catch (NumberFormatException e)
			{
				page = 1;
			}
		}
		if (page < 1)
			page = 1;
		int start = (page - 1) * PAGE_SIZE + 1;
		int end = page * PAGE_SIZE;

		int totalCount = auctionDAO.selectAuctionCount(keyword);
		int totalPage = pagination.pageCount(totalCount, PAGE_SIZE);
		List<AuctionDTO> list = auctionDAO.selectAuctionList(start, end, keyword);

		req.setAttribute("auctionList", list);
		req.setAttribute("totalCount", totalCount);
		req.setAttribute("totalPage", totalPage);
		req.setAttribute("currentPage", page);

		req.getRequestDispatcher("/WEB-INF/views/auction/auctionList.jsp").forward(req, resp);
	}

	// 경매 상세
	private void detailAction(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException, SQLException
	{
		int auctionId = Integer.parseInt(req.getParameter("auctionId"));
		AuctionDTO auction = auctionDAO.selectAuctionDetail(auctionId);

		if (auction == null)
		{
			resp.sendError(HttpServletResponse.SC_NOT_FOUND, "경매를 찾을 수 없습니다.");
			return;
		}

		Integer userId = getLoginUserId(req);

		// ── viewStatus 결정
		// ongoing_guest : 진행중 + 비로그인
		// ongoing_user : 진행중 + 로그인
		// finished_winner : 마감 + 내가 낙찰자 (낙찰 결과 조회 시 활성화)
		// finished_loser : 마감 + 입찰했지만 낙찰 못함
		// finished : 마감 + 그 외
		String viewStatus;
		if ("진행중".equals(auction.getIsFinished()))
		{
			viewStatus = (userId == null) ? "ongoing_guest" : "ongoing_user";
		} else
		{
			if (userId != null && auctionDAO.isAuctionWinner(auctionId, userId))
			{
				viewStatus = "finished_winner";
			} else if (userId != null && auctionDAO.hasUserBid(auctionId, userId))
			{
				viewStatus = "finished_loser";
			} else
			{
				viewStatus = "finished";
			}
		}

		// ── 남은 시간 계산
		// auctionEndDate 형식: "YYYY-MM-DD HH:MM" (FN_GET_AUCTION_DUE_DATE 반환값)
		long remainSeconds = 0;
		try
		{
			if (auction.getAuctionEndDate() != null && !"-".equals(auction.getAuctionEndDate()))
			{
				DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
				LocalDateTime endDt = LocalDateTime.parse(auction.getAuctionEndDate(), fmt);
				remainSeconds = ChronoUnit.SECONDS.between(LocalDateTime.now(), endDt);
				if (remainSeconds < 0)
					remainSeconds = 0;
			}
		} catch (Exception e)
		{
			remainSeconds = 0; // 파싱 실패 시 0으로
		}

		// 입찰 단위
		int bidUnit;
		int sp = auction.getStartPrice();
		if (sp < 1_000_000)
			bidUnit = 1_000;
		else if (sp < 10_000_000)
			bidUnit = 10_000;
		else
			bidUnit = 100_000;

		// ── 현재 유저의 입찰 수 (입찰 참여 제한 10개 체크용)
		int activeBidCount = 0;
		if (userId != null && "ongoing_user".equals(viewStatus))
		{
			activeBidCount = auctionDAO.selectActiveBidCount(userId);
		}

		// 경매 등록자 여부
		boolean isOwner = (userId != null && userId == auction.getUserId());
		req.setAttribute("isOwner", isOwner);
		req.setAttribute("loginUserId", userId);

		req.setAttribute("auction", auction);
		req.setAttribute("viewStatus", viewStatus);
		req.setAttribute("remainSeconds", remainSeconds);
		req.setAttribute("bidUnit", bidUnit);
		req.setAttribute("bidCount", activeBidCount); // JSP 에서 ${bidCount >= 10} 체크

		req.getRequestDispatcher("/WEB-INF/views/auction/auctionDetail.jsp").forward(req, resp);
	}

	// 경매 신고 폼
	private void reportFormAction(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException, SQLException
	{
		Integer userId = getLoginUserId(req);
		if (userId == null)
		{
			resp.sendRedirect(req.getContextPath() + "/user/auth/login");
			return;
		}

		int auctionId = Integer.parseInt(req.getParameter("auctionId"));
		AuctionDTO auction = auctionDAO.selectAuctionDetail(auctionId);

		if (auction == null)
		{
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		req.setAttribute("auction", auction);
		req.getRequestDispatcher("/WEB-INF/views/report/reportSubmit.jsp").forward(req, resp);
	}

	// 세션에서 로그인 사용자 userId 가져오기. 없으면 null.
	private Integer getLoginUserId(HttpServletRequest req)
	{
	    HttpSession session = req.getSession(false);
	    if (session == null) return null;

	    UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");
	    if (loginUser == null) return null;

	    return loginUser.getUserId();
	}

}
