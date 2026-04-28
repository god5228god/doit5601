<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 정보 수정 - FigureAuction</title>
<style>
   
</style>
</head>
<body>

<div class="form-container">
    <h1>상품 수정</h1>
    <form action="product_edit_act.do" method="post" enctype="multipart/form-data">
        <input type="hidden" name="product_id" value="P001">

        <div class="form-group">
            <label>상품명</label>
            <input type="text" name="product_name" value="피규어 A (기존값)">
        </div>

        <div class="form-group">
            <label>제조사</label>
            <select name="manufacturer_id">
                <option value="1" selected>반다이</option> <option value="2">굿스마일</option>
            </select>
        </div>

        <div class="form-group">
            <label>상품 상태 등급</label>
            <div style="display: flex; gap: 15px;">
                <label><input type="radio" name="grade" value="S" checked> S급</label>
                <label><input type="radio" name="grade" value="A"> A급</label>
            </div>
        </div>

        <div class="form-group">
            <label>상세 설명</label>
            <textarea name="description" rows="6">기존에 작성했던 상품 설명 내용이 여기에 불러와집니다.</textarea>
        </div>

        <div class="form-group">
            <label>이미지 수정 (변경시에만 선택)</label>
            <div class="current-img-box">
                <div class="img-preview">기존 이미지</div>
                <div class="img-preview">기존 이미지2</div>
            </div>
            <input type="file" name="new_main_img">
            <p style="font-size: 12px; color: #e67e22;">* 새로운 파일을 선택하면 기존 이미지가 교체됩니다.</p>
        </div>

        <div class="btn-group">
            <button type="button" class="btn btn-cancel" onclick="history.back()">수정 취소</button>
            <button type="submit" class="btn btn-edit">수정사항 저장</button>
        </div>
    </form>
</div>

</body>
</html>