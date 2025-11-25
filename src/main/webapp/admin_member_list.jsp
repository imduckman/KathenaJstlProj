<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDAO"%>
<%@ page import="dto.MemberDTO"%>
<%@ page import="java.util.List"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<%
// 1. 관리자 체크
MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
if (loginUser == null || !loginUser.getRole().equals("ADMIN")) {
	response.sendRedirect("main.jsp");
	return;
}

// 2. 회원 목록 가져오기
MemberDAO dao = MemberDAO.getInstance();
List<MemberDTO> list = dao.getAllMembers();
request.setAttribute("memberList", list);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 회원 관리</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/custom.css"
	rel="stylesheet">
</head>
<body>

	<nav
		class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4">
		<div class="container">
			<a class="navbar-brand" href="main.jsp">KATHENA Admin</a> <a
				href="main.jsp" class="btn btn-outline-secondary">메인으로</a>
		</div>
	</nav>

	<div class="container">
		<h2 class="mb-4 fw-bold text-center">👥 회원 포인트 관리</h2>

		<div class="card shadow-sm">
			<div class="card-body">
				<div class="table-responsive">
					<table class="table table-hover align-middle text-center">
						<thead class="table-light">
							<tr>
								<th>아이디</th>
								<th>이름</th>
								<th>현재 포인트</th>
								<th>권한</th>
								<th width="350">포인트 조정 (+/-)</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="mem" items="${memberList}">
								<tr>
									<td>${mem.memberId}</td>
									<td class="fw-bold">${mem.name}</td>
									<td class="text-primary fw-bold"><fmt:formatNumber
											value="${mem.point}" pattern="#,###" /> P</td>
									<td><span
										class="badge ${mem.role == 'ADMIN' ? 'bg-danger' : 'bg-secondary'}">
											${mem.role} </span></td>
									<td>
										<form action="adminPointUpdate.jsp" method="post"
											class="d-flex justify-content-center gap-2">
											<input type="hidden" name="id" value="${mem.memberId}">

											<input type="number" name="amount"
												class="form-control form-control-sm"
												placeholder="예: 500 or -200" style="width: 150px;" required>

											<button type="submit" class="btn btn-sm btn-primary">적용</button>
										</form> <a href="adminMemberDeleteAction.jsp?id=${mem.memberId}"
										class="btn btn-sm btn-outline-danger ms-2"
										onclick="return confirm('${mem.name} 회원을 정말 추방하시겠습니까?');">
											추방 </a>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>