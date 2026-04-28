<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        .product-card { cursor: pointer; }
        .product-card img { height: 180px; object-fit: cover; }
        .navbar-brand { font-weight: 700; color: #4F46E5 !important; }

        .page-header { background: #f8f9fa; padding: 3rem 0 2rem 0; }
        .header-title { font-weight: 800; color: #222; }
    </style>
</head>
<body class="bg-light">
 <%@ include file="/WEB-INF/views/common/header.jsp" %>
<%-- <jsp:include page="/common/header.jsp"></jsp:include> --%>

<%-- 상단 헤더 --%>
<div class="page-header text-center">
    <div class="container">
        <h2 class="header-title">컬렉션</h2>
        <p class="text-muted mb-0 small">다양한 피규어 컬렉션을 만나보세요</p>
    </div>
</div>

<%-- 검색/필터 --%>
<div class="bg-white border-bottom py-2">
    <div class="container">
        <form method="get" action="${ctx}/product/list" class="row g-2 align-items-center">
            <div class="col-auto">
                <select name="genre" class="form-select form-select-sm">
                    <option value="">장르 전체</option>
                    <c:forEach var="g" items="${genreList}">
                        <option value="${g.productGenreId}" <c:if test="${param.genre eq g.productGenreId}">selected</c:if>>${g.productGenreName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <select name="size" class="form-select form-select-sm">
                    <option value="">사이즈 전체</option>
                    <c:forEach var="s" items="${sizeList}">
                        <option value="${s.productSizeId}" <c:if test="${param.size eq s.productSizeId}">selected</c:if>>${s.productSizeName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <select name="maker" class="form-select form-select-sm">
                    <option value="">제조사 전체</option>
                    <c:forEach var="m" items="${makerList}">
                        <option value="${m.manufacturerId}" <c:if test="${param.maker eq m.manufacturerId}">selected</c:if>>${m.manufacturerName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <select name="grade" class="form-select form-select-sm">
                    <option value="">등급 전체</option>
                    <c:forEach var="gd" items="${gradeList}">
                        <option value="${gd.productGradeId}" <c:if test="${param.grade eq gd.productGradeId}">selected</c:if>>${gd.productGradeName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <input type="text" name="keyword" class="form-control form-control-sm" placeholder="키워드 검색" value="${param.keyword}">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-dark btn-sm">검색</button>
            </div>
            <div class="col-auto ms-auto">
                <div class="btn-group btn-group-sm">
                    <a href="${ctx}/product/list?sort=newest&genre=${param.genre}&size=${param.size}&maker=${param.maker}&grade=${param.grade}&keyword=${param.keyword}"
                       class="btn btn-outline-secondary ${param.sort eq 'newest' or empty param.sort ? 'active' : ''}">등록순</a>
                    <a href="${ctx}/product/list?sort=popular&genre=${param.genre}&size=${param.size}&maker=${param.maker}&grade=${param.grade}&keyword=${param.keyword}"
                       class="btn btn-outline-secondary ${param.sort eq 'popular' ? 'active' : ''}">인기순</a>
                    <a href="${ctx}/product/list?sort=grade&genre=${param.genre}&size=${param.size}&maker=${param.maker}&grade=${param.grade}&keyword=${param.keyword}"
                       class="btn btn-outline-secondary ${param.sort eq 'grade' ? 'active' : ''}">등급순</a>
                </div>
            </div>
             <div class="col-auto">
                <a href="${ctx}/product/register" class="btn btn-primary btn-sm px-3">
                    <i class="bi bi-plus-lg"></i> 내 상품 등록하기
                </a>
            </div>
        </form>
    </div>
</div>

<%-- 상품 목록 --%>
<div class="container py-4">

    <p class="text-muted mb-3 small">총 <strong>${totalCount}</strong>개 상품</p>

    <div class="row g-3">
        <c:forEach var="p" items="${productList}">
            <div class="col-6 col-md-3">
                <div class="card product-card h-100" onclick="location.href='${ctx}/product/detail?productId=${p.productId}'">
                    <c:choose>
                        <c:when test="${not empty p.imagePath1}">
                            <img src="${ctx}/${p.imagePath1}" class="card-img-top" alt="${p.productReleaseName}">
                        </c:when>
                        <c:otherwise>
                            <img src="https://placehold.co/300x180/e9ecef/6c757d?text=No+Image" class="card-img-top" alt="">
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body p-2">
                        <span class="badge bg-secondary">${p.productGradeName}</span>
                        <p class="fw-semibold mb-0 mt-1">${p.productReleaseName}</p>
                        <p class="text-muted mb-0 small">${p.manufacturerName} · ${p.productSizeName}</p>
                        <c:if test="${not empty p.productAlias}">
                            <p class="text-muted mb-0 small">${p.productAlias}</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty productList}">
            <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
        </c:if>
    </div>

    <%-- 페이지네이션 --%>
    <c:if test="${totalPage > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach begin="1" end="${totalPage}" var="i">
                    <li class="page-item ${i eq currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="${ctx}/product/list?page=${i}&sort=${param.sort}&genre=${param.genre}&size=${param.size}&maker=${param.maker}&grade=${param.grade}&keyword=${param.keyword}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>

</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
