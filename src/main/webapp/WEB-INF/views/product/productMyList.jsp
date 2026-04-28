<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 상품 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #f0f7ff; }
    .navbar { background: white; border-bottom: 1px solid #e3f2fd; }
    .navbar-brand { color: #1565c0 !important; font-weight: 900; font-size: 20px; }
    .nav-link { color: #444 !important; font-size: 14px; font-weight: 500; }
    .nav-link:hover, .nav-link.active { color: #1565c0 !important; }
    .page-header { background-color: #1565c0; color: white; padding: 18px 24px; border-radius: 10px; margin-bottom: 24px; }
    .card { border: none; border-radius: 10px; box-shadow: 0 2px 8px rgba(21,101,192,0.08); }
    .product-row:hover { background-color: #f5f9ff; }
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

<div class="container mt-4 mb-5">
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h5 class="mb-0 fw-bold">내 상품 목록</h5>
            <p class="mb-0 small opacity-75 mt-1">등록한 상품을 확인하고 관리하세요.</p>
        </div>
        <a href="${ctx}/product/register" class="btn btn-light btn-sm fw-bold">+ 새 상품 등록</a>
    </div>

    <p class="text-muted mb-3 small">총 <strong>${totalCount}</strong>개</p>

    <div class="card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4" style="width:50px">#</th>
                        <th>상품명</th>
                        <th class="text-center">등급</th>
                        <th class="text-center">개봉여부</th>
                        <th class="text-center">공개여부</th>
                        <th class="text-center">등록일</th>
                        <th class="text-center">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${myProductList}" varStatus="st">
                        <tr class="product-row">
                            <td class="ps-4 text-muted small">${pageStart + st.index}</td>
                            <td>
                                <a href="${ctx}/product/detail?productId=${p.productId}" class="fw-bold text-dark text-decoration-none">
                                    ${p.productReleaseName}
                                </a>
                                <div class="text-muted small">
                                    ${p.manufacturerName}
                                    <c:if test="${not empty p.productGenreName}"> · ${p.productGenreName}</c:if>
                                </div>
                            </td>
                            <td class="text-center">
                                <span class="badge" style="background:#e3f2fd;color:#1565c0">${p.productGradeName}</span>
                            </td>
                            <td class="text-center">
                                <span class="badge ${p.isOpenedName eq '미개봉' ? 'bg-success' : 'bg-warning text-dark'}">
                                    ${p.isOpenedName}
                                </span>
                            </td>
                            <td class="text-center">
                                <span class="badge ${p.isPublicName eq '공개' ? 'bg-primary' : 'bg-secondary'}">
                                    ${p.isPublicName}
                                </span>
                            </td>
                            <td class="text-center text-muted small">${p.createdAt}</td>
                            <td class="text-center">
                                <a href="${ctx}/product/update?productId=${p.productId}" class="btn btn-outline-secondary btn-sm">수정</a>
                                <a href="${ctx}/product/delete?productId=${p.productId}" class="btn btn-outline-danger btn-sm">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty myProductList}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">등록한 상품이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%-- 페이지네이션 --%>
    <c:if test="${totalPage > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach begin="1" end="${totalPage}" var="i">
                    <li class="page-item ${i eq currentPage ? 'active' : ''}">
                        <a class="page-link" href="${ctx}/product/myList?page=${i}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
