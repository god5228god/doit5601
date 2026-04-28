<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 패널티 이력</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
<script>
$(function() {
    $('#penalty-history-table').on('click', '.detail-btn', function(e) {
        e.preventDefault();
        const $targetRow = $(this).closest('tr').next('.collapse');
        const $otherRows = $('#penalty-history-table').find('.collapse').not($targetRow);

        $otherRows.stop(true, true).hide().removeClass('show');
        $targetRow.stop(true, true).slideToggle(200, function() {
            $(this).toggleClass('show', $(this).is(':visible'));
        });
    });
});
</script>
<style>
    #penalty-history-table tr:has(+ .collapse.show) td {
        border-bottom: none !important;
    }
    #penalty-history-table .collapse.bg-light {
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
        <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-exclamation-octagon-fill me-2"></i>패널티 이력
            </h5>
            <span class="badge bg-danger" style="width: 140px; height: 40px; font-size: 16px; line-height: 30px;">누적 패널티: 2점</span>
        </div>
        
        <div class="card-body">
            <div class="alert alert-light border small mb-4 shadow-sm">
                <div class="row text-center g-0">
                    <div class="col-3 border-end"><span class="badge rounded-pill bg-warning text-dark mb-1">1단계</span><br><strong>1점:</strong> 경고</div>
                    <div class="col-3 border-end"><span class="badge rounded-pill bg-orange text-white mb-1" style="background-color: #fd7e14;">2단계</span><br><strong>2점:</strong> 7일 정지</div>
                    <div class="col-3 border-end"><span class="badge rounded-pill bg-danger mb-1">3단계</span><br><strong>3점:</strong> 30일 정지</div>
                    <div class="col-3"><span class="badge rounded-pill bg-dark mb-1">4단계</span><br><strong>4점:</strong> 영구 정지</div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table align-middle text-center" id="penalty-history-table">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px;">번호</th>
                            <th>점수</th>
                            <th>구분</th>
                            <th>부여일</th>
                            <th>상태</th>
                            <th style="width: 120px;">비고</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>3</td>
                            <td><span class="badge bg-danger-subtle text-danger">+2점</span></td>
                            <td class="fw-bold text-dark">7일 이용정지</td>
                            <td>2026-04-10</td>
                            <td><span class="badge bg-danger px-3">적용중</span></td>
                            <td><button type="button" class="btn btn-sm btn-outline-dark detail-btn">상세</button></td>
                        </tr>
                        <tr class="collapse bg-light">
                            <td colspan="6" class="p-4 text-start">
                                <div class="ms-4 border-start ps-3 border-3 border-danger">
                                    <h6 class="fw-bold">상세 내용</h6>
                                    <p class="mb-1 small text-muted"><strong>제재 기간:</strong> 2026-04-10 ~ 2026-04-17 (7일간)</p>
                                </div>
                            </td>
                        </tr>

                        <tr class="table-active opacity-75">
                            <td>2</td>
                            <td><span class="text-muted">+1점</span></td>
                            <td class="text-muted">경고</td>
                            <td>2026-03-05</td>
                            <td>
                                <span class="badge bg-white text-secondary border border-secondary shadow-sm">
                                    <i class="bi bi-x-circle-fill me-1"></i>부여취소
                                </span>
                            </td>
                            <td><button type="button" class="btn btn-sm btn-secondary detail-btn">취소사유</button></td>
                        </tr>
                        <tr class="collapse bg-light-subtle">
                            <td colspan="6" class="p-4 text-start">
                                <div class="ms-4 border-start ps-3 border-3 border-secondary">
                                    <h6 class="fw-bold text-secondary">취소 및 철회 정보</h6>
                                    <p class="mb-1 small text-primary"><strong>취소 일시:</strong> 2026-03-07 14:30</p>
                                    <p class="mb-0 small text-muted"><strong>철회 사유:</strong> 소명 절차 결과 오신고로 판명되어 즉시 패널티 회수 조치함</p>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>1</td>
                            <td><span class="badge bg-warning-subtle text-warning-emphasis">+1점</span></td>
                            <td class="text-dark">경고</td>
                            <td>2026-01-20</td>
                            <td><span class="badge bg-light text-muted border">기간종료</span></td>
                            <td><button type="button" class="btn btn-sm btn-outline-secondary detail-btn">상세</button></td>
                        </tr>
                        <tr class="collapse bg-light">
                            <td colspan="6" class="p-4 text-start">
                                <div class="ms-4 border-start ps-3 border-3 border-warning">
                                    <h6 class="fw-bold">상세 내용</h6>
                                    <p class="mb-1 small text-muted"><strong>적용 기간:</strong> 2026-01-20 ~ 2026-02-20</p>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>
		</div>
	</div>

  <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>