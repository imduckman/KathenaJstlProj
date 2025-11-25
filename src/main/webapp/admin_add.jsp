<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dto.MemberDTO"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%
    // 1. 관리자 권한 체크 (보안)
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.getRole().equals("ADMIN")) {
%>
    <script>
        alert("관리자만 접근 가능합니다.");
        location.href = "${pageContext.request.contextPath}/main.jsp";
    </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 상품 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <nav class="navbar navbar-light bg-light mb-4">
        <div class="container">
            <a class="navbar-brand" href="main.jsp">KATHENA Admin</a>
            <a href="main.jsp" class="btn btn-outline-secondary">메인으로</a>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-dark text-white">
                        <h4 class="mb-0">📦 새 상품 등록</h4>
                    </div>
                    <div class="card-body">
                        <form action="adminAddAction.jsp" method="post">
                            <div class="mb-3">
                                <label class="form-label">상품명</label>
                                <input type="text" name="name" class="form-control" required>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">가격 (Point)</label>
                                    <input type="number" name="price" class="form-control" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">재고 수량</label>
                                    <input type="number" name="stock" class="form-control" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">이미지 URL (인터넷 이미지 주소)</label>
                                <input type="text" name="imageUrl" class="form-control" placeholder="https://example.com/image.jpg">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">상품 설명</label>
                                <textarea name="desc" class="form-control" rows="3"></textarea>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg">상품 등록하기</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>