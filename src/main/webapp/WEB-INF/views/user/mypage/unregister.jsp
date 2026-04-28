<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/css/unregister.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
	crossorigin="anonymous">
	
</script>
<script type="text/javascript">
	function subm() {
		let first = document.getElementById("checkIndeterminate");
		let second = document.getElementById("checkmoneyIndeterminate");
		let pass = document.getElementById("inputPassword");

		if (!first.checked) {
			alert("회원 탈퇴 약관을 읽고 동의해주세요.");
			first.focus();
			return;
		}

		if (!second.checked) {
			alert("회원 탈퇴 환불 약관을 읽고 동의해주세요.");
			second.focus();
			return;
		}

		if (pass.value == "") {
			alert("본인 확인을위해 비밀번호를 입력해주세요.");
			pass.focus();
			return;
		}
		document.unregisterForm.submit();
	}
</script>
<style type="text/css">
body
{
	background-color:#f7f7f7;
}
.body
{
	margin: auto;
	font-size: 16px;
	color: black;
	font-family: "맑은 고딕";
	width: 700px;
	margin-top: 50px;
	border-radius: 8px;
	height: auto;
}
.body2
{
	margin: auto;
	width: 90%;
}

.big
{
	font-weight: bold;
	font-size: 24px;
}
.top
{
	margin-bottom: 30px;
	
}
.name
{
	font-weight: bold;
}
.term
{
	display: inline-block;
	font-weight: bold;
	font-size: 17px;
	margin-bottom: 5px;
}
.termcontent
{
	border: 3px solid #f7f7f7;
	border-radius: 7px;
	height: auto;
	padding: 20px;
}
.form-check
{
	margin-top: 25px;
	margin-bottom: 25px;
}
.moneycheck
{
	margin-top: 70px;
	margin-bottom: 50px;
}
.last
{
	font-size:15px;
	font-family: small;
}
.lm
{
	width: 100px;
	
}
.lsm
{
	display: inline-block;
	width: 100px;
}
.con
{
	display:inline-block;
	margin-bottom: 20px;
}
.moneylist
{
	width: 210px;
}
.ownercheck
{
	margin: 100px 0 50px 0;
}
.lastbtn
{
	margin: 100px 0 200px 0;
}
.last
{
	margin-bottom:5px;
}
#inputPassword
{
	width: 150px;
}
.btn-secondary
{
	height: 45px;
}
</style>
<title></title>
</head>
<body>
	<div class="row">
		<div class="col-md-9">
			<div class="body shadow-sm border-0 bg-white p-4">



				<div class="top">
					<h1 class="big">회원 탈퇴</h1>
					<div>
						<span class="name">안진모</span>님 회원 탈퇴시 계정 복구 및 재사용이 불가합니다.
					</div>
				</div>
				<div class="body2">
					<div>
						<span class="term">탈퇴 약관</span>
						<div class="termcontent">
							<span class="con">탈퇴시 회원정보 및 서비스 이용 약관 상품등록 경매기록 등은 보존됩니다</span> <br />
							<ul class="list-group list-group-flush">
								<li class="list-group-item">1.&nbsp;탈퇴시 회원정보는 한달 뒤
									삭제됩니다.</li>
								<li class="list-group-item">2.&nbsp;</li>
								<li class="list-group-item">3.&nbsp;</li>
							</ul>
						</div>

						<div class="form-check">
							<input class="form-check-input" type="checkbox" value=""
								id="checkIndeterminate"> <label class="form-check-label"
								for="checkIndeterminate"> 회원 탈퇴에 대한 약관을 확인 하였습니다 </label>
						</div>
					</div>



					<div class="moneycheck">
						<!-- <span>현재 소유 금액</span><br /> <span>예치금 : </span><br /> <span>머니
					: </span> -->
						<ul class="list-group moneylist">
							<li class="list-group-item">현재 소유 금액</li>
							<li class="list-group-item"><span class="lsm">예치금</span><span
								class="lm">10000</span>&nbsp;원</li>
							<li class="list-group-item"><span class="lsm">머니</span><span
								class="lm">10000</span>&nbsp;원</li>
						</ul>
					</div>

					<div>
						<span class="term">머니 환불 약관</span>
						<div class="termcontent">
							<span class="con">회원님의 충전된 금액은 환불이 불가합니다</span> <br />
							<ul class="list-group list-group-flush">
								<li class="list-group-item">1.&nbsp;</li>
								<li class="list-group-item">2.&nbsp;</li>
								<li class="list-group-item">3.&nbsp;</li>
							</ul>
						</div>

						<div class="form-check">
							<input class="form-check-input" type="checkbox" value=""
								id="checkmoneyIndeterminate"> <label
								class="form-check-label" for="checkmoneyIndeterminate">
								회원 탈퇴 시 환불 규정에 대한 약관을 확인 하였습니다 </label>
						</div>
					</div>
					<form action="" method="post" name="unregisterForm">
						<div class="ownercheck">
							<span style="color: red">*</span>&nbsp;<span>본인 확인을 위해 내용을
								입력해주세요</span><br /> <br />
							<div class="mb-3 row">
								<label for="staticName" class="col-sm-2 col-form-label">이름</label>
								<div class="col-sm-10">
									<input type="text" readonly class="form-control-plaintext"
										id="staticName" value="안진모">
								</div>
							</div>
							<div class="mb-3 row">
								<label for="staticId" class="col-sm-2 col-form-label">ID</label>
								<div class="col-sm-10">
									<input type="text" readonly class="form-control-plaintext"
										id="staticId" value="zx94**">
								</div>
							</div>

							<!-- 본인 확인 비밀번호 확인 -->

							<div class="mb-3 row">
								<label for="inputPassword" class="col-sm-2 col-form-label">PW</label>
								<div class="col-sm-10">
									<input type="password" class="form-control" id="inputPassword"
										required="required" placeholder="비밀번호 확인">
								</div>
							</div>
						</div>
						<div class="d-grid gap-2 col-6 mx-auto lastbtn">
							<span class="last">위 내용을 모두 확인하고 회원을 탈퇴 합니다.</span>
							<button class="btn btn-secondary" type="button" onclick="subm()">회원
								탈퇴</button>
							<button class="btn btn-secondary" type="button" onclick="back()">돌아 가기</button>
								
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

</body>
</html>