<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 등록</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/common.css" />
    <script src="https://code.jquery.com/jquery.min.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .page-title { font-weight: 800; color: #222; font-size: 1.6rem; }
        .section-title {
            font-size: 13px; font-weight: 700; color: #555;
            margin-bottom: 12px; padding-bottom: 8px;
            border-bottom: 2px solid #eee;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .form-card {
            background: #fff; border: 1px solid #e9ecef;
            border-radius: 12px; padding: 32px;
        }
        .img-upload-box {
            border: 2px dashed #dee2e6; border-radius: 10px;
            width: 100%; aspect-ratio: 1 / 1;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; overflow: hidden; transition: border-color 0.2s;
            background: #f8f9fa; position: relative;
        }
        .img-upload-box:hover { border-color: #adb5bd; }
        .img-upload-box .placeholder {
            display: flex; flex-direction: column;
            align-items: center; color: #adb5bd; pointer-events: none;
        }
        .img-upload-box img.preview-img {
            position: absolute; top: 0; left: 0;
            width: 100%; height: 100%;
            object-fit: cover; border-radius: 8px;
        }
        .img-label { font-size: 12px; font-weight: 600; color: #666; margin-bottom: 6px; }
        .required-badge { font-size: 10px; background:#dc3545; color:#fff; border-radius:4px; padding:1px 5px; margin-left:4px; }
        .form-label { font-size: 13px; color: #333; font-weight: 600; }
        .form-control, .form-select { font-size: 14px; border-radius: 8px; }
        .form-control:focus, .form-select:focus { box-shadow: none; border-color: #adb5bd; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${not empty errorMsg}">
    <div class="container mt-3">
        <div class="alert alert-danger">${errorMsg}</div>
    </div>
</c:if>

<div class="container py-5" style="max-width: 860px;">

    <div class="mb-4">
        <h2 class="page-title">상품 등록</h2>
        <p class="text-muted small mb-0">나의 피규어 컬렉션을 등록해보세요.</p>
    </div>

    <div class="form-card">
        <form action="${ctx}/product/register" method="post" enctype="multipart/form-data" id="registerForm">

            <%-- 사진 섹션 --%>
            <p class="section-title">컬렉션 사진</p>
            <span class="text-danger fw-bold">*사진은 최소 3장이 필요합니다(최대 10장)</span>

            <%-- 1~5행 --%>
            <div class="row g-2 mb-2">
                <div class="col">
                    <p class="img-label">사진 1 <span class="text-danger">*</span></p>
                    <div class="img-upload-box" onclick="document.getElementById('img1').click()">
                        <div class="placeholder" id="placeholder1"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">메인</span></div>
                        <img class="preview-img d-none" id="previewImg1" alt="">
                    </div>
                    <input type="file" id="img1" name="productImage1" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg1','placeholder1')">
                </div>
                <div class="col">
                    <p class="img-label">사진 2 <span class="text-danger">*</span></p>
                    <div class="img-upload-box" onclick="document.getElementById('img2').click()">
                        <div class="placeholder" id="placeholder2"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg2" alt="">
                    </div>
                    <input type="file" id="img2" name="productImage2" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg2','placeholder2')">
                </div>
                <div class="col">
                    <p class="img-label">사진 3 <span class="text-danger">*</span></p>
                    <div class="img-upload-box" onclick="document.getElementById('img3').click()">
                        <div class="placeholder" id="placeholder3"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg3" alt="">
                    </div>
                    <input type="file" id="img3" name="productImage3" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg3','placeholder3')">
                </div>
                <div class="col">
                    <p class="img-label">사진 4</p>
                    <div class="img-upload-box" onclick="document.getElementById('img4').click()">
                        <div class="placeholder" id="placeholder4"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg4" alt="">
                    </div>
                    <input type="file" id="img4" name="productImage4" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg4','placeholder4')">
                </div>
                <div class="col">
                    <p class="img-label">사진 5</p>
                    <div class="img-upload-box" onclick="document.getElementById('img5').click()">
                        <div class="placeholder" id="placeholder5"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg5" alt="">
                    </div>
                    <input type="file" id="img5" name="productImage5" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg5','placeholder5')">
                </div>
            </div>

            <%-- 6~10행 --%>
            <div class="row g-2 mb-4">
                <div class="col">
                    <p class="img-label">사진 6</p>
                    <div class="img-upload-box" onclick="document.getElementById('img6').click()">
                        <div class="placeholder" id="placeholder6"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg6" alt="">
                    </div>
                    <input type="file" id="img6" name="productImage6" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg6','placeholder6')">
                </div>
                <div class="col">
                    <p class="img-label">사진 7</p>
                    <div class="img-upload-box" onclick="document.getElementById('img7').click()">
                        <div class="placeholder" id="placeholder7"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg7" alt="">
                    </div>
                    <input type="file" id="img7" name="productImage7" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg7','placeholder7')">
                </div>
                <div class="col">
                    <p class="img-label">사진 8</p>
                    <div class="img-upload-box" onclick="document.getElementById('img8').click()">
                        <div class="placeholder" id="placeholder8"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg8" alt="">
                    </div>
                    <input type="file" id="img8" name="productImage8" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg8','placeholder8')">
                </div>
                <div class="col">
                    <p class="img-label">사진 9</p>
                    <div class="img-upload-box" onclick="document.getElementById('img9').click()">
                        <div class="placeholder" id="placeholder9"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg9" alt="">
                    </div>
                    <input type="file" id="img9" name="productImage9" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg9','placeholder9')">
                </div>
                <div class="col">
                    <p class="img-label">사진 10</p>
                    <div class="img-upload-box" onclick="document.getElementById('img10').click()">
                        <div class="placeholder" id="placeholder10"><i class="bi bi-camera fs-3"></i><span style="font-size:10px;margin-top:4px;">추가</span></div>
                        <img class="preview-img d-none" id="previewImg10" alt="">
                    </div>
                    <input type="file" id="img10" name="productImage10" accept="image/*" class="d-none" onchange="showPreview(this,'previewImg10','placeholder10')">
                </div>
            </div>

            <%-- 피규어 정보 --%>
            <p class="section-title">피규어 정보</p>
            <div class="row g-3 mb-4">
                <div class="col-12">
                    <label class="form-label">상품 발매명 <span class="text-danger">*</span></label>
                    <input type="text" name="productName" class="form-control" placeholder="예: 하츠네 미쿠 15주년 한정판" required>
                </div>
                <div class="col-12">
                    <label class="form-label">상품 별칭 <span class="fw-normal text-muted">(나만의 이름)</span></label>
                    <input type="text" name="productAlias" class="form-control" placeholder="예: 미쿠 15주년 버전">
                </div>
                <div class="col-md-6">
                    <label class="form-label">제조사 <span class="text-danger">*</span></label>
                    <select name="makerId" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="m" items="${makerList}">
                            <option value="${m.manufacturerId}">${m.manufacturerName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">상품 등급 <span class="text-danger">*</span></label>
                    <select name="gradeCode" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="g" items="${gradeList}">
                            <option value="${g.productGradeId}">${g.productGradeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">장르 <span class="text-danger">*</span></label>
                    <select name="genreCode" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="g" items="${genreList}">
                            <option value="${g.productGenreId}">${g.productGenreName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">사이즈/스케일 <span class="text-danger">*</span></label>
                    <select name="sizeCode" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="s" items="${sizeList}">
                            <option value="${s.productSizeId}">${s.productSizeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">작품명</label>
                    <input type="text" name="workName" class="form-control" placeholder="애니메이션/게임 제목">
                </div>
                <div class="col-md-6">
                    <label class="form-label">캐릭터명</label>
                    <input type="text" name="characterName" class="form-control" placeholder="캐릭터 이름">
                </div>
            </div>

            <%-- 컬렉션 노트 --%>
            <p class="section-title">컬렉션 노트</p>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label">구매 연도</label>
                    <select name="purchaseDate" class="form-select">
                        <option value="">선택하세요</option>
                        <c:set var="nowYear"><%= java.time.Year.now().getValue() %></c:set>
                        <c:forEach var="y" begin="0" end="10">
                            <c:set var="year" value="${nowYear - y}" />
                            <option value="${year}">${year}년</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">개봉 여부 <span class="text-danger">*</span></label>
                    <select name="openedCode" class="form-select" required>
                        <option value="">선택</option>
                        <option value="1">미개봉</option>
                        <option value="0">개봉</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">파츠 누락 <span class="text-danger">*</span></label>
                    <select name="missingCode" class="form-select" required>
                        <option value="">선택</option>
                        <option value="0">없음</option>
                        <option value="1">있음</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">공개 여부 <span class="text-danger">*</span></label>
                    <select name="publicCode" class="form-select" required>
                        <option value="1">공개</option>
                        <option value="0">비공개</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label">상세 설명</label>
                    <textarea name="description" class="form-control" rows="4" placeholder="피규어를 소개합니다."></textarea>
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="button" class="btn w-50 py-2 fw-bold"
                    style="background-color:#f1f1f1;color:#333;border:1px solid #ddd;border-radius:8px;"
                    onclick="history.back()">돌아가기</button>
                <button type="submit" class="btn w-50 py-2 fw-bold text-white"
                    style="background-color:#212529;border-radius:8px;">등록하기</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
function showPreview(input, previewId, placeholderId) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var previewImg = document.getElementById(previewId);
            var placeholder = document.getElementById(placeholderId);
            previewImg.src = e.target.result;
            previewImg.classList.remove('d-none');
            if (placeholder) placeholder.classList.add('d-none');
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// 제출 전 최소 3장 체크
document.getElementById('registerForm').addEventListener('submit', function(e) {
    var count = 0;
    for (var i = 1; i <= 10; i++) {
        var file = document.getElementById('img' + i);
        if (file && file.files.length > 0) count++;
    }
    if (count < 3) {
        e.preventDefault();
        alert('사진을 최소 3장 이상 등록해주세요.');
    }
});
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
