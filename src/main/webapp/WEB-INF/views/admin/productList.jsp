<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 전체 상품 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .wf-header { font-weight: bold; background-color: #f8f9fa; border-bottom: 2px solid #ced4da; }
    .table-container { border: 1px solid #ced4da; background-color: #ffffff; min-height: 600px; }
    .product-thumb { width: 60px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #dee2e6; }
    th, td { padding: 12px !important; vertical-align: middle; text-align: center; }


	/* 페이지네이션 디자인 통일 */
	.pagination .page-link {
	    color: #212529;             /* 기본 글자색: 검정 */
	    border-color: #dee2e6;
	    padding: 8px 16px;
	}
	
	.pagination .page-item.active .page-link {
	    background-color: #212529 !important; /* 활성 페이지: 검정 배경 */
	    border-color: #212529 !important;
	    color: #ffffff !important;            /* 활성 페이지: 흰색 글자 */
	}
	
	.pagination .page-link:hover {
	    background-color: #f1f3f5;  /* 마우스 호버 시 연한 회색 */
	    color: #212529;
	}
	
	/* 처음으로/마지막으로 버튼 너비 조정 */
	.page-item .page-link span {
	    font-size: 0.9rem;
	}
	
	
	/* 필터 버튼 스타일 커스텀 */
	.filter-container {
	    background-color: #ffffff;
	    padding: 15px 20px;
	    border: 1px solid #ced4da;
	    border-radius: 4px;
	    margin-bottom: 20px;
	}
	
	.btn-check:checked + .btn-outline-dark {
	    background-color: #212529;
	    color: #ffffff;
	}
	
	.btn-outline-dark {
	    border-color: #ced4da;
	    color: #495057;
	    font-size: 0.95rem;
	    padding: 6px 20px;
	}
	
	.btn-outline-dark:hover {
	    background-color: #f8f9fa;
	    color: #212529;
	    border-color: #212529;
	}
	
	
	/* 관리 버튼 공통 스타일: 크기와 패딩을 강제로 고정 */
	.btn-admin-custom {
	    width: 80px !important;      /* 버튼 전체 너비 고정 */
	    padding: 4px 0 !important;   /* 상하 패딩은 유지, 좌우는 너비에 맞게 0 */
	    font-size: 0.85rem !important;
	    text-align: center;
	    display: inline-block;
	}
	
	/* 비활성화 버튼: 공통 스타일을 상속받으면서 색상과 커서만 변경 */
	.btn-action-disabled {
	    opacity: 0.6;							/* 불투명도 조절로 흐릿하게 표현 */
	    cursor: not-allowed !important;			/* 마우스 커서를 금지 모양으로 변경 */
	    pointer-events: none;					/* 클릭 이벤트 자체를 차단 */
	    background-color: #e9ecef !important;	/* 연한 회색 배경 */
	    border: 1px solid #dee2e6 !important;
	    color: #6c757d !important;
	}
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(function() {
		
		$("input[name='statusFilter']").on("change", function() {
			let url = "${ pageContext.request.contextPath }/admin/product/list";
			
			url = url + "?" + "productStatus=" + $(this).val();
			
			location.href = url;
		});
		
	});
	
	
	// 상품 비공개로 전환
	function hideProduct(productId) {
		
		let formEl = document.createElement('form');
		formEl.method = 'POST';
		formEl.action = "${ pageContext.request.contextPath }/admin/product/hideProduct";
		
		let inputEl = document.createElement('input');
		inputEl.type = 'hidden';
		inputEl.name = "productId";
		inputEl.value = productId;
		formEl.appendChild(inputEl);
		
		
		inputEl = document.createElement('input');
		inputEl.type = 'hidden';
		inputEl.name = "url";
		inputEl.value = location.href;
		formEl.appendChild(inputEl);
		
		
		document.body.appendChild(formEl);
		formEl.submit();
		
	}// hideProduct(...) END
	
	
	// 유저 패널티 부여
	function penaltyToProductUser(userId)
	{
		let formEl = document.createElement('form');
		formEl.method = 'GET';
		formEl.action = "${ pageContext.request.contextPath }/admin/penalty/register";
		
		let inputElUser = document.createElement('input');
		inputElUser.type = 'hidden';
		inputElUser.name = "userId";
		inputElUser.value = userId;
		formEl.appendChild(inputElUser);
		
		
		let inputElUrl = document.createElement('input');
		inputElUrl.type = 'hidden';
		inputElUrl.name = "url";
		inputElUrl.value = location.href;
		formEl.appendChild(inputElUrl);
		
		
		document.body.appendChild(formEl);
		formEl.submit();
	}// penaltyToProductUser(...) END
</script>
</head>
<body class="bg-light">
    <div class="container-fluid py-4">
        <h4 class="fw-bold mb-4">전체 상품 목록 관리</h4>
        
        <!-- 필터 검색 영역 -->
        <div class="filter-container d-flex align-items-center justify-content-between">
		    <div class="d-flex align-items-center">
		        <span class="fw-bold me-3"><i class="bi bi-funnel-fill"></i> 상태 필터</span>
		        <div class="btn-group" role="group" aria-label="Product Status Filter">
		        	<%-- 전체 상품 --%>
			        <c:choose>
			        	<c:when test="${ productStatus == 'all' }">
			        		<input type="radio" class="btn-check" name="statusFilter" value="all" id="filterAll" checked>
		            		<label class="btn btn-outline-dark" for="filterAll">전체</label>
			        	</c:when>
			        	<c:otherwise>
			        		<input type="radio" class="btn-check" name="statusFilter" value="all" id="filterAll">
		            		<label class="btn btn-outline-dark" for="filterAll">전체</label>
			        	</c:otherwise>
			        </c:choose>
			        <%-- 공개 상품 --%>
			        <c:choose>
			        	<c:when test="${ productStatus == 'public' }">
			        		<input type="radio" class="btn-check" name="statusFilter" value="public" id="filterPublic" checked>
		            		<label class="btn btn-outline-dark" for="filterPublic">공개</label>
			        	</c:when>
			        	<c:otherwise>
			        		<input type="radio" class="btn-check" name="statusFilter" value="public" id="filterPublic">
		            		<label class="btn btn-outline-dark" for="filterPublic">공개</label>
			        	</c:otherwise>
			        </c:choose>
			        <%-- 비공개 상품 --%>
			        <c:choose>
			        	<c:when test="${ productStatus == 'privete' }">
			        		<input type="radio" class="btn-check" name="statusFilter" value="privete" id="filterPrivate" checked>
		            		<label class="btn btn-outline-dark" for="filterPrivate">비공개</label>
			        	</c:when>
			        	<c:otherwise>
			        		<input type="radio" class="btn-check" name="statusFilter" value="privete" id="filterPrivate">
		            		<label class="btn btn-outline-dark" for="filterPrivate">비공개</label>
			        	</c:otherwise>
			        </c:choose>
		        </div>
		    </div>
		    
		    <div class="text-muted">
		        총 <span class="fw-bold text-dark">${ productTotalCount }</span>개의 상품
		    </div>
		</div>
        
        <!-- 실제 데이터 출력 영역 -->
        <div class="table-container shadow-sm">
            <table class="table table-hover mb-0">
                <thead class="wf-header">
                    <tr>
                        <th>이미지</th>
                        <th>등록 회원</th>
                        <th>공개 여부</th>
                        <th>상품명 / 별칭</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                
                <c:forEach var="productDto" items="${ productList }">
                <tr>
                	<td><img src="${ pageContext.request.contextPath }/${ productDto.imagePath1 }" class="product-thumb"></td>
                	<td>${ productDto.userId }</td>
                	<td>
                		<c:choose>
					        <c:when test="${productDto.isPublicName == '공개'}">
					            <span class="badge rounded-pill bg-primary-subtle text-primary border border-primary-subtle">
					                <i class="bi bi-eye-fill me-0"></i> 공개
					            </span>
					        </c:when>
					        <c:otherwise>
					            <span class="badge rounded-pill bg-secondary-subtle text-secondary border border-secondary-subtle">
					                <i class="bi bi-eye-slash-fill me-0"></i> 비공개
					            </span>
					        </c:otherwise>
					    </c:choose>
					</td>
					<td class="text-start">${ productDto.productReleaseName }<br><small class="text-muted">${ productDto.productAlias }</small></td>
					<td>
						<c:choose>
					        <c:when test="${productDto.isPublicName == '공개'}">
					        	<%-- 공개 상품에 대한 비공개 버튼 --%>
					            <button type="button" class="btn btn-sm btn-outline-dark btn-admin-custom" 
		                        	onclick="hideProduct('${ productDto.productId }')">
		                        	비공개
		                        </button>
					        </c:when>
					        <c:otherwise>
					            <%-- 이미 비공개 상태인 상품에 대해선 비공개 버튼 비활성화 --%>
	                            <button type="button" class="btn btn-sm btn-action-disabled btn-admin-custom"
	                            	 tabindex="-1" aria-disabled="true">
				                    비공개
				                </button>
					        </c:otherwise>
					    </c:choose>
					    
					    <button class="btn btn-sm btn-outline-danger btn-admin-custom" onclick="penaltyToProductUser(${ productDto.userId})">
					    	패널티
					    </button>
					</td>
                </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

		<!-- 페이지 버튼 영역 -->
		<div class="row mt-4 mb-3">
            <div class="col-12 d-flex justify-content-center">
                <nav aria-label="Page navigation">
                	<%--
                    <ul class="pagination mb-0">
                        <li class="page-item">
                            <a class="page-link" href="#" aria-label="First">
                                <span aria-hidden="true">처음으로</span>
                            </a>
                        </li>
                        <li class="page-item"><a class="page-link" href="#">11</a></li>

                        <li class="page-item active" aria-current="page">
		                    <span class="page-link">12</span>
		                </li>

                        <li class="page-item"><a class="page-link" href="#">13</a></li>
                        <li class="page-item"><a class="page-link" href="#">14</a></li>
		                <li class="page-item"><a class="page-link" href="#">15</a></li>
		                <li class="page-item"><a class="page-link" href="#">16</a></li>
		                <li class="page-item"><a class="page-link" href="#">17</a></li>
		                <li class="page-item"><a class="page-link" href="#">18</a></li>
		                <li class="page-item"><a class="page-link" href="#">19</a></li>
		                <li class="page-item"><a class="page-link" href="#">20</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#" aria-label="Last">
                                <span aria-hidden="true">마지막으로</span>
                            </a>
                        </li>
                    </ul>
                    --%>
                    
                    ${ pageElement }
                </nav>
            </div>
        </div>

		<!-- 돌아가기 버튼 영역 -->
        <div class="d-flex justify-content-center mt-0 py-5">
        	<%--
            <button type="button" class="btn btn-secondary px-5 fw-bold" onclick="location.href='mainDashBoard.jsp'">
            --%>
            <button type="button" class="btn btn-secondary px-5 fw-bold" onclick="location.href='${ pageContext.request.contextPath }/admin'">
                대시보드로 돌아가기
            </button>
        </div>      

    </div>
</body>
</html>