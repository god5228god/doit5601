<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 상품 등록 - FigureAuction</title>

<style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f8f9fa; padding: 50px; }
    .form-container { 
        max-width: 600px; margin: 0 auto; background: #fff; 
        padding: 40px; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); 
    }
    h1 { font-size: 24px; color: ; margin-bottom: 30px; text-align: center; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
    
    .form-group { margin-bottom: 20px; }
    label { display: block; font-weight: bold; margin-bottom: 8px; color: #555; }
    
    input[type="text"], select, textarea { 
        width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; 
    }
    .radio-group { display: flex; gap: 15px; padding: 10px 0; }
    
    
    .file-box { background: #fafafa; border: 1px dashed #ccc; padding: 15px; border-radius: 6px; }
    
    .btn-group { display: flex; gap: 10px; margin-top: 30px; }
    .btn { flex: 1; padding: 15px; border-radius: 6px; font-weight: bold; border: none; cursor: pointer; font-size: 16px; }
    .btn-submit { background-color: #3498db; color: white; }
    .btn-reset { background-color: #e0e0e0; color: #666; }
</style>

</head>
<body>

<div class="form-container">
    <h1> 새 상품 등록</h1>
    <form action="product_register_act.do" method="post" enctype="multipart/form-data">
        
        <div class="form-group">
            <label>상품명</label>
            <input type="text" name="product_name" placeholder="피규어 이름을 정확히 입력해주세요">
        </div>

        <div class="form-group">
            <label>제조사</label>
            <select name="manufacturer_id">
                <option value="">선택하세요</option>
                <option value="1">반다이</option>
                <option value="2">굿스마일</option>
            </select>
        </div>

        <div class="form-group">
            <label>상품 상태 등급</label>
            <div class="radio-group">
                <label style="font-weight:normal;"><input type="radio" name="grade" value="S">미개봉</label>
                <label style="font-weight:normal;"><input type="radio" name="grade" value="A"> 단순개봉</label>
                <label style="font-weight:normal;"><input type="radio" name="grade" value="B"> 중고??</label>
            </div>
        </div>

        <div class="form-group">
            <label>상세 설명</label>
            <textarea name="description" rows="6" placeholder="파츠 누락 여부나 박스 상태를 적어주세요"></textarea>
        </div>

        <div class="form-group">
            <label>대표 이미지 (메인)</label>
            <div class="file-box">
                <input type="file" name="main_img">
            </div>
        </div>

        <div class="form-group">
            <label>추가 이미지 (최대 5장)</label>
            <div class="file-box">
                <input type="file" name="sub_imgs" multiple>
            </div>
        </div>

        <div class="btn-group">
            <button type="button" class="btn btn-reset" onclick="history.back()">취소</button>
            <button type="submit" class="btn btn-submit">등록 완료</button>
        </div>
    </form>
</div>

</body>
</html>