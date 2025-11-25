<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.ItemDAO"%>
<%@ page import="dto.ItemDTO"%>
<%@ page import="java.util.List"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
// 1. DB에서 상품 목록 가져오기
ItemDAO dao = ItemDAO.getInstance();
List<ItemDTO> itemList = dao.getAllItems();

// 2. JSTL이 사용할 수 있게 request 영역에 저장
request.setAttribute("itemList", itemList);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KATHENA - 포인트 상점</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>KATHENA</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/custom.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
</head>
<body>

	<header>
		<nav
			class="navbar navbar-expand-lg navbar-light bg-light mb-4 border-bottom">
			<div class="container px-4 px-lg-5">
				<a class="navbar-brand fw-bold"
					href="${pageContext.request.contextPath}/main.jsp">KATHENA</a>

				<button class="navbar-toggler" type="button"
					data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">
					<span class="navbar-toggler-icon"></span>
				</button>

				<div class="collapse navbar-collapse" id="navbarSupportedContent">
					<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
						<li class="nav-item"><a class="nav-link"
							href="${pageContext.request.contextPath}/main.jsp">Home</a></li>
						<li class="nav-item"><a class="nav-link"
							href="${pageContext.request.contextPath}/shop.jsp">Shop</a></li>
					</ul>

					<div class="d-flex">
						<c:choose>
							<c:when test="${empty sessionScope.loginUser}">
								<a href="${pageContext.request.contextPath}/login.jsp"
									class="btn btn-outline-dark me-2">Login</a>
								<a href="${pageContext.request.contextPath}/join.jsp"
									class="btn btn-primary">Join</a>
							</c:when>
							<c:otherwise>
								<div class="d-flex align-items-center me-3">
									<span class="me-2">Hello, <b>${sessionScope.loginUser.name}</b></span>
									<span class="badge bg-secondary">${sessionScope.loginUser.point}
										P</span>
								</div>
								<a href="${pageContext.request.contextPath}/mypage.jsp"
									class="btn btn-outline-dark me-2 btn-sm">My</a>
								<a href="${pageContext.request.contextPath}/logoutAction.jsp"
									class="btn btn-danger btn-sm">Logout</a>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</nav>
	</header>

	<section class="container pb-5">
		<div
			class="row gx-4 gx-lg-5 row-cols-1 row-cols-md-3 row-cols-xl-4 justify-content-center">

			<c:forEach var="item" items="${itemList}">
				<div class="col mb-5">
					<div class="card h-100 shadow-sm">
						<c:if test="${item.stock <= 0}">
							<div class="badge bg-danger text-white position-absolute"
								style="top: 0.5rem; right: 0.5rem">Sold Out</div>
						</c:if>

						<img class="card-img-top"
							src="${empty item.imageUrl ? 'https://dummyimage.com/450x300/dee2e6/6c757d.jpg' : item.imageUrl}"
							alt="${item.name}" />

						<div class="card-body p-4">
							<div class="text-center">
								<h5 class="fw-bolder text-dark">${item.name}</h5>
								<p class="text-muted small text-truncate-2">${item.description}</p>
								<div class="mb-3">
									<span class="text-primary fw-bold fs-5"> <fmt:formatNumber
											value="${item.price}" pattern="#,###" /> P
									</span>
									<div class="text-secondary small mt-1">남은 수량:
										${item.stock}개</div>
								</div>
							</div>
						</div>

						<div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
							<div class="d-grid gap-2">
								<c:choose>
									<c:when test="${item.stock > 0}">
										<c:if test="${not empty sessionScope.loginUser}">
											<div class="btn-group w-100">
												<a class="btn btn-primary"
													href="cartAddAction.jsp?itemId=${item.itemId}"> <i
													class="bi-cart-plus"></i> 담기
												</a> <a class="btn btn-outline-dark"
													href="purchaseAction.jsp?itemId=${item.itemId}"
													onclick="return confirm('바로 구매하시겠습니까?');"> 구매 </a>
											</div>
										</c:if>
										<c:if test="${empty sessionScope.loginUser}">
											<a class="btn btn-secondary" href="login.jsp">로그인 필요</a>
										</c:if>
									</c:when>
									<c:otherwise>
										<button class="btn btn-outline-danger" disabled>품절</button>
									</c:otherwise>
								</c:choose>

								<c:if test="${sessionScope.loginUser.role == 'ADMIN'}">
									<div class="btn-group mt-2">
										<a href="admin_item_edit.jsp?id=${item.itemId}"
											class="btn btn-warning btn-sm"> <i
											class="bi-pencil-square"></i> 수정
										</a> <a href="adminItemDeleteAction.jsp?id=${item.itemId}"
											class="btn btn-danger btn-sm"
											onclick="return confirm('정말 삭제하시겠습니까?');"> <i
											class="bi-trash-fill"></i> 삭제
										</a>
									</div>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
			<c:if test="${empty itemList}">
				<div class="col-12 text-center py-5">
					<div class="fs-1 text-muted mb-3">
						<i class="bi-box-seam"></i>
					</div>
					<p class="text-muted fs-5">등록된 상품이 없습니다.</p>
				</div>
			</c:if>

		</div>
	</section>

	<footer class="py-5 bg-dark">
		<div class="container">
			<p class="m-0 text-center text-white">Copyright &copy; KATHENA
				Club 2025</p>
		</div>
	</footer>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>