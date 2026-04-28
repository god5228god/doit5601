<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 경매 현황</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
<script>
$(function() {
	
    $('#auction-status-table').on('click', '.detail-btn', function(e) {
	        e.preventDefault();
	
	        let $targetRow = $(this).closest('tr').next('.collapse');
	        
	        let $otherRows = $('#auction-status-table').find('.collapse').not($targetRow);
	
	        $otherRows.stop(true, true).hide().removeClass('show');
	
	        $targetRow.stop(true, true).slideToggle(200, function() {
	            if ($(this).is(':visible')) {
	                $(this).addClass('show');
	            } else {
	                $(this).removeClass('show');
	            }
	        });
	        
        	
        });
        

   	function updateCountdown(){
   		let now = new Date().getTime();
   		
   		$(".countdown").each(function(){
   			let endVal = $(this).data("end");
   			console.log("데이터확인:", endVal);
   			let endTime = new Date($(this).data("end")).getTime();
   			let distance = endTime - now;
   			
   			let $display = $(this).find(".time-display");
   			
   			if(distance < 0 ){
   				$display.html("<span class='text-danger fw-bold'>경매종료</span>")
   				return;
   			}	
   			
   			let days = Math.floor(distance / (1000 * 60 * 60 * 24));
            let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            let seconds = Math.floor((distance % (1000 * 60)) / 1000);
   			
            let timeStr = "";
            if(days>0){
            	timeStr += days+"일 ";
            }
            timeStr += String(hours).padStart(2,'0')+":"
            		+ String(minutes).padStart(2, '0')+":"
            		+ String(seconds).padStart(2,'0');
            	$display.text(timeStr);

   		});
   	}
   	
   	
   	setInterval(updateCountdown, 1000);
   	updateCountdown();
   	
});

$(function() {
    // 취소 버튼 클릭 시 모달의 hidden input에 auctionId 세팅
    $('.cancel-modal-btn').on('click', function() {
        const auctionId = $(this).data('id');
        $('#modalAuctionId').val(auctionId);
    });
});
</script>
<style type="text/css">
    .btn-primary{
    	background-color: #120e63 !important;
    	border-color: #120e63 !important;
    }
    .bg-primary{
    background-color: #120e63 !important;
    }
   	i.text-primary{
   		color: #120e63 !important;
   	}
    .btn-primary, .bg-primary, .btn-outline-primary:hover  {
        background-color: #120e63 !important;
        border-color: #120e63 !important;
        color: #ffffff !important;
    }
        .btn-outline-primary{
    	background-color: #fff !important;
    	border-color: #120e63 !important;
    	color: #120e63 !important;
    }

    .badge.bg-primary {
        background-color: #5172a6 !important;
    }

    .pagination .page-item.active .page-link {
        background-color: #5172a6 !important;
        border-color: #5172a6 !important;
        color: #ffffff !important;
    }

    .pagination .page-link:hover {
        color: #5172a6;
    }
    
    .page-link:focus {
        box-shadow: 0 0 0 0.25rem rgba(18, 14, 99, 0.25);
    }
    
</style>
</head>
<body class="bg-light">
 <%@ include file="/WEB-INF/views/common/header.jsp" %>

	<div class="container" style="margin-top: 50px; margin-bottom: 50px;">
		<div class="row">
			<aside class="col-md-3">
				<%@ include file="/WEB-INF/views/common/mypage_layout.jsp" %>
			</aside>
			<section class="col-md-9">
				<div class="card shadow-sm border-0 mb-4 p-4">
					<div class="card-header bg-white py-3">
						<h5 class="mb-0 fw-bold">
							<i class="bi bi-play-circle text-primary me-2"></i>내 경매 현황
						</h5>
					</div>
					<div class="card-body">
						<div class="table-responsive">
							<table class="table align-middle border-top" id="auction-status-table">
								<thead class="table-light">
									<tr class="text-center">
										<th style="width: 5%">번호</th>
										<th style="width: 45%">경매 상품 정보</th>
										<th style="width: 10%">남은 시간</th>
										<th style="width: 10%">참여 인원</th>
										<th style="width: 10%">입찰 현황</th>
										<th style="width: 10%">취소</th>
									</tr>
								</thead>
								<tbody>
									<!-- <tr>
										<td colspan="5" class="text-center">진행 중인 경매가 존재하지 않습니다.</td>
									</tr> -->
									<c:forEach var="dto" items="${list }" varStatus="status">
									<tr>
										<td class="text-center">${status.count}</td>
										<td>
											<div class="d-flex align-items-center ps-3">
												<img
											src="${pageContext.request.contextPath}/${dto.imagePath1 }"
											class="rounded shadow-sm" alt="상품" style="width: 60px; height: 60px; object-fit: cover;">
												<div class="ms-4">
													<div class="fw-bold">
														<a href="/auctions/#" class="text-decoration-none text-dark link-primary">${dto.auctionTitle }</a>
													</div>
													<div class="text-muted small">시작일: ${dto.auctionStartDate }</div>
												</div>
											</div>
										</td>
										<td class="text-center countdown" data-end="${dto.auctionEndDate }"><span class="text-danger fw-bold time-display">계산중...</span>
										</td>
										<td class="text-center"><span
											class="badge rounded-pill bg-primary px-3">${dto.bidCount } 명</span></td>
										<td class="text-center">
											<div class="small px-3">
												<button type="button" class="btn btn-sm btn-outline-dark detail-btn" data-id="${dto.auctionId }">상세</button>
												
											</div>
										</td>
									<td>
									    <button type="button" class="btn btn-sm btn-outline-dark cancel-modal-btn" 
									            data-id="${dto.auctionId}" 
									            data-bs-toggle="modal" 
									            data-bs-target="#cancelReasonModal">경매취소</button>
									</td>
									</tr>
									<tr class="collapse bg-light">
							            <td colspan="6" class="p-3 text-center">
							            	<c:forEach var="rank" items="${dto.bidRankList }" varStatus="status" end="2">
													<div class="ranking-item">
														<strong class="${rank.currentRank == 1 ? 'text-success' : 'text-muted'}">
															${rank.currentRank}순위 </strong> 
															<span class="ms-1 ${rank.currentRank == 1 ? 'text-success' : 'text-muted'}"> 
																<fmt:formatNumber value="${rank.bidPrice}" type="number" />원
															</span>
															<span>(입찰 시간: ${rank.bidTime })</span>
													</div>


												</c:forEach>
							            	
							            </td>
							        </tr>
									</c:forEach>
								
								</tbody>
							</table>
						</div>
					</div>
					<div class="d-flex justify-content-center mt-4">
							${actualCount == 0? "등록된 게시물이 없습니다.": paging }
						</div>
		
				</div>
			</section>
		</div>
	</div>
	<div class="modal fade" id="cancelReasonModal" tabindex="-1" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-centered">
	        <div class="modal-content border-0 shadow">
	            <div class="modal-header bg-dark text-white">
	                <h5 class="modal-title fw-bold">경매 취소 사유 입력</h5>
	                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
	            </div>
	            <form action="${pageContext.request.contextPath}/user/mypage/auctionCancel" method="post">
	                <input type="hidden" name="auctionId" id="modalAuctionId" value="">
	                <div class="modal-body p-4">
	                    <div class="alert alert-warning small mb-3">
	                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
	                        경매 취소 시 패널티가 부여되며, 판매자 보증금은 반환되지 않습니다.
	                    </div>
	                    <textarea name="cancelReason" class="form-control" rows="4" placeholder="취소 사유를 구체적으로 입력해주세요" required></textarea>
	                </div>
	                <div class="modal-footer bg-light">
	                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	                    <button type="submit" class="btn btn-danger px-4">최종 취소하기</button>
	                </div>
	            </form>
	        </div>
	    </div>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>