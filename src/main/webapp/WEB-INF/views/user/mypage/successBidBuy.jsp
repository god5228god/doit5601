<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/css/buyauction.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style type="text/css">


body
{
	margin-top:50px;
	
}
h1,h2
{
	font-size: 20px;
	font-weight: bold;
}
.body
{
	margin:auto;
	width:80%;
}
.body div
{
	display: inline-block;
}

.box
{
	width:80%;
	margin:auto;
	position: relative;

}
.itemimg
{
	vertical-align: middle;
	display: inline-block;
	width: 350px;
	height: 350px;
	background-color:white;
	margin: 0 20px 0 0; 
}
.itemimg img
{
	width: 350px;
	height: 350px;
	object-fit: cover;
	object-position: center;
	border-radius: 7px;
}
hr
{
	margin-bottom: 30px;
}
.item
{
	padding: 20px 30px 30px 30px;
	border: 1px solid silver;
	border-radius: 7px;
	width: 700px;
	height: 500px;	
	display: block;
	margin-bottom: 20px;
	box-shadow: 0 0 3px rgba(0,0,0,0.4);
}
.cash
{
	padding: 20px 30px 30px 30px;
	border: 1px solid silver;
	border-radius: 7px;
	position:fixed;
	transform:translate(30px,0px);
	box-shadow: 0 0 3px rgba(0,0,0,0.4);
	width: 300px;
	height: 540px;	
}
.btn-outline-secondary, .btn-outline-danger
{
	width: 100%;
	margin-bottom: 10px;
}
{
	width: 100%;
	margin-bottom: 10px;
}

.btn-outline-secondary:first-child
{
	margin-top:30px;
}
.cash span
{
	display: block;
}
.itemtext
{
	vertical-align: middle;
	
	width: 250px;
	display: inline-block;
}
.box2
{
	width:80%;
	height: 1000px;
}
.passive
{
	padding: 20px 30px 30px 30px;
	border: 1px solid silver;
	border-radius: 7px;
	width: 700px;
	height: 200px;
	margin-bottom: 20px;
	box-shadow: 0 0 3px rgba(0,0,0,0.4);
}
.passive div
{
	display:inline-block;
}
.pass
{
	width: 400px;
	margin-left: 70px;
	
}
.mb-3
{
	vertical-align: top;
	
}

.mb-3 input
{
	margin-bottom: 5px;
}
.pass input
{
	text-align: center !important;
}
.pa
{
	width: 160px;
}
.adress
{
	padding: 20px 30px 30px 30px;
	border: 1px solid silver;
	border-radius: 7px;
	width: 700px;
	height: 320px;
	margin-bottom: 20px;
	box-shadow: 0 0 3px rgba(0,0,0,0.4);
}
.mb-2
{
	margin: 15px 0 10px 0;
	width: 100%;
}
.s
{
	width: 90px !important;
}
.ss
{
	width: 70px !important;
}
.adress div
{
	display: block;
}
.adressconfirm
{
	padding: 20px 30px 30px 30px;
	border: 1px solid silver;
	border-radius: 7px;
	width: 700px;
	height: 230px;
	margin-bottom: 20px;
	box-shadow: 0 0 3px rgba(0,0,0,0.4);
}
/* .cashtot
{
	padding: 20px 30px 30px 30px;
	border: 1px solid silver;
	border-radius: 7px;
	width: 200px;
	height: 300px;
} */
.title
{
	font-size: 20px;
	font-weight: bold;
}
.tt
{
	display:inline-block;
	width: 100px;
	font-weight: bold;
}
.tts
{
	display:inline-block;
	width: 120px;
	font-weight: bold;
}
.condition
{
	color: gray;
	margin-top:10px;
	font-family: small;
	font-weight: bold;
}
.nh
{
	margin-bottom: 10px;
}
.bt
{
	width: 100%;
}
.btn-light
{
	position: absolute;
	margin-left: 45px;
	font-family: small;
}
.errMsg
{
	display: none;
}
</style>
</head>
<script type="text/javascript">
window.onload = function() {
    const hiddenInput = document.getElementById('winnerDate');
    if (!hiddenInput || !hiddenInput.value) {
        console.error("날짜 데이터를 찾을 수 없습니다!");
        return;
    }

    const endDateStr = hiddenInput.value; // 예: "2024-11-13 00:00"
    
    // 1. 날짜 문자열을 숫자로 쪼갭니다 (하이픈, 공백, 콜론을 기준으로 분리)
    // 결과: parts = ["2024", "11", "13", "00", "00"]
    const parts = endDateStr.split(/[- :]/);
    
    // 2. Date 객체 생성 (Month는 0부터 시작하므로 -1)
    // Date(년, 월-1, 일, 시, 분)
    const endDate = new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4]);
    
    // 3. 하루 더하기
    endDate.setDate(endDate.getDate() + 1);
    
    // 4. 화면 출력 (패딩 처리)
    const year = endDate.getFullYear();
    const month = String(endDate.getMonth() + 1).padStart(2, '0');
    const day = String(endDate.getDate()).padStart(2, '0');
    const hours = String(endDate.getHours()).padStart(2, '0');
    const minutes = String(endDate.getMinutes()).padStart(2, '0');
    const seconds = String(endDate.getSeconds()).padStart(2, '0');

    document.getElementById('endDate').innerText = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;

    // 2. 실시간 카운트다운 (낙찰 종료 시간 기준)
    const targetDate = endDate.getTime(); 

    const timer = setInterval(function() {
        const now = new Date().getTime();
        const diff = targetDate - now;

        if (diff <= 0) {
            clearInterval(timer);
            document.getElementById('endTime').innerText = "마감됨";
            return;
        }

        const h = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        const s = Math.floor((diff % (1000 * 60)) / 1000);

        document.getElementById('endTime').innerText = 
            String(h).padStart(2, '0') + ":" + 
            String(m).padStart(2, '0') + ":" + 
            String(s).padStart(2, '0');
    }, 1000);
	};

	function check(obj)
	{
		let sel = obj.value;
		let other = document.querySelector("#other");
		
		
		if(sel == 5)
		{
			other.disabled = false;
			other.focus();
		}else
		{
			other.disabled = true;
		}
	}
	
	function cash()
	{
		let addrcode = document.querySelector("#zipcode");
		let addr1 = document.querySelector("#addr1");
		let addr2 = document.querySelector("#addr2");
		
		let postDetail = document.querySelector("#postDetail");
		
		let other = document.querySelector("#other");
		
		let userName = document.querySelector("#userName");
		
		let phone1 = document.querySelector("#userPhone1");
		let phone2 = document.querySelector("#userPhone2");
		let phone3 = document.querySelector("#userPhone3");
		
		let adressErr = document.querySelector("#adressErr");
		let postDetailErr = document.querySelector("#postDetailErr");
		let phoneErr = document.querySelector("#phoneErr");
		let userErr = document.querySelector("#nameErr");
		
		adressErr.classList.add("errMsg");
		postDetailErr.classList.add("errMsg");
		userErr.classList.add("errMsg");
		phoneErr.classList.add("errMsg");
		
		let bol = false;
		
		if(!userName.value)
		{
			userErr.classList.remove("errMsg");
			userName.focus();
			bol = true;
		}
		
		if(!phone1.value)
		{
			phoneErr.classList.remove("errMsg");
			phone1.focus();
			bol = true;
		}
		
		if(!phone2.value )
		{
			phoneErr.classList.remove("errMsg");
			phone2.focus();
			bol = true;
		}
		
		if(!phone3.value)
		{
			phoneErr.classList.remove("errMsg");
			phone3.focus();
			bol = true;
		}
		
		if(!addrcode.value || !addr1.value || !addr2.value)
		{
			
			adressErr.classList.remove("errMsg");
			addr2.focus();
			bol = true;
		}
		
		if(postDetail.value == "배송 상세" || (postDetail.value == 5 && other.value.trim() == ""))
		{
			
			postDetailErr.classList.remove("errMsg");
			postDetail.focus();
			bol = true;
		}
		let currentPrice = ${money-detail.currentPrice};
		let myMoney = ${money};
		
		if(myMoney - currentPrice < 0)
		{
			alert("보유금액이 부족합니다 \n충전 후 결제해주세요");
		}
		
		if(bol)
		{
			return;
		}
		
		document.formRight.action ="${pageContext.request.contextPath}/payment/success"
		document.formRight.submit();
		
		
	}
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 팝업에서 검색결과 항목을 클릭했을 때 실행할 코드를 작성하는 부분입니다.

	            // 도로명 주소 변수
	            let fullAddr = ''; 
	            // 참고항목 변수
	            let extraAddr = ''; 

	            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 도로명 주소
	                fullAddr = data.roadAddress;
	            } else { // 지번 주소
	                fullAddr = data.jibunAddress;
	            }

	            // 제이쿼리를 사용하여 HTML 필드에 값 할당
	            document.querySelector("#zipcode").value = data.zonecode; // 우편번호
	            document.querySelector("#addr1").value = fullAddr;       // 기본주소
	            
	            // 상세주소 필드로 포커스 이동
	            document.querySelector("#addr2").focus();
	        }
	    }).open({
	        left: (window.screen.width / 2) - (500 / 2),
	        top: (window.screen.height / 2) - (600 / 2),
	        popupName: 'postcodePopup'
	    });
	}
	
	function back()
	{
		window.location.href="${pageContext.request.contextPath }/user/products";
	}
	
	function fail()
	{
		window.location.href="${pageContext.request.contextPath }/payment/takefail"
	}
</script>
<body>
	<form action="" name="formRight" method="post">
		<input type="hidden" name="title" value="${detail.auctionTitle }">
		<input type="hidden" name="grade" value="${detail.gradeName }">
		<input type="hidden" name="manudacturer" value="${detail.manudacturerName}">
		<input type="hidden" name="price" value="${detail.currentPrice}">
		<input type="hidden" name="img" value="${detail.img }">
		<input type="hidden" name="bid" value="${detail.bidResult }">
		<input type="hidden" name="user" value="${detail.userId }">
	</form>
	<div class="body">
		<div class="box">
			<div class="item">
				<h1>낙찰 구매 상품</h1>
				<hr />
				<div class="itemimg">
					<img src="<%-- ${detail.img } --%>https://image2.1004gundam.com/item_images/goods/380/1376406523.JPG" alt="제품이미지" />
				</div>
				<div class="itemtext">
					<span class="title"> ${detail.auctionTitle } </span> <br /> <span class="condition">
						상태: ${detail.gradeName } / 제조사: ${detail.manudacturerName} </span><br /> <br /> <span class="date"> <span
						class="tt">낙찰일</span> <span class="condition">${detail.auctionEndDate }</span> <br /> <span class="tt" >결제마감일</span>
						<span id="endDate condition"></span> <br /> <span class="tt" >남은시간</span> <span id="endTime condition"></span><br />
					</span> <span class="countmoney"> <span class="tt">입찰가</span>
						<span class="condition">${detail.maxPrice } 원</span><br /> <span class="tt">낙찰가</span> <span class="condition">${detail.currentPrice } 원</span><br />
					</span>
					<input type="hidden" id="winnerDate" value="${detail.auctionEndDate}">
				</div>
			</div>
			
			<div class="cash">
				<h2>최종 결제 금액</h2>
				<hr class="nh" />
				<span class="tt">낙찰 가격</span><span>${detail.currentPrice } 원</span> <span class="tt">배송
					비용</span><span>무료</span>
				<hr class="nh" />
				<span class="tts" style="display: inline-block;">현재 보유 머니</span> <a
					href="${pageContext.request.contextPath }/payment/"><button type="button" class="btn btn-light">충전</button></a>
				<span> ${money } 원</span> <span><span class="tt">결제 후 잔액</span>
					${money-detail.currentPrice} 원</span>

				<hr class="nh" />
				<span class="tts">최종 결제 금액</span><span>${detail.currentPrice } 원</span>
				<div class="bt">
					<button type="button" class="btn btn-outline-secondary" onclick="cash()">결제
						하기</button>
					<button type="button" class="btn btn-outline-secondary" onclick="back()">돌아
						가기</button>
					<button type="button" class="btn btn-outline-danger" onclick="fail()">낙찰 
						포기</button>
				</div>
			</div>
		</div>
		<div class="box2">
			<div class="passive">
				<h2>수령인 정보</h2>
				<hr />
				<div >
				<div class="mb-3 pa">
					<label for="userName" class="form-label ms-1">이름 <span class="text-danger">*</span></label> 
					<input type="text" class="form-control w-50 required s" id="userName" name="userName" value="${detail.userName }">
					<span class="text-danger ms-1 errMsg" id="nameErr">이름을 입력해주세요.</span>
				</div>
				<div class="mb-3 pass">
					<label class="form-label ms-1">전화번호 <span class="text-danger">*</span></label>
					<div class="d-flex">
						<input type="text" class="form-control me-1 w-25 required ss" id="userPhone1" maxlength="3" name="userPhone1" value="${fn:substring(detail.phone,0,3) }">
						<span class="mt-2 ms-2 me-2"> - </span>
						<input type="text" class="form-control ms-1 w-25 required sss" id="userPhone2" maxlength="4" name="userPhone2" value="${fn:substring(detail.phone,3,7) }">
						<span class="mt-2 ms-2 me-2"> - </span>
						<input type="text" class="form-control ms-1 w-25 required sss" id="userPhone3" maxlength="4" name="userPhone3" value="${fn:substring(detail.phone,7,11) }">					
					</div>					
				<span class="text-danger ms-1 errMsg" id="phoneErr">전화번호를 입력해주세요.</span>
				</div>
				</div>
			</div>
			<div class="adress">
				<h2>배송지</h2>
				<hr />
				<div class="mb-5">
					<label class="form-label ms-1">주소 <span class="text-danger">*</span></label>
					<div class="d-flex justify-content-start mb-2">
						<input type="text" placeholder="우편번호" disabled="disabled"
							class="form-control w-50 me-2" id="zipcode" value="${detail.zipcode }">
						<button type="button" class="btn btn-outline-dark ms-2" id="addrcode" onclick="execDaumPostcode()">주소검색</button>
					</div>
					<div class="mb-2">
						<input type="text" class="form-control" placeholder="기본주소"
							disabled="disabled" id="addr1" value="${detail.address }"/>
					</div>
					<div class="mb-2">
						<input type="text" class="form-control" placeholder="상세주소"
							id="addr2" value="${detail.addressDetail }"/>
					</div>
					<span class="text-danger ms-1 errMsg" id="adressErr">주소를 입력해주세요.</span>
				</div>
			</div>

			<div class="adressconfirm">
				<h2>배송 요청사항</h2>
				<hr />
				<select class="form-select" aria-label="Default select example" id="postDetail" onchange="check(this)">
					<option selected>배송 상세</option>
					<option value="1">문앞</option>
					<option value="2">직접수령</option>
					<option value="3">경비실</option>
					<option value="4">택배함</option>
					<option value="5">기타</option>
				</select>
				<div class="mb-2">
					<input type="text" class="form-control" placeholder="직접 입력하기"
						id="other" disabled="disabled" />
				</div>
				<span class="text-danger ms-1 errMsg" id="postDetailErr">배송상세를 입력해주세요.</span>
			</div>
		</div>
	</div>

</body>
</html>