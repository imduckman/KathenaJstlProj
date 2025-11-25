<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CartDAO, dto.CartDTO, java.util.List"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%
    // 1. 로그인 체크
    dto.MemberDTO loginUser = (dto.MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) { response.sendRedirect("login.jsp"); return; }

    // 2. 장바구니 목록 가져오기
    CartDAO dao = CartDAO.getInstance();
    List<CartDTO> cartList = dao.getCartList(loginUser.getMemberId());
    request.setAttribute("cartList", cartList);
    
    // 3. 총 결제 금액 계산
    int totalPrice = 0;
    for(CartDTO c : cartList) totalPrice += c.getItemPrice();
    request.setAttribute("totalPrice", totalPrice);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KATHENA - 장바구니</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        /* 네비게이션 스타일 (메인과 통일) */
        .navbar-brand { color: #000000 !important; font-weight: bold; }
        .navbar-nav .nav-link { color: #333333 !important; font-weight: 500; }
        .object-fit-cover { object-fit: cover; }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4 sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/main.jsp">KATHENA Club</a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/main.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/shop.jsp">Shop</a></li>
                </ul>
                
                <div class="d-flex align-items-center">
                    <c:choose>
                        <c:when test="${empty sessionScope.loginUser}">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-dark me-2">Login</a>
                        </c:when>
                        <c:otherwise>
                            <div class="me-3 text-end">
                                <span class="small text-secondary d-block">Hello!</span>
                                <span class="fw-bold">${sessionScope.loginUser.name}</span>
                                <span class="badge bg-primary ms-1">
                                    <fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> P
                                </span>
                            </div>
                            <a href="${pageContext.request.contextPath}/mypage.jsp" class="btn btn-sm btn-outline-secondary me-2">My</a>
                            <a href="${pageContext.request.contextPath}/logoutAction.jsp" class="btn btn-sm btn-danger">Logout</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <h2 class="mb-4 fw-bold"><i class="bi-cart-check-fill text-primary"></i> 내 장바구니</h2>
        
        <div class="row">
            <div class="col-md-8 mb-4">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <c:if test="${empty cartList}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi-cart-x fs-1 d-block mb-3"></i>
                                장바구니가 비어있습니다.
                            </div>
                        </c:if>
                        
                        <c:forEach var="c" items="${cartList}">
                            <div class="d-flex align-items-center border-bottom py-3">
                                <img src="${empty c.itemImageUrl ? 'https://dummyimage.com/100x100/eee/aaa' : c.itemImageUrl}" 
                                     width="80" height="80" class="rounded me-3 object-fit-cover border">
                                
                                <div class="flex-grow-1">
                                    <h5 class="mb-1 fw-bold">${c.itemName}</h5>
                                    <p class="mb-0 text-primary fw-bold">
                                        <fmt:formatNumber value="${c.itemPrice}" pattern="#,###"/> P
                                    </p>
                                </div>
                                
                                <a href="cartDeleteAction.jsp?cartId=${c.cartId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('삭제하시겠습니까?');">
                                    <i class="bi-trash"></i> 삭제
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card shadow-sm border-0 sticky-top" style="top: 100px;">
                    <div class="card-header bg-white fw-bold py-3">결제 예정 금액</div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-3">
                            <span>총 상품 금액</span>
                            <span class="fw-bold"><fmt:formatNumber value="${totalPrice}" pattern="#,###"/> P</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4 fs-5 text-primary fw-bold">
                            <span>합계</span>
                            <span><fmt:formatNumber value="${totalPrice}" pattern="#,###"/> P</span>
                        </div>
                        
                        <c:if test="${not empty cartList}">
                            <a href="cartBuyAction.jsp" class="btn btn-primary w-100 py-2 fw-bold" onclick="return confirm('장바구니의 모든 상품을 구매하시겠습니까?');">
                                전체 구매하기
                            </a>
                        </c:if>
                        <c:if test="${empty cartList}">
                            <button class="btn btn-secondary w-100 py-2" disabled>구매 불가</button>
                        </c:if>
                        
                        <a href="shop.jsp" class="btn btn-outline-secondary w-100 mt-2">쇼핑 계속하기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>