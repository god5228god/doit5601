<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 수정</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/common.css" />
    <script src="https://code.jquery.com/jquery.min.js"></script>
    <style>
        body { background-color: #f8f9fa; }

        .page-title {
            font-weight: 800;
            color: #222;
            font-size: 1.6rem;
        }

        .section-title {
            font-size: 13px;
            font-weight: 700;
            color: #555;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 2px solid #eee;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-card {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 32px;
        }

        /* 이미지 업로드 박스 */
        .img-upload-box {
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            width: 100%;
            aspect-ratio: 1 / 1;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            overflow: hidden;
            transition: border-color 0.2s;
            background: #f8f9fa;
            position: relative;
        }

        .img-upload-box:hover { border-color: #adb5bd; }

        .img-upload-box .placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #adb5bd;
            pointer-events: none;
        }

        .img-upload-box img.preview-img {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }

        .img-label {
            font-size: 12px;
            font-weight: 600;
            color: #666;
            margin-bottom: 6px;
        }

        .form-label { font-size: 13px; color: #333; font-weight: 600; }
        .form-control, .form-select { font-size: 14px; border-radius: 8px; }
        .form-control:focus, .form-select:focus { box-shadow: none; border-color: #adb5bd; }

        .btn-submit {
            background-color: #212529;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 15px;
        }
        .btn-submit:hover { background-color: #444; color: #fff; }

        .btn-cancel {
            background-color: #f1f1f1;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
        }
        .btn-cancel:hover { background-color: #e2e2e2; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${not empty errorMsg}">
    <div class="container mt-3">
        <div class="alert alert-danger">${errorMsg}</div>
    </div>
</c:if>

<div class="container py-5" style="max-width: 760px;">

    <div class="mb-4">
        <h2 class="page-title">상품 수정</h2>
        <p class="text-muted small mb-0">변경할 내용을 입력해주세요.</p>
    </div>

    <div class="form-card">
        <form action="${ctx}/product/update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="productId" value="${product.productId}">

            <%-- 사진 섹션 --%>
            <p class="section-title">컬렉션 사진</p>
            <div class="row g-3 mb-4">
                <div class="col-4">
                    <p class="img-label">사진 1 <span class="text-danger">*</span></p>
                    <div class="img-upload-box" onclick="document.getElementById('img1').click()">
                        <c:choose>
                            <c:when test="${not empty product.imagePath1}">
                                <img class="preview-img" id="previewImg1" src="${ctx}/${product.imagePath1}" alt="">
                            </c:when>
                            <c:otherwise>
                                <div class="placeholder" id="placeholder1">
                                    <i class="bi bi-camera fs-2"></i>
                                    <span style="font-size:11px; margin-top:4px;">메인 사진</span>
                                </div>
                                <img class="preview-img d-none" id="previewImg1" alt="">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <input type="file" id="img1" name="productImage1" accept="image/*" class="d-none"
                           onchange="showPreview(this, 'previewImg1', 'placeholder1')">
                    <input type="hidden" name="existingImage1" value="${product.imagePath1}">
                </div>
                <div class="col-4">
                    <p class="img-label">사진 2</p>
                    <div class="img-upload-box" onclick="document.getElementById('img2').click()">
                        <c:choose>
                            <c:when test="${not empty product.imagePath2}">
                                <img class="preview-img" id="previewImg2" src="${ctx}/${product.imagePath2}" alt="">
                            </c:when>
                            <c:otherwise>
                                <div class="placeholder" id="placeholder2">
                                    <i class="bi bi-camera fs-2"></i>
                                    <span style="font-size:11px; margin-top:4px;">추가 사진</span>
                                </div>
                                <img class="preview-img d-none" id="previewImg2" alt="">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <input type="file" id="img2" name="productImage2" accept="image/*" class="d-none"
                           onchange="showPreview(this, 'previewImg2', 'placeholder2')">
                    <input type="hidden" name="existingImage2" value="${product.imagePath2}">
                </div>
                <div class="col-4">
                    <p class="img-label">사진 3</p>
                    <div class="img-upload-box" onclick="document.getElementById('img3').click()">
                        <c:choose>
                            <c:when test="${not empty product.imagePath3}">
                                <img class="preview-img" id="previewImg3" src="${ctx}/${product.imagePath3}" alt="">
                            </c:when>
                            <c:otherwise>
                                <div class="placeholder" id="placeholder3">
                                    <i class="bi bi-camera fs-2"></i>
                                    <span style="font-size:11px; margin-top:4px;">추가 사진</span>
                                </div>
                                <img class="preview-img d-none" id="previewImg3" alt="">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <input type="file" id="img3" name="productImage3" accept="image/*" class="d-none"
                           onchange="showPreview(this, 'previewImg3', 'placeholder3')">
                    <input type="hidden" name="existingImage3" value="${product.imagePath3}">
                </div>
            </div>

            <%-- 피규어 정보 --%>
            <p class="section-title">피규어 정보</p>
            <div class="row g-3 mb-4">
                <div class="col-12">
                    <label class="form-label">상품 발매명 <span class="text-danger">*</span></label>
                    <input type="text" name="productName" class="form-control" value="${product.productReleaseName}" required>
                </div>
                <div class="col-12">
                    <label class="form-label">상품 별칭 <span class="fw-normal text-muted">(나만의 이름)</span></label>
                    <input type="text" name="productAlias" class="form-control" value="${product.productAlias}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">제조사 <span class="text-danger">*</span></label>
                    <select name="makerId" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="m" items="${makerList}">
                            <option value="${m.manufacturerId}" <c:if test="${product.manufacturerId eq m.manufacturerId}">selected</c:if>>${m.manufacturerName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">상품 등급 <span class="text-danger">*</span></label>
                    <select name="gradeCode" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="g" items="${gradeList}">
                            <option value="${g.productGradeId}" <c:if test="${product.productGradeId eq g.productGradeId}">selected</c:if>>${g.productGradeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">장르 <span class="text-danger">*</span></label>
                    <select name="genreCode" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="g" items="${genreList}">
                            <option value="${g.productGenreId}" <c:if test="${product.productGenreId eq g.productGenreId}">selected</c:if>>${g.productGenreName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">사이즈/스케일 <span class="text-danger">*</span></label>
                    <select name="sizeCode" class="form-select" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="s" items="${sizeList}">
                            <option value="${s.productSizeId}" <c:if test="${product.productSizeId eq s.productSizeId}">selected</c:if>>${s.productSizeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">작품명</label>
                    <input type="text" name="workName" class="form-control" value="${product.workName}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">캐릭터명</label>
                    <input type="text" name="characterName" class="form-control" value="${product.characterName}">
                </div>
            </div>

            <%-- 컬렉션 노트 --%>
            <p class="section-title">컬렉션 노트</p>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label">구매 연도</label>
                    <c:set var="currentYear" value="${product.purchaseDateTime != null ? product.purchaseDateTime.substring(0, 4) : ''}" />
                    <select name="purchaseDate" class="form-select">
                        <option value="">선택하세요</option>
                        <c:set var="nowYear"><%= java.time.Year.now().getValue() %></c:set>
                        <c:forEach var="y" begin="0" end="10">
                            <c:set var="year" value="${nowYear - y}" />
                            <option value="${year}" <c:if test="${currentYear eq year.toString()}">selected</c:if>>${year}년</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">개봉 여부</label>
                    <select name="openedCode" class="form-select">
                        <option value="1" <c:if test="${product.isOpenedName eq '미개봉'}">selected</c:if>>미개봉</option>
                        <option value="0" <c:if test="${product.isOpenedName eq '개봉'}">selected</c:if>>개봉</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">파츠 누락</label>
                    <select name="missingCode" class="form-select">
                        <option value="0" <c:if test="${product.isPartsMissingName eq '정상'}">selected</c:if>>없음</option>
                        <option value="1" <c:if test="${product.isPartsMissingName eq '누락'}">selected</c:if>>있음</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">공개 여부</label>
                    <select name="publicCode" class="form-select">
                        <option value="1" <c:if test="${product.isPublicName eq '공개'}">selected</c:if>>공개</option>
                        <option value="0" <c:if test="${product.isPublicName eq '비공개'}">selected</c:if>>비공개</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label">상세 설명</label>
                    <textarea name="description" class="form-control" rows="4">${product.descriptions}</textarea>
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="button" class="btn btn-cancel w-50 py-2" onclick="history.back()">돌아가기</button>
                <button type="submit" class="btn btn-submit w-50 py-2">수정하기</button>
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
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
