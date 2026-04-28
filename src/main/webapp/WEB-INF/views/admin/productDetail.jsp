<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 상품 상세 조회</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .info-card { background: #fff; border: 1px solid #ced4da; border-radius: 4px; overflow: hidden; }
    .info-header { font-weight: bold; background: #f8f9fa; border-bottom: 1px solid #ced4da; padding: 15px 20px; }
    .info-row { display: flex; border-bottom: 1px solid #dee2e6; }
    .info-label { width: 160px; background-color: #f8f9fa; padding: 15px; font-weight: bold; border-right: 1px solid #dee2e6; }
    .info-value { flex: 1; padding: 15px; }
    .detail-img { max-width: 300px; border: 1px solid #dee2e6; border-radius: 4px; }
</style>
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold">일반 상품 상세 정보</h4>
        <div>
            <button class="btn btn-outline-secondary me-2">상품 비공개 처리</button>
            <button class="btn btn-danger">삭제 및 패널티 부여</button>
        </div>
    </div>
    
    <div class="info-card shadow-sm">
        <div class="info-header">기본 상품 정보</div>
        <div class="info-row">
            <div class="info-label">상품 이미지</div>
            <div class="info-value text-center"><img src="${ pageContext.request.contextPath }/images/tempFigureImage.png" class="detail-img"></div>
        </div>
        <div class="info-row">
            <div class="info-label">상품명</div>
            <div class="info-value">하츠네 미쿠 한정판 피규어</div>
        </div>
        <div class="info-row">
            <div class="info-label">제조사/국가</div>
            <div class="info-value">모름 / 일본</div>
        </div>
        <div class="info-row">
            <div class="info-label">상태 등급</div>
            <div class="info-value"><span class="badge bg-success">최상</span></div>
        </div>
    </div>
</div>
</body>
</html>