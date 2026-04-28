package com.doit.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.doit.dao.AdminPenaltyDAO;
import com.doit.dto.PenaltyHistoryDTO;

public class AdminPenaltyService
{
	//-- 속성 --//
	private AdminPenaltyDAO apDao;
	
	//-- 생성자 --//
	public AdminPenaltyService()
	{
		this.apDao = new AdminPenaltyDAO();
	}
	
	//-- 메서드 --//
	// 패널티 등록
	public int registerPenalty(PenaltyHistoryDTO phDto) throws SQLException
	{
		int result = 0;
		
		result = apDao.insertPenalty(phDto);
		
		return result;
	}
	
	// 전체 패널티 목록 조회
	public List<PenaltyHistoryDTO> getPenaltyHistoryList(int page, int sizePerPage)
	{
		List<PenaltyHistoryDTO> result = new ArrayList<>();
		
		result = apDao.selectPenaltyHistoryList(page, sizePerPage);
		
		return result;
	}
	
	// 전체 패널티 갯수 조회
	public int getPenaltyHisotyTotalCount()
	{
		int result = 0;
		
		result = apDao.selectPenaltyHistoryTotalCount();
		
		return result;
	}
	
	
	// 패널티 취소
	public int cancelPenalty(int penaltyId, int adminAccountId, String cancelReason)
	{
		int result = 0;
		
		apDao.insertPenaltyCancel(penaltyId, adminAccountId, cancelReason);
		
		return result;
	}
	

}// class AdminPenaltyService END