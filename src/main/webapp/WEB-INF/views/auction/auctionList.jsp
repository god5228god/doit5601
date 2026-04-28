<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>경매나라 - 실시간 경매</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<style>
    body { background-color: #f8fafd; }
    .navbar-brand { font-weight: 700; color: #1565c0 !important; }
    .page-header { background: #f8f9fa; padding: 3rem 0 2rem 0; }
    .header-title { font-weight: 800; color: #222; }
    .filter-bar { background: white; border-bottom: 1px solid #e3f2fd; padding: 12px 0; margin-bottom: 30px; }
    .auction-card { border: none; border-radius: 12px; overflow: hidden; background: white;
                    transition: all 0.2s ease; box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                    height: 100%; cursor: pointer; }
    .auction-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(21,101,192,0.1); }
    .auction-card img { aspect-ratio: 1/1; object-fit: cover; width: 100%; }
    .badge-grade { background: #e3f2fd; color: #1565c0; font-size: 11px; padding: 3px 8px; border-radius: 4px; font-weight: 600; }
    .timer-badge { background: #fff3e0; color: #e65100; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; }
    .item-name { font-size: 15px; font-weight: 700; color: #333; margin: 10px 0 4px 0;
                 height: 42px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    .item-maker { font-size: 12px; color: #888; margin-bottom: 10px; }
    .price-label { font-size: 12px; color: #666; }
    .current-price { font-size: 18px; font-weight: 800; color: #1565c0; }
    .bid-count { font-size: 11px; color: #999; }
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="page-header text-center">
    <div class="container">
        <h2 class="header-title">실시간 경매</h2>
        <p class="text-muted mb-0 small">지금 참여하고 최고의 컬렉션을 소유하세요!</p>
    </div>
</div>

<div class="filter-bar shadow-sm">
    <div class="container">
        <form method="get" action="${ctx}/auction/list" class="row g-2 align-items-center">
            <div class="col-auto">
                <input type="text" name="keyword" class="form-control form-control-sm"
                       placeholder="경매명 검색" value="${param.keyword}">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary btn-sm px-3">검색</button>
            </div>
        </form>
    </div>
</div>

<div class="container pb-5">
    <p class="text-muted mb-3 small">총 <strong>${totalCount}</strong>개의 경매 진행 중</p>

    <div class="row row-cols-2 row-cols-md-4 g-4">
        <c:forEach var="a" items="${auctionList}">
            <div class="col">
                <div class="auction-card card"
                     onclick="location.href='${ctx}/auction/detail?auctionId=${a.auctionId}'">
                    <c:choose>
                        <c:when test="${not empty a.imagePath1}">
                            <img src="${ctx}/${a.imagePath1}" alt="${a.auctionTitle}">
                        </c:when>
                        <c:otherwise>
                            <img src="https://placehold.co/300x300/e3f2fd/1565c0?text=No+Image" alt="">
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body p-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <%-- 마감 시간 표시 --%>
                            <span class="timer-badge" id="timer-${a.auctionId}"
                                  data-enddate="${a.auctionEndDate}">
                                <i class="bi bi-clock me-1"></i>${a.auctionEndDate}
                            </span>
                            <span class="badge-grade">${a.productGradeName}</span>
                        </div>
                        <div class="item-name">${a.auctionTitle}</div>
                        <div class="item-maker text-truncate">${a.manufacturerName}</div>
                        <div class="d-flex justify-content-between align-items-end mt-2">
                            <div>
                                <div class="price-label">현재 입찰가</div>
                                <div class="current-price">
                                    <fmt:formatNumber value="${a.bidCurrentPrice}" pattern="#,###"/>원
                                </div>
                            </div>
                            <div class="bid-count">입찰 ${a.bidCount}회</div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty auctionList}">
            <div class="col-12 text-center text-muted py-5">진행 중인 경매가 없습니다.</div>
        </c:if>
    </div>

    <%-- 페이지네이션 --%>
    <c:if test="${totalPage > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <c:forEach begin="1" end="${totalPage}" var="i">
                    <li class="page-item ${i eq currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="${ctx}/auction/list?page=${i}&keyword=${param.keyword}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>
</div>

<script>
function startTimers() {
    document.querySelectorAll('[id^="timer-"]').forEach(function(el) {
        var endDateStr = el.getAttribute('data-enddate');
        if (!endDateStr || endDateStr === '-') return;
        var parts = endDateStr.replace('T', ' ').split(/[\s:-]/);
        var endDate = new Date(parts[0], parts[1]-1, parts[2], parts[3]||0, parts[4]||0, parts[5]||0);
        function update() {
            var now = new Date();
            var diff = Math.floor((endDate - now) / 1000);
            if (diff <= 0) {
                el.innerHTML = '<i class="bi bi-clock me-1"></i>마감';
                return;
            }
            var h = String(Math.floor(diff / 3600)).padStart(2, '0');
            var m = String(Math.floor((diff % 3600) / 60)).padStart(2, '0');
            var s = String(diff % 60).padStart(2, '0');
            el.innerHTML = '<i class="bi bi-clock me-1"></i>' + h + ':' + m + ':' + s;
        }
        update();
        setInterval(update, 1000);
    });
}
startTimers();
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>

