<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 대시보드</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
<style type="text/css">
    html, body { height: 100%; }
    
    /* 사이드바 스타일 수정 */
    .sidebar {
        min-width: 250px;
        max-width: 250px;
        background-color: #ffffff;
        border-right: 1px solid #dee2e6;
        min-height: calc(100vh - 60px);
    }
    
    .sidebar .nav-link {
        color: #495057;
        padding: 12px 20px;
        border-radius: 0;
        font-weight: 500;
        transition: all 0.2s;
    }
    
    .sidebar .nav-link:hover {
        background-color: #f1f3f5;
        color: #000;
    }

    /* 파란색을 없애고 로그인 페이지 느낌의 검은색 포인트로 변경 */
    .sidebar .nav-link.active {
        background-color: #f8f9fa !important; /* 파란색 제거 */
        color: #212529 !important;
        font-weight: bold;
        border-right: 4px solid #212529; /* 왼쪽에 강조 선 추가 */
    }

    /* 메인 콘텐츠 영역 */
    .content-area {
        flex: 1;
        background-color: #f8f9fa;
        padding: 40px;
    }

    .summary-card {
        border: 1px solid #dee2e6;
        border-radius: 8px;
        transition: all 0.3s ease;
        background: #fff;
    }
    
    .summary-card:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .summary-value {
        font-size: 2.2rem;
        font-weight: 700;
        color: #212529;
    }
    
    .summary-label {
        color: #868e96;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    /* 테이블 내부 스크롤 조치 */
    .table-responsive-custom {
        max-height: 450px;
        overflow-y: auto;
    }
</style>
</head>
<body>

<jsp:include page="/common/loginHeader.jsp"></jsp:include>

<div class="d-flex">
    <nav class="sidebar shadow-sm">
        <div class="p-4">
            <h6 class="text-uppercase fw-bold text-muted small">Menu</h6>
        </div>
        <div class="nav flex-column">
            <a href="mainDashBoard.jsp" class="nav-link active"><i class="bi bi-grid-1x2-fill me-2"></i> 대시보드</a>
            
            <a href="${pageContext.request.contextPath}/admin/show-all-users" class="nav-link">
        	<i class="bi bi-people me-2"></i> 회원 관리</a>
            
            <a href="${pageContext.request.contextPath}/admin/show-penalty-user" class="nav-link">
            <i class="bi bi-person-x me-2"></i> 패널티 관리</a>
            
            <a href="productList.jsp" class="nav-link"><i class="bi bi-box-seam me-2"></i> 상품 관리</a>
            <a href="auctionList.jsp" class="nav-link"><i class="bi bi-hammer me-2"></i> 경매 관리</a>
            <hr class="mx-3 my-2 opacity-10">
            <a href="reportsList.jsp" class="nav-link"><i class="bi bi-megaphone me-2"></i> 신고 관리</a>
            <a href="reportsHistory.jsp" class="nav-link"><i class="bi bi-card-checklist me-2"></i> 신고 처리 이력</a>
        </div>
    </nav>

    <main class="content-area">
        <div class="container-fluid">
            <div class="mb-5">
                <h2 class="fw-bold">Administrator Dashboard</h2>
                <p class="text-secondary">서비스 현황을 실시간으로 확인하세요.</p>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-3">
                    <div class="card summary-card shadow-sm p-4 text-center">
                        <div class="summary-label mb-2">전체 회원</div>
                        <div class="summary-value">1,240</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card summary-card shadow-sm p-4 text-center">
                        <div class="summary-label mb-2">진행 중인 경매</div>
                        <div class="summary-value">86</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card summary-card shadow-sm p-4 text-center">
                        <div class="summary-label mb-2 text-danger">미처리 신고</div>
                        <div class="summary-value text-danger">12</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card summary-card shadow-sm p-4 text-center">
                        <div class="summary-label mb-2 text-primary">신규 상품</div>
                        <div class="summary-value text-primary">42</div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0">최근 신고 내역 요약</h5>
                    <a href="reportsList.jsp" class="btn btn-sm btn-outline-secondary">전체보기</a>
                </div>
                <div class="table-responsive-custom">
                    <table class="table align-middle table-hover">
                        <thead class="table-light">
                            <tr>
                                <th class="py-3">번호</th>
                                <th class="py-3">신고 유형</th>
                                <th class="py-3">신고자</th>
                                <th class="py-3">피신고자</th>
                                <th class="py-3">상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>104</td>
                                <td>허위 매물 등록</td>
                                <td>user01</td>
                                <td>seller99</td>
                                <td><span class="badge rounded-pill bg-warning text-dark">접수 대기</span></td>
                            </tr>
                            <tr>
                                <td>103</td>
                                <td>채팅창 언어 폭력</td>
                                <td>king12</td>
                                <td>badboy</td>
                                <td><span class="badge rounded-pill bg-success">처리 완료</span></td>
                            </tr>
                            </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>