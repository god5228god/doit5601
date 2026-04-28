<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머니 이력</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/money.css">

<style type="text/css">

body {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
	margin: 0;
}

.container {
	flex: 1;
}


a:visited, a {
	text-decoration: none;
	color: black;
	font-weight: bold;
}

.pagecontrol {
	margin-top: auto;
	margin-bottom: 10px;
	align-items: center;
}

.sel {
	margin-top: 20px;
	margin-bottom: 20px;
	display: flex;
}

h1 {
	font-size: 20px !important;
	font-weight:bold !important;
}

.form-select {
	width: 150px;
	margin-left: 20px;
	height: 38px;
}

.row-filter {
	width: 350px;
	margin-left: 20px;
	display: flex;
	align-items: center;
}

.btn-dark {
	margin-left: 20px;
	width: 80px;
}

.tot {
	width: 100%;
	margin: 0 auto;
	display: flex;
	align-items: center;
	justify-content: center;
}

.bid {
	padding: 10px;
	height: 100px;
	width: 30%;
	border: 2px solid silver;
	margin: 10px;
	text-align: center;
	border-radius: 8px;
}

.bid>span {
	display: block;
}

table {
	width: 100%;
	font-size: 16px;
	text-align: center;
	margin-bottom: 40px;
}

th {
	border: 1px solid silver;
	border-radius: 10px;
	height: 40px;
}

tr {
	height: 40px;
	border-bottom: 1px solid silver;
	border: 1px solid silver;
}

hr {
	margin-top: 10px;
	margin-bottom: 15px;
}
</style>

<script type="text/javascript">
	function change() {
		document.moneyForm.submit();
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
				<div class="p-4 bg-white shadow-sm"
					style="min-height: 1050px; border-radius: 15px;">
					<h1>머니 이력</h1>
					<hr />

					<div class="tot">
						<div class="bid">
							<span>보유 머니</span>
							<hr />
							<span class="view"><fmt:formatNumber
									value="${loginUser.totalMoney}" /> 원</span>
						</div>
						<span>▶</span>
						<div class="bid">
							<span>환급 예정 보증금</span>
							<hr />
							<span class="view">0 원</span>
						</div>
						<span>▶</span>
						<div class="bid">
							<span>전체 머니</span>
							<hr />
							<span class="view"><fmt:formatNumber
									value="${loginUser.totalMoney}" /> 원</span>
						</div>
					</div>

					<form action="${pageContext.request.contextPath}/payment.history"
						name="moneyForm">
						<div class="sel">
							<select class="form-select" onchange="change()" name="inout">
								<option selected value="">입출금 구분</option>
								<option value="1" ${inout == 1 ? 'selected' : ''}>입금</option>
								<option value="2" ${inout == 2 ? 'selected' : ''}>출금</option>
							</select> <select class="form-select" onchange="change()" name="part">
								<option selected value="">상세 구분</option>
								<option value="1" ${part == 1 ? 'selected' : ''}>결제</option>
								<option value="8" ${part == 8 ? 'selected' : ''}>충전</option>
							</select>

							<div class="row-filter">
								<input type="text" class="form-control" placeholder="시작일">
								<span class="mx-1">~</span> <input type="text"
									class="form-control" placeholder="종료일">
								<button type="button" class="btn btn-dark">검색</button>
							</div>
						</div>
					</form>

					<table>
						<thead>
							<tr>
								<th style="width: 230px;">참여 구분</th>
								<th style="width: 180px;">사용 구분</th>
								<th style="width: 100px;">입출금</th>
								<th style="width: 150px;">금액</th>
								<th style="width: 300px;">이력 일자</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="money" items="${moneyList}">
								<tr>
									<td>${money.transactionType}</td>
									<td>${money.part}</td>
									<td>${money.inout}</td>
									<td><strong><fmt:formatNumber
												value="${money.amount}" /></strong> 원</td>
									<td><fmt:formatDate value="${money.transactionDate}"
											pattern="yyyy년 MM월 dd일 - HH시 mm분" /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<div class="pagecontrol">
						<nav aria-label="Page navigation example">
							<ul class="pagination justify-content-center">
								<li class="page-item"><a class="page-link" href="#">&laquo;</a></li>
								<c:forEach var="p" begin="1" end="${totalPage}" varStatus="var">
									<li class="page-item ${p == currentPage ? 'active' : ''}">
										<a class="page-link" href="?page=${var.count}">${var.count}</a>
									</li>
								</c:forEach>
								<li class="page-item"><a class="page-link" href="#">&raquo;</a></li>
							</ul>
						</nav>
					</div>
				</div>
			</section>
		</div>
	</main>

	<%@ include file="/WEB-INF/views/common/footer.jsp"%>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>