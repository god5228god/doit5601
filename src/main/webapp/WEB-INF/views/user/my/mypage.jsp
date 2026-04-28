<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - Auction PKG</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
   	<style type="text/css">
		body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; }
		.container { flex: 1; }
		
		.stat-card {
			transition: all 0.3s ease;
			cursor: pointer;
			border: 1px solid #eee;
			border-radius: 15px;
		}
		.stat-card:hover {
			transform: translateY(-5px);
			box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important;
			border-color: #120e63;
		}
		.icon-box {
			width: 50px; height: 50px;
			display: flex; align-items: center; justify-content: center;
			border-radius: 12px; margin-bottom: 15px;
		}
		.btn-primary {
	background-color: #120e63 !important;
	border-color: #120e63 !important;
}
   	</style>
</head>
<body class="bg-light">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<main class="container" style="margin-top: 50px; margin-bottom: 50px;">
		<div class="row">
			<aside class="col-md-3">
				<%@ include file="/WEB-INF/views/common/mypage_layout.jsp" %>
			</aside>
			
			<section class="col-md-9">
				<div class="d-flex align-items-center justify-content-between mb-4">
					<div>
						<h3 class="fw-bold mb-1">반갑습니다, ${loginUser.userName } 님!</h3>
					</div>
					<a href="${pageContext.request.contextPath}/user/my/change-info" class="btn btn-outline-secondary btn-sm rounded-pill">정보 수정</a>
				</div>

				<div class="row g-3 mb-4">
					<div class="col-md-4" onclick="location.href='${pageContext.request.contextPath}/user/auctions/active'">
						<div class="card stat-card shadow-sm p-3 bg-white text-center">
							<div class="icon-box bg-primary-subtle text-primary mx-auto">
								<i class="bi bi-hammer fs-4"></i>
							</div>
							<small class="text-muted fw-semibold">진행중인 경매</small>
							<h4 class="mt-1 fw-bold">${auctionCnt }<span class="fs-6 fw-normal ms-1">건</span></h4>
						</div>
					</div>
					<div class="col-md-4" onclick="location.href='${pageContext.request.contextPath}/user/bids/active'">
						<div class="card stat-card shadow-sm p-3 bg-white text-center">
							<div class="icon-box bg-success-subtle text-success mx-auto">
								<i class="bi bi-clock-history fs-4"></i>
							</div>
							<small class="text-muted fw-semibold">진행중인 입찰</small>
							<h4 class="mt-1 fw-bold">${bidCnt }<span class="fs-6 fw-normal ms-1">건</span></h4>
						</div>
					</div>
					<div class="col-md-4" onclick="location.href='${pageContext.request.contextPath}/user/product/wishlist'">
						<div class="card stat-card shadow-sm p-3 bg-white text-center">
							<div class="icon-box bg-danger-subtle text-danger mx-auto">
								<i class="bi bi-heart-fill fs-4"></i>
							</div>
							<small class="text-muted fw-semibold">내 관심 상품</small>
							<h4 class="mt-1 fw-bold">${wishCnt }<span class="fs-6 fw-normal ms-1">건</span></h4>
						</div>
					</div>
				</div>

				<div class="row g-3">
					<div class="col-md-6" onclick="location.href='${pageContext.request.contextPath}/'">
						<div class="card stat-card shadow-sm p-4 bg-white border-start border-2 border-primary" style="border-color: #120e63 !important;">
							<div class="d-flex justify-content-between align-items-center">
								<div>
									<small class="text-muted d-block mb-1">사용 가능한 보유머니</small>
									<h3 class="fw-bold txtColor mb-0">
									<fmt:formatNumber value="${loginUser.totalMoney}" type="number" />
									
									원</h3>
								</div>
								<div class="btn btn-primary rounded-pill px-3">충전</div>
							</div>
						</div>
					</div>
					<div class="col-md-6" onclick="location.href='${pageContext.request.contextPath}/user/penalty'">
						<div class="card stat-card shadow-sm p-4 bg-white border-start border-2 border-danger">
							<div class="d-flex justify-content-between align-items-center">
								<div>
									<small class="text-muted d-block mb-1">나의 패널티 점수</small>
									<h3 class="fw-bold text-danger mb-0">1점</h3>
								</div>
								<div class="text-muted small">이력 확인 <i class="bi bi-chevron-right"></i></div>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
	</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>

