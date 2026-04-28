<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>낙찰 상품 - Auction PKG</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resource/css/biditem.css">

<style type="text/css">

body {
	margin-top: 50px;
}

.up {
	margin-top: 50px;
	border-radius: 7px;
	border: 1px solid silver;
	font-size: 16px;
	padding: 60px !important;
}

a, a:visited {
	color: black !important;
	text-decoration: none !important;
}

h1 {
	font-size: 20px !important;
	font-weight: bold !important;
}

.box {
	border: 1px solid silver;
	height: 100px;
	width: 90%;
	border-radius: 7px;
	position: relative;
	margin: 30px auto;
	text-align: center;
}

.tot {
	display: flex;
}

.bid {
	padding: 10px;
	height: 100%;
	width: 100%;
}

.bid>span {
	display: block;
}

.view {
	height: 70%;
	margin-top: 25px;
}

.box3 {
	border: 1px solid silver;
	border-radius: 7px;
	width: 90%;
	text-align: left;
	padding: 50px;
	margin: 0 auto;
}

.item {
	vertical-align: top;
	border-radius: 7px;
	border: 1px solid silver;
	margin: 10px;
	display: inline-block;
	width: 200px;
	height: 255px;
}

hr {
	margin: 10px;
}

.item span {
	display: block;
}

.item img {
	border-radius: 5px;
	object-fit: cover;
	width: 100%;
	height: 100%;
}

.imgwrap {
	width: 100%;
	height: 170px;
	overflow: hidden;
	background-color: #f9f9f9;
}

.sel {
	margin-bottom: 20px;
	width: 850px;
	display: flex;
	margin-left: 50px;
}

.form-select {
	width: 150px !important;
	margin-left: 20px;
}

.btn-dark {
	margin-left: 20px;
	width: 80px !important;
	height: 37px !important;
	font-size: 15px;
	font-weight: bold;
	padding: 1px;
}

</style>

<script type="text/javascript">
/* 기존 스크립트 유지 */
function con(userId, bidId) {
    if (!confirm("구매를 확정하시겠습니까?")) return;
    fetch("${pageContext.request.contextPath}/user/purchaseConfirmAction?bidId=" + bidId + "&userId=" + userId)
    .then(response => response.text())
    .then(data => {
        if(data.trim() === "success") {
            alert("구매가 확정되었습니다.");
            let container = document.getElementById("confirmContainer_" + bidId);
            container.innerHTML = "<span>구매확정완료</span>";
        } else { alert("처리에 실패했습니다."); }
    }).catch(error => { console.error("Error:", error); });
}
</script>
</head>
<body class="bg-light">

	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<main class="container" style="margin-top: 50px; margin-bottom: 50px;">
		<div class="row">
			<aside class="col-md-3">
				<%@ include file="/WEB-INF/views/common/mypage_layout.jsp"%>
			</aside>

			<section class="col-md-9">
				<div class="up shadow-sm border-0 bg-white p-4" style="width: 100%;">
					<div class="body">
						<h1>낙찰 상품</h1>
						<hr />
						<div class="box shadow-sm">
							<div class="tot">
								<div class="bid">
									<span>낙찰 상품</span>
									<hr />
									<a href=""><span class="view">${winnerCount.total}</span></a>
								</div>
								<div class="bid">
									<span>낙찰포기 상품</span>
									<hr />
									<a href=""><span class="view">${winnerCount.fail}</span></a>
								</div>
								<div class="bid">
									<span>미결제 상품</span>
									<hr />
									<a href=""><span class="view">${winnerCount.unpayment}</span></a>
								</div>
								<div class="bid">
									<span>배송대기 상품</span>
									<hr />
									<a href=""><span class="view">${winnerCount.unshipping}</span></a>
								</div>
								<div class="bid">
									<span>배송완료 상품</span>
									<hr />
									<a href=""><span class="view">${winnerCount.shipping}</span></a>
								</div>
								<div class="bid">
									<span>구매확정완료</span>
									<hr />
									<a href=""><span class="view">${winnerCount.confirm}</span></a>
								</div>
							</div>
						</div>

						<div class="sel">
							<form action="${pageContext.request.contextPath}/user/products">
								<select class="form-select" name="type"
									onchange="this.form.submit()">
									<option value=""
										${param.type == ''|| param.type == 0 ? 'selected' : '' }>낙찰
										상품</option>
									<option value="1" ${param.type == 1 ? 'selected' : '' }>낙찰
										취소</option>
									<option value="2" ${param.type == 2 ? 'selected' : '' }>미
										결제</option>
									<option value="3" ${param.type == 3 ? 'selected' : '' }>배송
										대기</option>
									<option value="4" ${param.type == 4 ? 'selected' : '' }>배송
										완료</option>
									<option value="5" ${param.type == 5 ? 'selected' : '' }>구매
										확정</option>
								</select>
							</form>
							<div class="d-flex align-items-center ms-3">
								<input type="text" class="form-control" placeholder="First day"
									style="width: 150px;"> <span class="mx-2">~</span> <input
									type="text" class="form-control" placeholder="Last day"
									style="width: 150px;">
								<button type="button" class="btn btn-dark ms-3">검색</button>
							</div>
						</div>

						<div class="box3 shadow-sm">
							<c:forEach var="bid" items="${winnerList}">
								<a href="${pageContext.request.contextPath }/product/detail?productId=${bid.productId}">
									<div class="item shadow-sm">
										<div class="imgwrap">
											<img src="${bid.img}" alt="상품이미지" />
										</div>
										<div class="itemtext">
											<span class="title">${bid.auctionTitle}</span> <span
												class="bidcount">${bid.finalPrice} 원</span>
											<div class="position">
												<c:choose>
													<c:when test="${bid.fail == 'Y'}">
														<span>${bid.failType == 1 ? '기한만료' : '낙찰취소'}</span>
													</c:when>
													<c:when test="${bid.confirm == 'Y'}">
														<span>확정완료</span>
													</c:when>
													<c:when test="${bid.shipping == 'Y'}">
														<span id="confirmContainer_${bid.winnerBidId}">
															<button type="button" class="btn btn-light btn-sm"
																onclick="con(${bid.winnerUserId},${bid.winnerBidId})">구매확정</button>
														</span>
													</c:when>
													<c:when
														test="${bid.paymentStat == 'Completed' && bid.shipping == 'N'}">
														<span>배송대기</span>
													</c:when>
													<c:when test="${bid.paymentStat == 'Pending'}">
														<a
															href="${pageContext.request.contextPath}/payment.detail?userId=${bid.winnerUserId}&resultId=${bid.winnerBidId}">
															<button type="button" class="btn btn-light btn-sm">결제하기</button>
														</a>
													</c:when>
												</c:choose>
											</div>
										</div>
									</div>
								</a>
							</c:forEach>

							<div class="pagecontrol mt-4">
								<nav aria-label="Page navigation example">
									<ul class="pagination justify-content-center">
										<li class="page-item"><a class="page-link" href="#">&laquo;</a></li>
										<c:forEach var="page" begin="${startPage}" end="${endPage}"
											varStatus="var">
											<li class="page-item"><a class="page-link" href="#">${var.count}</a></li>
										</c:forEach>
										<li class="page-item"><a class="page-link" href="#">&raquo;</a></li>
									</ul>
								</nav>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
	</main>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>