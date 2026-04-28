<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
	crossorigin="anonymous"></script>
<style type="text/css">
span {
	font-weight: bold;
	text-align: center;
	font-size:18px;
}
body
{
	margin:50px;
	
}
h1
{
	font-size: 25px;
	font-weight: bold;
	text-align: left;
}

h2
{
	font-size: 35px;
	font-weight: bold;
	text-align: center;
}
.body
{
	margin:auto;
	width: 500px;
	height:500px;
	padding: 20px;
	text-align: center;
	margin-bottom: 200px;
	margin-top: 50px;
	border: 1px solid silver;
	border-radius: 7px;
}
.m
{
	text-align: center;
	margin-top:20px;
}
.c
{
	color: gray;
}
button
{
	width: 30%;
	height: 45px;
}
.bt
{
	margin-top:200px;
	margin-bottom: 20px;
}
a:visited ,a
{
	text-decoration: none;
}
</style>
<script type="text/javascript">
	document.onkeydown = function(e) {
		// F5 키(116) 또는 Ctrl+R(82) 조합 막기
		if (e.keyCode == 116 || (e.ctrlKey && e.keyCode == 82)) {
			e.preventDefault();
			alert("새로고침을 할 수 없습니다.");
			return false;
		}
	};
</script>
</head>
<body>

	<div class="body shadow-sm">
		<h1>충전</h1>
		<hr />
		<span>${message }</span> <br />
		<h2 class="m">
			<fmt:formatNumber value="${chargeMoney }" type="number" />
			원
		</h2>
		<br /> 
		
		<span class="c">현재 잔액</span> <span class="c"><fmt:formatNumber
				value="${totalMoney }" type="number" /> 원 </span><br /> 
				
		<div class="bt">
		<a href="${pageContext.request.contextPath }/payment/">
			<button type="button" class="btn btn-light">추가충전</button>
		</a> <a href="${pageContext.request.contextPath }/payment.history"/><button
				type="button" class="btn btn-light">머니이력</button></a> <a
			href="${pageContext.request.contextPath }/main"><button type="button"
				class="btn btn-light">메인으로</button></a>
		</div>
	</div>
</body>
</html>