<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 제재 유저 조회</title>
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
        background-color: #fff5f5;
    }
    
    .table-container {
        border: 1px solid #ced4da;
        background-color: #ffffff;
        min-height: 600px;
        overflow-y: auto;
    }

    th, td {
        padding: 12px !important;
        vertical-align: middle;
    }

    .pagination { margin-bottom: 0; }
    .page-link { color: #333; border-color: #ced4da; }
    .page-item.active .page-link {
        background-color: #dc3545;
        border-color: #dc3545;
        color: white;
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
        color: #000;
    }

    .btn-release {
        padding: 4px 12px;
        font-size: 0.85rem;
        font-weight: bold;
    }
</style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row mb-4 align-items-end">
        <div class="col-md-6">
            <h1 class="fw-bold text-danger">제재 유저 조회</h1>
            <p class="text-muted">전체 제재 내역: <span class="text-danger fw-bold">${totalCount}</span>건</p>
        </div>
        <div class="col-md-6">
            <%-- [검색 폼] 컨트롤러 주소와 일치시킴 --%>
            <form action="show-penalty-user" method="get" class="input-group">
                <select name="searchType" class="form-select" style="max-width: 130px;">
                    <option value="id" selected>아이디</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control" placeholder="아이디 검색..." value="${searchKeyword}">
                <button class="btn btn-danger" type="submit">검색</button>
            </form>
        </div>
    </div>

  <%-- 중간 생략 (Style 부분은 동일) --%>

    <div class="table-container shadow-sm">
        <table class="table text-center table-hover">
            <thead class="wf-header">
                <tr>
                    <th>고유키</th>
                    <th>아이디</th> <%-- 실제 로그인 ID 출력 칸 --%>
                    <th>상태</th>
                    <th>누적 점수</th>
                    <th>제재 시작일</th>
                    <th>제재 종료일</th>
                    <th>진행 상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${penaltyList}">
                    <%-- 클릭 시 이동은 고유키(숫자) 기반으로 유지 --%>
                    <tr class="user-row" >
                        <td>${p.penaltyId}</td>
                        
                        <%-- [수정] 숫자 아이디 대신 실제 로그인 아이디(user01 등) 출력 --%>
                        <td class="fw-bold text-primary">${p.userLoginId}</td>
                        
                        <td>
                            <c:choose>
                                <c:when test="${p.penaltyStatus == '영구 정지'}">
                                    <span class="badge rounded-pill bg-dark">${p.penaltyStatus}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge rounded-pill bg-danger">${p.penaltyStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="badge bg-secondary">${p.accumulatedScore} / 4</span></td>
                        <td>${p.startDate}</td>
                        <td>${empty p.endDate ? '-' : p.endDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.historyStatus == '제재 중'}">
                                    <span class="text-danger fw-bold">${p.historyStatus}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">${p.historyStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty penaltyList}">
                    <tr>
                        <td colspan="7" class="py-5 text-muted">제재 내역이 존재하지 않습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

<%-- 하단 페이징 및 버튼 부분 동일 --%>

    <%-- [페이징] 검색어 유지 포함 --%>
    <div class="row mt-4">
        <div class="col-12 d-flex justify-content-center">
            <nav>
                <ul class="pagination">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="show-penalty-user?page=${currentPage - 1}&searchKeyword=${searchKeyword}">&laquo;</a>
                    </li>
                    
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="show-penalty-user?page=${i}&searchKeyword=${searchKeyword}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages || totalPages == 0 ? 'disabled' : ''}">
                        <a class="page-link" href="show-penalty-user?page=${currentPage + 1}&searchKeyword=${searchKeyword}">&raquo;</a>
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