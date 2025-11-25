<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KATHENA - MAIN</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KATHENA</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}\resources/css/custom.css" rel="stylesheet">  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/main.jsp">
                <i class="bi-lightning-charge-fill text-warning"></i> K.ATHENA
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                    <li class="nav-item"><a class="nav-link active fw-bold" href="${pageContext.request.contextPath}/main.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/shop.jsp">Shop</a></li>
                </ul>
                
                <div class="d-flex align-items-center">
                    <c:choose>
                        <%-- 1. 로그인 안 했을 때 --%>
                        <c:when test="${empty sessionScope.loginUser}">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-dark me-2">로그인</a>
                            <a href="${pageContext.request.contextPath}/join.jsp" class="btn btn-primary">회원가입</a>
                        </c:when>
                        
                        <%-- 2. 로그인 했을 때 --%>
                        <c:otherwise>
                            <div class="me-3 text-end">
                                <span class="d-block small text-secondary">반갑습니다!</span>
                                <span class="fw-bold text-dark">${sessionScope.loginUser.name}</span>님
                                <span class="badge rounded-pill bg-primary ms-1">
                                    <fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> P
                                </span>
                            </div>
                            
                            <c:if test="${sessionScope.loginUser.role == 'ADMIN'}">
                                <div class="btn-group me-2">
                                    <a href="${pageContext.request.contextPath}/admin_add.jsp" class="btn btn-sm btn-warning" title="상품등록">
                                        <i class="bi-box-seam"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin_member_list.jsp" class="btn btn-sm btn-info text-white" title="회원관리">
                                        <i class="bi-people-fill"></i>
                                    </a>
                                </div>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/mypage.jsp" class="btn btn-sm btn-outline-secondary me-2">내 정보</a>
                            <a href="${pageContext.request.contextPath}/logoutAction.jsp" class="btn btn-sm btn-danger">로그아웃</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>


    <header class="main-banner text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-3">K.ATHENA</h1>
            <p class="lead text-white-50 mb-4">
                동아리 활동으로 포인트를 모으고<br>
                다양한 혜택과 상품을 누려보세요!
            </p>
        </div>
    </header>


    <section class="container mb-5">
        <div class="row g-4 justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body p-4 text-center">
                        <div class="fs-1 text-primary mb-3"><i class="bi-megaphone-fill"></i></div>
                        <h4 class="card-title fw-bold">공지사항</h4>
                        
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body p-4 text-center">
                        <div class="fs-1 text-success mb-3"><i class="bi-cart-check-fill"></i></div>
                        <h4 class="card-title fw-bold">포인트샵으로 이동</h4>
                        <p class="card-text text-muted mt-3">
                            동아리 활동으로 얻은 포인트로 <br>
                            다양한 상품을 구매해보세요!
                        </p>
                        <a href="${pageContext.request.contextPath}/shop.jsp" class="btn btn-outline-success mt-2 btn-sm">이동하기</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body p-4 text-center">
                        <div class="fs-1 text-warning mb-3"><i class="bi-trophy-fill"></i></div>
                        <h4 class="card-title fw-bold">정규 내전</h4>
                    
                    </div>
                </div>
            </div>
        </div>
    </section>


    <footer class="py-4 bg-dark mt-auto">
        <div class="container text-center text-white">
            <p class="m-0 small">Copyright &copy; KATHENA Club 2025. All Rights Reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>