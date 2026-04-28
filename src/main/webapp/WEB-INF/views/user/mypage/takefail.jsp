<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	font-size: 18px;
}

body {
	margin: 50px;
}

h1 {
	font-size: 25px;
	font-weight: bold;
	text-align: left;
}

h2 {
	font-size: 18px;
	font-weight: bold;
	text-align: left;
}

.body {
	margin: auto;
	width: 500px;
	height: 600px;
	padding: 20px;
	text-align: center;
	margin-bottom: 200px;
	margin-top: 50px;
	border: 1px solid silver;
	border-radius: 7px;
}

.list-group {
	text-align: left;
}

.m {
	text-align: center;
	margin-top: 20px;
}

.c {
	color: gray;
}

button {
	width: 45%;
	height: 60px;
	margin-left: 10px;
	margin-right: 10px;
}

.bt {
	margin-top: 50px;
	margin-bottom: 30px;
}

.form-control {
	margin-top: 20px;
	height: 150px !important;
}

a:visited, a {
	text-decoration: none;
}
</style>
<script type="text/javascript">
	function check()
	{
		let chek1 = document.getElementById("firstCheckbox"); 
		let chek2 = document.getElementById("secondCheckbox"); 
		let chek3 = document.getElementById("thirdCheckbox"); 
		
		if(!chek1.checked)
		{
			alert("약관을 읽고 체크해주세요");
			chek1.focus();
			return;
		}
		if(!chek2.checked)
		{
			alert("약관을 읽고 체크해주세요");
			chek2.focus();
			return;
		}
		if(!chek3.checked)
		{
			alert("약관을 읽고 체크해주세요");
			chek3.focus();
			return;
		}
		
		location.href="${pageContext.request.contextPath}/user/products";
		
	}
</script>

</head>
<body>

	<div class="body shadow-sm">
		<h1>낙찰 취소</h1>
		<hr />

		`
		<form action="">
			<div class="adressconfirm">
				<ul class="list-group">
					<li class="list-group-item"><input
						class="form-check-input me-1" type="checkbox" value=""
						id="firstCheckbox"> <label class="form-check-label"
						for="firstCheckbox">낙찰 포기시 입찰시 납부한 보증금은 전액 몰수됩니다.</label></li>
					<li class="list-group-item"><input
						class="form-check-input me-1" type="checkbox" value=""
						id="secondCheckbox"> <label class="form-check-label"
						for="secondCheckbox">1회의 구매자 패널티가 부여됩니다</label></li>
					<li class="list-group-item"><input
						class="form-check-input me-1" type="checkbox" value=""
						id="thirdCheckbox"> <label class="form-check-label"
						for="thirdCheckbox">3회 패널티 누적시 계정이 정지될 수 있습니다.</label></li>
				</ul>
				<hr />
				<select class="form-select" aria-label="Default select example"
					id="postDetail" onchange="check(this)">
					<option selected>취소 사유</option>
					<option value="1" selected="selected">낙찰 포기</option>
				</select>

				<div class="form-floating">
					<textarea class="form-control" placeholder="Leave a comment here"
						id="floatingTextarea"></textarea>
					<label for="floatingTextarea">사유를 입력해주세요</label>
				</div>
			</div>
			<div class="bt">
				<a href="${pageContext.request.contextPath }/payment/">
					<button type="button" class="btn btn-secondary" onclick="">이전으로</button>
				</a> <button type="button" class="btn btn-danger" onclick="check()">낙찰포기</button>
			</div>
		</form>
	</div>
</body>
</body>
</html>