<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.PurchaseDAO"%>
<%@ page import="dto.PurchaseDTO"%>
<%@ page import="dto.MemberDTO"%>
<%@ page import="java.util.List"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%
    // 1. 로그인 체크 (필수)
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. 이 사람의 구매 목록 가져오기
    PurchaseDAO dao = PurchaseDAO.getInstance();
    List<PurchaseDTO> myHistory = dao.getPurchaseList(loginUser.getMemberId());
    
    request.setAttribute("myHistory", myHistory);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 구매 내역</title>
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

    <div class="container">
        <h2>🧾 내 구매 내역</h2>
        <p><b>${sessionScope.loginUser.name}</b>님의 현재 잔액: 
           <span style="color: blue; font-weight: bold; font-size: 1.2em;">
               <fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> P
           </span>
        </p>
        
        <table>
            <thead>
                <tr>
                    <th>구매일시</th>
                    <th>상품명</th>
                    <th>결제 포인트</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="history" items="${myHistory}">
                    <tr>
                        <td class="date-col">
                            <fmt:formatDate value="${history.purchaseDate}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>
                        <td style="text-align: left; padding-left: 20px;">
                            ${history.itemName}
                        </td>
                        <td class="price-col">
                            -<fmt:formatNumber value="${history.purchasePoint}" pattern="#,###"/> P
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty myHistory}">
            <div class="empty-msg">
                아직 구매한 상품이 없습니다.<br>
                <a href="shop.jsp" style="color: blue;">상점으로 가기</a>
            </div>
        </c:if>
    </div>

</body>
</html>