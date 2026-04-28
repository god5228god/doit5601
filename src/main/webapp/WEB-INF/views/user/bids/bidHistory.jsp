<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 입찰 이력</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>

<script>
$(function() {
    // 입찰 이력 테이블 내의 버튼만 타겟팅 (사이드바 간섭 방지)
    $('#bid-history-table').on('click', '.detail-btn', function(e) {
        e.preventDefault();

        // 1. 내가 제어할 타겟 (내 조상의 형제인 .collapse 행)
        const $targetRow = $(this).closest('tr').next('.collapse');
        
        // 2. 이 테이블 안에서 이미 열려있는 다른 상세 행들 찾기
        const $otherRows = $('#bid-history-table').find('.collapse').not($targetRow);

        // 3. 다른 상세 행은 즉시 닫기 (빠릿빠릿한 느낌)
        $otherRows.stop(true, true).hide().removeClass('show');

        // 4. 내 타겟 행 토글
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
/* 상세 페이지 링크 스타일 */
.product-link {
	color: #212529;
	transition: color 0.2s;
}

.product-link:hover {
	color: #0d6efd !important;
}

/* 아코디언 행 배경색 및 간격 */
#bid-history-table .collapse.bg-light {
	background-color: #f8f9fa !important;
}

#bid-history-table tr.collapse td {
	border-top: none;
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
                    <div class="card-header bg-white py-3 border-bottom text-dark">
                        <h5 class="mb-0 fw-bold">내 입찰 이력</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-middle text-center" id="bid-history-table">
                                <thead class="table-light">
                                    <tr>
                                   		<th>번호</th>
                                        <th class="text-start">종료 상품명</th>
                                        <th>나의 최종 입찰가</th>
                                        <th>내 입찰 횟수</th>
                                        <th>최종 결과</th>
                                        <th>비고</th>
                                    </tr>
                                </thead>
                                <tbody>
                               		<!-- 게시글이 없을 때  -->
                               		<!-- <tr>
                               			<td class="text-center" colspan="6">
                               				입찰 내역이 존재하지 않습니다.
                               			</td>
                               		</tr> -->
                               		<!-- 게시글이 있을 때  -->
                               		<c:forEach var="dto" items="${list }" varStatus="status">
                                	<tr>
                                    	<td class="text-center">${status.count }</td>
                                        <td class="text-start">
                                            <a href="${pageContext.request.contextPath}/product/detail.do?id=102" class="fw-bold text-decoration-none product-link">
                                                ${dto.auctionTitle }
                                            </a>
                                        </td>
                                        <td>${dto.maxPrice }원</td>
                                        <td>${dto.bidCount }회 </td>
                                        
                                        <td><span class="badge ${dto.maxRank==1?'bg-success':'bg-secondary' }">${dto.maxRank==1?'낙찰':'패찰' }</span></td>
                                        <td><button type="button" class="btn btn-sm btn-light border text-primary detail-btn">상세</button></td>
                                    </tr>
                                    <tr class="collapse bg-light">
                                        <td colspan="6" class="p-3 text-start">
                                            <div class="ms-4 small">
													<c:choose>
														<c:when test="${dto.maxRank == 1}">
															<h6 class="fw-bold text-success mb-2">
																<i class="bi bi-trophy-fill me-2"></i>최종 낙찰
															</h6>
															<div class="small text-muted">
																<p class="mb-1">
																	<strong>최종 낙찰가:</strong> <span
																		class="text-dark fw-bold"><fmt:formatNumber
																			value="${dto.maxPrice}" type="number" />원</span>
																</p>
																<p class="mb-1">
																	<strong>경매 마감일:</strong> ${dto.auctionEndDate}
																</p>
															</div>
														</c:when>

														<c:otherwise>
															<h6 class="fw-bold text-secondary mb-2">
																<i class="bi bi-info-circle-fill me-2"></i>아쉽게도 낙찰되지
																못했습니다.
															</h6>
															
														</c:otherwise>
													</c:choose>
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