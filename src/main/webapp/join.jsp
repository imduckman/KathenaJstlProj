<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 - KATHENA</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KATHENA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/custom.css" rel="stylesheet">  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<header>
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
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/shop.jsp">Point Shop</a></li>
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
	</header>
    <div align="center" style="padding-top: 50px;">
        <h2>📝 회원가입</h2>
        <hr width="300">
        
        <form action="joinAction.jsp" method="post">
            <table border="1" cellpadding="10" cellspacing="0">
                <tr>
                    <td bgcolor="#f1f1f1">아이디</td>
                    <td><input type="text" name="id" required placeholder="아이디 입력"></td>
                </tr>
                <tr>
                    <td bgcolor="#f1f1f1">비밀번호</td>
                    <td><input type="password" name="pw" required placeholder="비밀번호 입력"></td>
                </tr>
                <tr>
                    <td bgcolor="#f1f1f1">이름</td>
                    <td><input type="text" name="name" required placeholder="본명 입력"></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="가입하기" style="background-color: #007bff; color: white; border: none; padding: 10px 20px; cursor: pointer;">
                        <input type="button" value="취소" onclick="location.href='login.jsp'">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>