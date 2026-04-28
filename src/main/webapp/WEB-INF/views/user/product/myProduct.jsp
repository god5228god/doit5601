<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 등록 상품</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
<style type="text/css">
body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; }
.btn-primary {
   background-color: #120e63 !important;
   border-color: #120e63 !important;
}
 .bg-primary{
    background-color: #120e63 !important;
    }
   	i.text-primary{
   		color: #120e63 !important;
   	}
    .btn-primary, .bg-primary, .btn-outline-primary:hover {
        background-color: #120e63 !important;
        border-color: #120e63 !important;
        color: #ffffff !important; 
    }
    
    .btn-outline-primary{
    	background-color: #fff !important;
    	border-color: #120e63 !important;
    	color: #120e63 !important;
    }


    .badge.bg-primary {
        background-color: #5172a6 !important;
    }

    .pagination .page-item.active .page-link {
        background-color: #5172a6 !important;
        border-color: #5172a6 !important;
        color: #ffffff !important;
    }

    .pagination .page-link:hover {
        color: #5172a6;
    }
    
    .page-link:focus {
        box-shadow: 0 0 0 0.25rem rgba(18, 14, 99, 0.25);
    }
    .nav-link{
    	color: #5172a6 !important;
    }
</style>
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/common/header.jsp" %>
   <main class="container" style="margin-top: 50px; margin-bottom: 50px;">
      <div class="row">
         <aside class="col-md-3">
            <%@ include file="/WEB-INF/views/common/mypage_layout.jsp" %>
         </aside>
         <section class="col-md-9">
            <div class="card shadow-sm border-0 bg-white p-4">
               <div
                  class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom">
                  <h5 class="mb-0 fw-bold">
                     내 등록 상품 <span class="txtColor small">${dataCount }</span>
                  </h5>
                  <a href="${pageContext.request.contextPath}/product/register" class="btn btn-primary btn-sm px-3">
                     <i class="bi bi-plus-lg"></i> 새 상품 등록
                  </a>
                  <!-- </button> -->
               </div>
               <div class="card-body">
                  <ul class="nav nav-tabs mb-4 txtColor" id="productTab" role="tablist">
                     <li class="nav-item">
                        <a class="nav-link fw-bold ${param.type == 'ALL' || empty param.type ? 'active' : ''}"
                            id="tab-all" data-type="ALL"
                            href="${pageContext.request.contextPath }/user/product?type=ALL"
                            >전체</a>
                     </li>
                     <li class="nav-item">
                        <a class="nav-link ${param.type == 'PUBLIC' ? 'active' : ''}"
                         id="tab-public" href="${pageContext.request.contextPath }/user/product?type=PUBLIC"
                           data-type="PUBLIC">공개</a>
                     </li>
                     <li class="nav-item">
                        <a class="nav-link" ${param.type == 'PRIVATE' ? 'active' : ''}
                         id="tab-private"
                           data-type="PRIVATE" href="${pageContext.request.contextPath}/user/product?type=PRIVATE">비공개</a>
                     </li>
                  </ul>

                  <div class="table-responsive">
                     <table class="table align-middle">
                        <thead class="table-light">
                           <tr class="text-center">
                              <th style="width: 10%">번호</th>
                              <th style="width: 10%">이미지</th>
                              <th style="width: 30%" class="text-start ps-4">상품 정보</th>
                              <th style="width: 12%">상태</th>
                              <th style="width: 13%">등록일</th>
                              <th style="width: 25%">관리</th>
                           </tr>
                        </thead>
                        <tbody id="product-list-body">
                           <c:forEach var="dto" items="${list }" varStatus="status">
                              <tr>
                              <td class="text-center">${status.count}</td>
                              <td class="text-center"><img
                                 src="${pageContext.request.contextPath}/${dto.imagePath1 }"
                                 class="rounded shadow-sm" alt="상품" style="width: 60px; height: 60px; object-fit: cover;"></td>
                              <td class="ps-4">
                                 <div class="fw-bold">
                                    <a href="${pageContext.request.contextPath }/product/detail?productId=${dto.productId}"
                                       class="text-decoration-none text-dark link-primary">${dto.productReleaseName }</a>
                                 </div>
                              </td>
                              <td class="text-center">
                                 <c:choose>
                                    <c:when test="${dto.isPublic == 1 }">
                                       <span class="badge bg-success-subtle text-success border border-success px-3">
                                          공개 
                                       </span>
                                    </c:when>
                                    <c:otherwise>
                                       <span class="badge bg-danger-subtle text-danger border border-danger px-3">
                                          비공개 
                                       </span>
                                    </c:otherwise>
                                 </c:choose>
                                 
                                 
                              </td>
                              <td class="text-center text-muted small">
                                 <fmt:parseDate value="${dto.createdAt}" var="parsedDate" pattern="yyyy-MM-dd HH:mm:ss" />
                                       <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd" />
                              </td>
                              <td class="text-center">
                                 <div class="d-flex gap-1 justify-content-center">
                                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath }/product/update?productId=${dto.productId}">수정</a>
                                    <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath }/product/delete?productId=${dto.productId}">삭제</a>
                                    <a class="btn btn-sm fw-bold 
									   ${(empty dto.auctionId || dto.auctionId == 0) && dto.isPublic == 1 ? 'btn-primary' : 'btn-outline-primary'} 
									   ${(dto.isPublic != 1 || (not empty dto.auctionId && dto.auctionId != 0)) ? 'disabled' : ''}"
									   href="${(dto.isPublic == 1 && (empty dto.auctionId || dto.auctionId == 0)) ? pageContext.request.contextPath.concat('/user/mypage/auction?productId=').concat(dto.productId) : '#'}">
									   
									   <c:choose>
									       <c:when test="${empty dto.auctionId || dto.auctionId == 0}">
									           경매등록
									       </c:when>
									       <c:when test="${dto.isFinished == '진행중'}">
									           경매중
									       </c:when>
									       <c:otherwise>
									           경매마감
									       </c:otherwise>
									   </c:choose>
									</a>
                                 </div>
                              </td>
                           </tr>
                           </c:forEach>
                     
                        </tbody>
                     </table>
                  </div>
                  <div class="d-flex justify-content-center mt-4">
                     ${actualCount == 0? "등록된 게시물이 없습니다.": paging }
                  </div>

               </div>
            </div>
         </section>


      </div>

   </main>


<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>