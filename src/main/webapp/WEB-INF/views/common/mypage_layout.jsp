<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">    
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
<script>
$(function() {
    const currentPath = window.location.pathname;
    const $sidebar = $('#mypage-sidebar');

    function init() {
        $sidebar.find('.list-group-item').removeClass('active');
        $sidebar.find('a.list-group-item').each(function() {
            const href = $(this).attr('href');
            if (href && currentPath === href) {
                $(this).addClass('active');
                const $sub = $(this).closest('.submenu-list');
                if ($sub.length) {
                    $sub.addClass('show');
                    $sidebar.find(`a[href="#${$sub.attr('id')}"]`).addClass('active').removeClass('collapsed');
                }
            }
        });
    }
    init();

    $sidebar.on('click', '.main-menu', function(e) {
        e.preventDefault();
        const targetId = $(this).attr('href');
        const $target = $(targetId);

        $sidebar.find('.list-group-item').removeClass('active');
        
        $(this).addClass('active');

        $('.submenu-list').not($target).collapse('hide');
        $('.main-menu').not(this).addClass('collapsed');
        
        $target.collapse('toggle');
        $(this).toggleClass('collapsed');
    });

    $sidebar.on('click', '.menu-link', function() {
        $sidebar.find('.list-group-item').removeClass('active');
        $(this).addClass('active');
        $('.submenu-list').collapse('hide');
        $('.main-menu').addClass('collapsed');
    });

    $sidebar.on('click', '.submenu-list a', function() {
        $sidebar.find('.list-group-item').removeClass('active');
        $(this).addClass('active');
        
        const $parentSub = $(this).closest('.submenu-list');
        $sidebar.find(`a[href="#${$parentSub.attr('id')}"]`).addClass('active');
    });
});
</script>
<style>
    #mypage-sidebar .list-group-item {
        border: none !important;
        transition: all 0.2s;
        cursor: pointer;
    }

    #mypage-sidebar .main-menu.active, 
    #mypage-sidebar .menu-link.active {
        background-color: #e7f1ff !important;
        color: #120e63 !important;
        border-left: 5px solid #120e63 !important; 
        font-weight: bold !important;
    }

    #mypage-sidebar .submenu-list .list-group-item {
        padding-left: 3rem !important;
        color: #666;
    }

    #mypage-sidebar .submenu-list .list-group-item.active {
        color: #120e63 !important;
        font-weight: bold !important;
        background-color: #f8f9fa !important; 
        border-left: 5px solid #120e63 !important; 
        text-decoration: none !important;
    }

    .arrow-icon { transition: transform 0.3s; }
    .main-menu:not(.collapsed) .arrow-icon { transform: rotate(180deg); }
</style>

</head>
<body>
<div class="list-group shadow-sm mb-4" id="mypage-sidebar">
    <a href="${pageContext.request.contextPath}/user/my" class="list-group-item list-group-item-action py-3 menu-link">
        <i class="bi bi-person-badge me-2"></i>나의 활동 요약
    </a>
    <a href="${pageContext.request.contextPath}/user/product" class="list-group-item list-group-item-action py-3 menu-link">
        <i class="bi bi-box-seam me-2"></i>내 등록 상품
    </a>
	 <a href="${pageContext.request.contextPath}/user/products" class="list-group-item list-group-item-action py-3 menu-link">
        <i class="bi bi-box-seam me-2"></i>내 낙찰 상품
    </a>
    <div class="list-group-item p-0 border-0">
        <a href="#auctionSubmenu" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 main-menu collapsed">
            <span><i class="bi bi-hammer me-2"></i>내 경매 내역</span>
            <i class="bi bi-chevron-down small text-muted arrow-icon"></i>
        </a>
        <div class="collapse submenu-list" id="auctionSubmenu">
            <a href="${pageContext.request.contextPath}/user/auctions/active" class="list-group-item list-group-item-action py-2 ps-5">• 경매 현황</a>
            <a href="${pageContext.request.contextPath}/user/auctions/closed" class="list-group-item list-group-item-action py-2 ps-5">• 경매 이력</a>
        </div>
    </div>

    <div class="list-group-item p-0 border-0">
        <a href="#bidSubmenu" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 main-menu collapsed">
            <span><i class="bi bi-currency-exchange me-2"></i>내 입찰 내역</span>
            <i class="bi bi-chevron-down small text-muted arrow-icon"></i>
        </a>
        <div class="collapse submenu-list" id="bidSubmenu">
            <a href="${pageContext.request.contextPath}/user/bids/active" class="list-group-item list-group-item-action py-2 ps-5">• 입찰 현황</a>
            <a href="${pageContext.request.contextPath}/user/bids/closed" class="list-group-item list-group-item-action py-2 ps-5">• 입찰 이력</a>
        </div>
    </div>
     <a href="${pageContext.request.contextPath}/user/product/wishlist" class="list-group-item list-group-item-action py-3 menu-link">
        <i class="bi bi-heart-fill me-2"></i>내 관심 상품</a>
    <a href="${pageContext.request.contextPath}/user/penalty" class="list-group-item list-group-item-action py-3 menu-link">
        <i class="bi bi-exclamation-octagon me-2"></i>내 패널티 내역
    </a>
        <a href="${pageContext.request.contextPath}/payment.history" class="list-group-item list-group-item-action py-3 menu-link">
        <i class="bi bi-exclamation-octagon me-2"></i>내 머니 내역
    </a>

    <div class="list-group-item p-0 border-0">
        <a href="#infoSubmenu" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 main-menu collapsed">
            <span><i class="bi bi-gear me-2"></i>내 정보 관리</span>
            <i class="bi bi-chevron-down small text-muted arrow-icon"></i>
        </a>
        <div class="collapse submenu-list" id="infoSubmenu">
            <a href="${pageContext.request.contextPath}/user/my/change-info" class="list-group-item list-group-item-action py-2 ps-5">• 회원 정보 변경</a>
            <a href="${pageContext.request.contextPath}/user/my/change-pw" class="list-group-item list-group-item-action py-2 ps-5">• 비밀번호 변경</a>
            <a href="${pageContext.request.contextPath}/unregister/" class="list-group-item list-group-item-action py-2 ps-5">• 회원 탈퇴</a>
        </div>
    </div>
</div>

</body>
</html>