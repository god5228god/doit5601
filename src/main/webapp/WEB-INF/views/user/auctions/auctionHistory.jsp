<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 경매 이력</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
<script>
$(function() {
    $('#auction-history-table').on('click', '.detail-btn', function(e) {
        e.preventDefault();

        let $targetRow = $(this).closest('tr').next('.collapse');
        
        let $otherRows = $('#auction-history-table').find('.collapse').not($targetRow);

        $otherRows.stop(true, true).hide().removeClass('show');

        $targetRow.stop(true, true).slideToggle(200, function() {
            if ($(this).is(':visible')) {
                $(this).addClass('show');
            } else {
                $(this).removeClass('show');
            }
        });
    });
});
</script>
<style>
#auction-history-table tr:has(+.collapse.show) td {
	border-bottom: none !important;
}

#auction-history-table .collapse.bg-light {
	background-color: #f8f9fa !important;
}

.btn-primary {
	background-color: #120e63 !important;
	border-color: #120e63 !important;
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
    <div class="card shadow-sm border-0 bg-white p-4">
        <div class="card-header bg-white py-3 border-bottom">
            <h5 class="mb-0 fw-bold">경매 종료 이력</h5>
        </div>
        <div class="card-body">
						<div class="table-responsive">
							<table class="table align-middle" id="auction-history-table">
								<thead class="table-light">
									<tr>
										<th class="text-start" style="width: 5%;">No.</th>
										<th class="text-center" style="width: 35%;">상품명</th>
										<th style="width: 15%;">최종 낙찰가</th>
										<th style="width: 15%;">종료일시</th>
										<th style="width: 10%;">결과</th>
										<th style="width: 20%;">비고</th>
									</tr>
								</thead>
								<tbody>
   									<c:forEach var="dto" items="${list }" varStatus="status">
	   									<tr>
										<td class="text-center">${status.count }</td>
										<td class="text-start"><a
											href="${pageContext.request.contextPath}/product/detail.do?id=1"
											class="fw-bold text-decoration-none text-dark ps-3 link-primary">
												${dto.auctionTitle }
												</a></td>
										<td>${dto.finalPrice }원</td>
										<td class="small text-muted">   ${dto.auctionEndDate }</td>
										<td><span
											class="badge border ${dto.transactionStatus == '거래완료' ? 'bg-success-subtle text-success border-success' :
											 dto.transactionStatus == '유찰'? 'bg-danger-subtle text-danger border-danger' : 'bg-warning-subtle text-warning border-warning' }">
												${dto.transactionStatus }
											</span></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-outline-primary detail-btn">${dto.transactionStatus == '유찰' ? '사유' : '상세'}</button>
												
												<c:if test="${dto.transcationStatus=='거래진행중' && dto.winningPaymentStatus=='Completed' && dto.shippingYn=='N'}">
													<a type="button" class="btn btn-sm btn-outline-primary" 
													href="${pageContext.request.contextPath}/user/auctions/shipping?auctionId=${dto.auctionId}">배송완료</a>
												</c:if>
										</td>
									</tr>
									<tr class="collapse bg-light">
										<td colspan="6" class="p-3">
											<div class="text-start ms-4">
											<c:choose>
												<c:when test="${dto.transactionStatus=='거래완료' }">
													<p class="mb-1 small">
														<strong>최종 거래 확정일:</strong> 2026-03-16 14:20
													</p>
													<p class="mb-0 small">
														<strong>배송 현황:</strong> 배송 완료
													</p>
												</c:when>
												<c:when test="${dto.transactionStatus== '유찰' }">
													<p class="mb-1 small">
														<strong>유찰 사유:</strong> 
														${dto.bidFailType }
														
													</p>
													<p class="mb-0 small">
														<strong>최종 처리 일시:</strong> ${dto.auctionEndDate }
													</p>
												</c:when>
												<c:otherwise>
												<p class="mb-1 small"><strong>현재 상태:</strong> 결제 대기 또는 배송 중</p>
            
												</c:otherwise>
											</c:choose>
											</div>
										</td>
									</tr>
   									</c:forEach>

								</tbody>
							</table>
								<div class="d-flex justify-content-center mt-4">
							${actualCount == 0? "등록된 게시물이 없습니다.": paging }
						</div>

						</div>
					</div>
        </div>
</section>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>