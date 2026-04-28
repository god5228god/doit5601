package com.doit.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.doit.dto.AdminDTO;
import com.doit.dto.PenaltyHistoryDTO;
import com.doit.service.AdminPenaltyService;
import com.doit.util.Pagination;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/penalty/*")
public class AdminPenaltyController extends HttpServlet
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

//-----------------------------------------------------------------------------------------------------------------------------------

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
				//-- 패널티 처리 --//
				// 패널티 부여 페이지 이동
				if (path.equalsIgnoreCase("/admin/penalty/register"))
				{
					// 파라미터 수신
					//-- userId, url, page
					String userId = request.getParameter("userId");
					String url = request.getParameter("url");
					
					
					// (필요시 유저 정보를 가져오는 로직 삽입 가능...)

					
					// 데이터 바인딩
					request.setAttribute("userId", userId);
					request.setAttribute("url", url);
					
					
					viewPath = viewPath + "/admin/penaltyRegister.jsp";
				}
				// 패널티 이력 페이지로 이동
				else if (path.equalsIgnoreCase("/admin/penalty/history"))
				{
					// 이전 페이지(자기 자신, penaltyHistory.jsp)데이터 수신
					//-- page
					String strPage = request.getParameter("page") == null ? "1" : request.getParameter("page");
					int page = Integer.parseInt(strPage);
					
					
					// Service 객체 생성
					AdminPenaltyService apService = new AdminPenaltyService();
					
					// 전체 데이터 갯수 가져오기
					int penaltyHistoryTotalCount = apService.getPenaltyHisotyTotalCount();
					
					// 패널티 이력 리스트 가져오기
					int sizePerPage = 20;
					List<PenaltyHistoryDTO> penaltyuHistoryList = apService.getPenaltyHistoryList(page, sizePerPage);
					
					// 페이지 엘리먼트 생성
					Pagination pagination = new Pagination();
					int totalPageCount = pagination.pageCount(penaltyHistoryTotalCount, sizePerPage);
					// String listUrl = request.getContextPath() + "/admin/penalty/history";
					String listUrl = uri;
					String pageElement = pagination.paging(page, totalPageCount, listUrl);
					
					
					// request에 데이터 바인딩
					request.setAttribute("penaltyuHistoryList", penaltyuHistoryList);
					request.setAttribute("pageElement", pageElement);
					
					
					// view 페이지 경로 지정
					viewPath = viewPath + "/admin/penaltyHistory.jsp";
				}
				
				// 지정된 view 페이지로 포워딩 처리
				request.getRequestDispatcher(viewPath).forward(request, response);
			}
			
			
			//-- POST 방식 요청 처리 --//
			// 메세지 출력 및 리다이렉트 처리 페이지로 포워딩
			else if (methodType.equalsIgnoreCase("POST"))
			{
				// 작업 후 이전 페이지로 돌아가기 위한 URL 정보
				//  ㄴ 데이터 수신 후 request 에 바인딩
				String url = request.getParameter("url");
				request.setAttribute("url", url);
				
				
				
				//-- 패널티 처리 --//
				// 패널티 부여 처리
				if (path.equalsIgnoreCase("/admin/penalty/register"))
				{
					// 전달된 데이터 수신
					//-- userId, penaltyPoint, penaltyReason
					int userId = Integer.parseInt(request.getParameter("userId"));
					int penaltyScore = Integer.parseInt(request.getParameter("penaltyScore"));
					
					
					
					//------------------------------------------
					// (temp) 개발용 데이터
					//------------------------------------------
					AdminDTO tempAdminDto = new AdminDTO();
					tempAdminDto.setAdminAccountId(2);
					request.getSession().setAttribute("adminInfo", tempAdminDto);
					//------------------------------------------
					
					
					
					// 세션에서 관리자 정보 가져오기
					HttpSession session = request.getSession();
					AdminDTO adminDto = (AdminDTO)session.getAttribute("adminInfo");
					int adminAccountId = adminDto.getAdminAccountId();
					
					
					// Service 객체 생성
					AdminPenaltyService apService = new AdminPenaltyService();
					
					
					// DTO 생성
					PenaltyHistoryDTO phDto = new PenaltyHistoryDTO();
					phDto.setUserId(userId);
					phDto.setAdminAccountId(adminAccountId);
					phDto.setPenaltyScore(penaltyScore);
					// 시스템 관리자 계정을 adminAccountId = 0 이라고 가정...
					// 1: 자동 (시스템)
					// 2: 수동 (관리자)
					phDto.setPenaltyTypeId(adminAccountId == 0 ? 1 : 2);
					
					
					// 로직 수행
					int result = apService.registerPenalty(phDto);
					
					
					// 결과에 맞춰 request에 결과값 바인딩 
					if (result > 0)
					{
						request.setAttribute("message", "패널티 부여 완료");
					}
					else
					{
						request.setAttribute("message", "패널티 부여 실패!");
					}

				}
				// 패널티 취소
				else if (path.equalsIgnoreCase("/admin/penalty/cancel"))
				{
					// 이전 페이지(penaltyHistory.jsp)에서 전달된 데이터 수신
					//-- penaltyId, cancelReason
					//-- url은 상단의 POST 요청 공통 처리 단에서 이미 수신 및 바인딩 완료
					int penaltyId = Integer.parseInt(request.getParameter("penaltyId"));
					String cancelReason = request.getParameter("cancelReason");
					
					
					
					//------------------------------------------
					// (temp) 개발용 데이터
					//------------------------------------------
					AdminDTO tempAdminDto = new AdminDTO();
					tempAdminDto.setAdminAccountId(2);
					request.getSession().setAttribute("adminInfo", tempAdminDto);
					//------------------------------------------
					
					
					
					// 세션에서 관리자 정보 가져오기
					HttpSession session = request.getSession();
					AdminDTO adminDto = (AdminDTO)session.getAttribute("adminInfo");
					int adminAccountId = adminDto.getAdminAccountId();
					
					
					
					// Service 객체 생성
					AdminPenaltyService apService = new AdminPenaltyService();
					
					
					// 로직 수행
					apService.cancelPenalty(penaltyId, adminAccountId, cancelReason);
				}
				
				
				// 메세지 출력 및 리다이렉트 처리 페이지로 포워딩
				request.getRequestDispatcher("/WEB-INF/views/admin/common/message.jsp").forward(request, response);
			}
		}
		// 패널티 부여 > 프로시저 예외
		catch (SQLException e)
		{
			int errorCode = e.getErrorCode();
			
			// DB 프로시저 사용자 정의 예외 코드 처리
			if (errorCode == 20100)
			{
				request.setAttribute("message", "탈퇴한 회원에게는 패널티 부여가 불가능합니다.");
			}
			else if (errorCode == 20101)
			{
				request.setAttribute("message", "이미 영구 정지 처리된 회원에게는 추가 패널티 부여가 불가능합니다.");
			}
			
			// 메세지 출력 및 리다이렉트 처리 페이지로 포워딩
			request.getRequestDispatcher("/WEB-INF/views/admin/common/message.jsp").forward(request, response);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}// class AdminPenaltyController END