<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 경매 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .wf-input {
            background-color: #e9ecef;
            border: none;
            padding: 10px;
        }
        .wf-label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
        }
        .btn-wf {
            background-color: #e9ecef;
            border: 1px solid #ced4da;
            padding: 10px 30px;
            font-weight: bold;
        }
    </style>
    <script type="text/javascript">
    	function checkUserInput() {
            let title = document.getElementById("AUCTION_TITLE");
            let auctionPrice = document.getElementById("AUCTION_PRICE");
            let period = document.getElementById("AUCTION_PERIOD"); // 추가됨
            
            if(title.value == "") {
                alert("제목을 입력하세요.");
                return false;
            }
            
            if(auctionPrice.value == "") {
                alert("시작가를 입력해주세요.");
                return false;
            } else if(auctionPrice.value % 1000 != 0) {
                alert("1000원 단위로 입력해주세요.");
                return false;
            }

            if(period.value == "") { // 추가됨
                alert("경매 기간을 선택해주세요.");
                return false;
            }
            
            return true;
        }
    </script>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="container mt-5">
    <div class="row mb-5">
        <div class="col-12">
            <h1 class="fw-bold">상품 경매 등록</h1>
        </div>
    </div>

    <div class="d-flex align-items-start" style="gap: 50px;">
        
        <div style="flex: 0 0 450px;"> 
            <div class="ratio ratio-1x1 bg-light border d-flex align-items-center justify-content-center">
                <span class="text-muted fw-bold">상품 대표 이미지</span>
            </div>
        </div>

      <div class="flex-grow-1">
    	<form action="${pageContext.request.contextPath}/user/mypage/auction" method="post">
        	<input type="hidden" name="productId" value="${productId}">
        
        <div class="mb-4">
            <label class="wf-label">경매 제목</label>
            <input type="text" name="AUCTION_TITLE" id="AUCTION_TITLE" class="form-control wf-input" placeholder="경매 제목을 입력하세요.">
        </div>

                <div class="row mb-4">
                    <div class="col-md-7">
                        <label class="wf-label">경매 시작가</label>
                        <div class="d-flex align-items-center" style="gap: 10px;">
                            <input type="number" name="START_PRICE" id="AUCTION_PRICE" class="form-control wf-input" placeholder="0" min="0" step="1000">
                            <span class="fw-bold" style="font-size: 1.1rem; min-width: 20px;">원</span>
                        </div>
                    </div>
                    
                    <div class="col-md-5">
                        <label class="wf-label">경매 기간</label>
                        <select name="PERIOD_CODE" id="AUCTION_PERIOD" class="form-select wf-input">
                            <option value="">기간 선택</option>
                            <option value="1">1일</option>
                            <option value="2">2일</option>
                            <option value="3">3일</option>
                            <option value="4">4일</option>
                            <option value="5">5일</option>
                            <option value="6">6일</option>
                            <option value="7">7일</option>
                        </select>
                    </div>
                </div>

                <div class="mb-5">
                    <label class="wf-label">경매 소개 글</label>
                    <textarea name="AUCTION_INFO" class="form-control wf-input" rows="8" placeholder="상태 설명 및 주의사항을 입력하세요."></textarea>
                </div>

                <div class="d-flex justify-content-center" style="gap: 50px;">
                    <button type="submit" class="btn btn-wf px-5" onclick="return checkUserInput()">등록</button>
                    <button type="button" class="btn btn-wf px-5" onclick="history.back()">취소</button>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>