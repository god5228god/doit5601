<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 입찰 현황</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<style>

    #bid-history-table th { font-size: 0.85rem; color: #666; font-weight: 600; background-color: #f8f9fa; }
    #bid-history-table td { font-size: 0.95rem; border-bottom: 1px solid #eee; }
    
    .history-container {
        padding: 10px 40px 20px 40px; 
        background-color: #fdfdfd;
    }
    .history-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .history-item {
        display: grid;
        grid-template-columns: 0.8fr 2fr 1.5fr 1.5fr;
        padding: 10px 0;
        border-bottom: 1px solid #f1f1f1;
        align-items: center;
        text-align: center;
    }
    .history-item:last-child { border-bottom: none; }
    

    .history-header {
        font-weight: 600;
        color: #999;
        font-size: 0.8rem;
        border-bottom: 1px solid #eee;
        padding-bottom: 5px;
    }
    .text-winning { color: #198754; font-weight: bold; }
    .text-outbid { color: #dc3545; }

    .bid-detail-row { display: none; } 
    .bid-detail-row.is-visible { display: table-row; }
    
    .btn-primary {
	background-color: #120e63 !important;
	border-color: #120e63 !important;
}
</style>

<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
<script>
$(function() {
    function updateCountdown() {
        const now = new Date().getTime();
        
        $(".countdown").each(function() {
            const endVal = $(this).data("end");
            if (!endVal) return;

            const endTime = new Date(endVal.replace(/-/g, "/")).getTime();
            const distance = endTime - now;
            
            const $display = $(this).find(".time-display");
            
            if (isNaN(endTime)) {
                $display.text("날짜 오류");
                return;
            }

            if (distance <= 0) {
                $display.html("<span class='text-muted'>경매 마감</span>");
                $(this).closest('tr').css('opacity', '0.8');
                return;
            }
            
            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
            let timeStr = "";
            if (days > 0) {
                timeStr += days + "일 ";
            }
            
            timeStr += String(hours).padStart(2, '0') + ":"
                    + String(minutes).padStart(2, '0') + ":"
                    + String(seconds).padStart(2, '0');
                    
            $display.text(timeStr);
        });
    }

    updateCountdown();
    const countdownTimer = setInterval(updateCountdown, 1000);

    $('#bid-history-table').on('click', '.detail-btn', function(e) {
        e.preventDefault();
        e.stopPropagation();

        const $btn = $(this);
        const $currentRow = $btn.closest('tr');
        const $targetRow = $currentRow.next('.bid-detail-row');
        
        $('.bid-detail-row').not($targetRow).hide();
        $('.detail-btn').not($btn).text('내역 보기');

        $targetRow.stop().fadeToggle(150);
        
        setTimeout(() => {
            const isVisible = $targetRow.is(':visible');
            $btn.text(isVisible ? '내역 닫기' : '내역 보기');
        }, 160);
    });
});
</script>
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container" style="margin-top: 50px; margin-bottom: 50px;">
    <div class="row">
        <aside class="col-md-3">
            <%@ include file="/WEB-INF/views/common/mypage_layout.jsp" %>
        </aside>
        
        <section class="col-md-9">
            <div class="card shadow-sm border-0 bg-white p-4">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center px-0">
                    <h5 class="mb-0 fw-bold">내 입찰 현황</h5>
                </div>
                
                <div class="card-body px-0">
                    <div class="table-responsive">
                        <table class="table align-middle" id="bid-history-table">
                            <thead>
                                <tr class="text-center text-nowrap">
                                    <th style="width: 8%">번호</th>
                                    <th style="width: 25%">상품명</th>
                                    <th style="width: 15%">현재가</th>
                                    <th style="width: 15%">나의 최고가</th>
                                    <th style="width: 12%">예상 순위</th>
                                    <th style="width: 15%">마감 기한</th>
                                    <th style="width: 10%">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<c:forEach var="dto" items="${list }" varStatus="status">
                            	
	                                <tr class="table-success-subtle">
	                                    <td class="text-center text-muted small">${status.count }</td>
	                                    <td>
	                                        <div class="fw-bold text-dark">${dto.auctionTitle }</div>
	                                        <div class="text-muted" style="font-size: 0.75rem;">나의 입찰 총 ${dto.bidCount }회</div>
	                                    </td>
	                                    <td class="text-center fw-bold text-danger">${dto.currentPrice }원</td>
	                                    <td class="text-center fw-bold text-dark">${dto.maxPrice }원</td>
	                                    <td class="text-center"><span class="badge ${dto.bidRank==1? 'bg-success' : dto.bidRank==2? 'bg-warning' : 'bg-danger' } ">${dto.bidRank }순위</span></td>
	                                    	<td class="text-center countdown" data-end="${dto.auctionEndDate }"><span class="text-danger fw-bold time-display">계산중...</span>
										</td>
	                                    <td class="text-center">
	                                        <button type="button" class="btn btn-sm btn-outline-primary detail-btn">내역 보기</button>
	                                    </td>
	                                </tr>
	                                <tr class="bid-detail-row">
	                                    <td colspan="7" class="p-0">
	                                        <div class="history-container">
	                                            <div class="history-list">
	                                                <div class="history-item history-header">
	                                                    <div>회차</div><div>입찰 일시</div><div>입찰 금액</div><div>상태</div>
	                                                </div>
														<c:forEach var="h" items="${dto.bidDetail}"
															varStatus="hStatus">
															<div
																class="history-item ${h.bidRank == 1 ? '' : 'text-muted'}">
																<div class="fw-bold">${dto.bidCount - hStatus.index}회차</div>
																<div class="text-muted small">${h.bidTime}</div>
																<div class="fw-bold text-dark">
																	<fmt:formatNumber value="${h.bidPrice}" type="number" />
																	원
																</div>
																<div
																	class="${h.bidRank == 1 ? 'text-winning' : 'text-outbid'}">
																	${h.bidRank == 1 ? '낙찰 유력' : '추가 입찰 필요'}</div>
															</div>
														</c:forEach>
													</div>
	                                        </div>
	                                    </td>
	                                </tr>
                            	</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    	<div class="d-flex justify-content-center mt-4">
							${actualCount == 0? "등록된 게시물이 없습니다.": paging }
						</div>
                </div>
            </div>
        </section>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
