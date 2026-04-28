<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

    <div class="modal-box">
        <div class="icon-circle">!</div>
        
        <h1>상품 삭제 ~~</h1>
        
        <div class="alert-text">
            삭제된 상품 정보는 복구가 불가능합니다.<br>
            현재 경매 진행 중인 상품인 경우,<br>
            취소 시 보증금 몰수 등의 패널티가 발생할 수 있습니다.
        </div>

        <div class="product-info-box">
            <div class="thumb"></div> <div class="content">
                <span class="name">피규어 A (P001)</span>
                <span class="date">등록일: 2023-10-01</span>
            </div>
        </div>

        <form action="delete_act.do" method="post">
            <input type="hidden" name="product_id" value="P001">
            <div class="btn-group">
                <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-delete">삭제하기</button>
            </div>
        </form>
    </div>
    </body>
</html>