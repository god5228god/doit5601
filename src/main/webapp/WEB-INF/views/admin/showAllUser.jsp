<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 회원 관리 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .wf-header {
        font-weight: bold;
        background-color: #f8f9fa;
        border-bottom: 2px solid #ced4da;
        position: sticky;
        top: 0;
        z-index: 10;
    }
    
    .user-row {
        cursor: pointer;
        transition: background-color 0.2s;
    }
    
    .user-row:hover {
        background-color: #f1f3f5;
    }
    
    .table-container {
        border: 1px solid #ced4da;
        background-color: #ffffff;
        min-height: 600px;
    }

    th, td {
        padding: 12px !important;
        vertical-align: middle;
    }

    .btn-wf {
        background-color: #e9ecef;
        border: 1px solid #ced4da;
        padding: 8px 30px;
        font-weight: bold;
        color: #212529;
        text-decoration: none;
        display: inline-block;
        transition: all 0.2s;
    }

    .btn-wf:hover {
        background-color: #dee2e6;
        border-color: #adb5bd;
        color: #000;
    }
    
    /* 페이징 활성화 스타일 보정 */
    .pagination .page-item.active .page-link {
        background-color: #212529;
        border-color: #212529;
        color: #fff;
    }
    .pagination .page-link {
        color: #212529;
    }
</style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row mb-4 align-items-end">
        <div class="col-md-6">
            <h1 class="fw-bold">전체 회원 목록</h1>
            <p class="text-muted">총 회원 수: <span class="text-primary fw-bold">${totalCount}</span>명</p>
        </div>
        <%-- [수정] 검색 폼 추가: 검색 시 컨트롤러(show-all-users)로 파라미터 전송 --%>
        <div class="col-md-6">
            <form action="show-all-users" method="get" class="input-group">
                <select name="searchType" class="form-select" style="max-width: 120px;">
                    <option value="id" ${searchType == 'id' ? 'selected' : ''}>아이디</option>
                    <option value="name" ${searchType == 'name' ? 'selected' : ''}>이름</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control" placeholder="회원 검색..." value="${searchKeyword}">
                <button class="btn btn-dark" type="submit">검색</button>
            </form>
        </div>
    </div>

    <div class="table-container shadow-sm">
        <table class="table text-center table-hover mb-0">
            <thead class="wf-header">
                <tr>
                    <th>고유키</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>전화번호</th>
                    <th>가입일</th>
                    <th>상태</th>
                </tr>
            </thead>
            
            <tbody>
                <c:forEach var="user" items="${userList}">
                    <tr class="user-row" onclick="location.href='show-user-detail?userKey=${user.userKey}'">
                        <td>${user.userKey}</td>
                        <td>${user.userId}</td>
                        <td>${user.userName}</td>
                        <td>${user.userTel}</td>
                        <td>${user.userCreated}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.userStatus == '제재중'}">
                                    <span class="badge rounded-pill bg-danger">제재중</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge rounded-pill bg-primary">정상</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty userList}">
                    <tr>
                        <td colspan="6" class="text-center py-5 text-muted">
                            조회된 회원 정보가 없습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <%-- [수정] 페이징 영역: 이동 시 검색 조건(searchType, searchKeyword)을 주소에 포함 --%>
    <div class="row mt-4">
        <div class="col-12 d-flex justify-content-center">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <%-- 이전 페이지 버튼 --%>
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="show-all-users?page=${currentPage - 1}&searchType=${searchType}&searchKeyword=${searchKeyword}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <%-- 페이지 번호 반복문 --%>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="show-all-users?page=${i}&searchType=${searchType}&searchKeyword=${searchKeyword}">${i}</a>
                        </li>
                    </c:forEach>

                    <%-- 다음 페이지 버튼 --%>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="show-all-users?page=${currentPage + 1}&searchType=${searchType}&searchKeyword=${searchKeyword}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
    
	<div class="d-flex justify-content-end mb-5">
        <a href="${pageContext.request.contextPath}/JY/mainDashBoard.jsp" class="btn btn-wf">돌아가기</a>
    </div>
</div>

</body>
</html>