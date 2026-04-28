<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 삭제</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #f0f7ff; }
    .navbar { background: white; border-bottom: 1px solid #e3f2fd; }
    .navbar-brand { color: #1565c0 !important; font-weight: 900; font-size: 20px; }
    .nav-link { color: #444 !important; font-size: 14px; font-weight: 500; }
    .nav-link:hover { color: #1565c0 !important; }
    .delete-card { border: none; border-radius: 14px; box-shadow: 0 4px 16px rgba(21,101,192,0.1); max-width: 480px; margin: 60px auto; padding: 40px; }
    .icon-circle { width: 56px; height: 56px; border-radius: 50%; background-color: #ffebee; color: #c62828; font-size: 26px; font-weight: bold; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; }
</style>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%-- <nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${ctx}/main">경매나라</a>
        <div class="d-flex gap-3 ms-4">
            <a href="${ctx}/auction/list" class="nav-link">경매</a>
            <a href="${ctx}/product/list" class="nav-link">컬렉션</a>
            <a href="${ctx}/product/myList" class="nav-link active">내 상품</a>
        </div>
    </div>
</nav> --%>

<div class="container">
    <div class="card delete-card text-center">
        <div class="icon-circle">!</div>
        <h5 class="fw-bold mb-3">상품을 삭제하시겠습니까?</h5>
        <div class="alert alert-danger text-start small">
            삭제된 상품 정보는 <strong>복구가 불가능</strong>합니다.<br>
            현재 경매 진행 중인 상품인 경우, 취소 시 <strong>보증금 몰수 등의 패널티</strong>가 발생할 수 있습니다.
        </div>

        <div class="border rounded p-3 mb-4 text-start bg-light">
            <p class="fw-bold mb-1">${product.productReleaseName}</p>
            <p class="text-muted small mb-0">등록일: ${product.createdAt}</p>
        </div>

        <form action="${ctx}/product/delete" method="post">
            <input type="hidden" name="productId" value="${product.productId}">
            <div class="d-flex gap-2">
                <button type="button" class="btn btn-outline-secondary w-50"
                        onclick="location.href='${ctx}/product/detail?productId=${product.productId}'">취소</button>
                <button type="submit" class="btn btn-danger w-50">삭제하기</button>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
