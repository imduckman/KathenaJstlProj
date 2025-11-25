<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ItemDAO, dto.ItemDTO"%>
<%
    // 수정할 상품 ID 받아서 정보 가져오기
    int id = Integer.parseInt(request.getParameter("id"));
    ItemDAO dao = ItemDAO.getInstance();
    ItemDTO item = dao.getItem(id);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-5">
    <div class="container bg-white p-5 rounded shadow" style="max-width: 600px;">
        <h3 class="mb-4">🛠️ 상품 정보 수정</h3>
        <form action="adminItemUpdateAction.jsp" method="post">
            <input type="hidden" name="id" value="<%=item.getItemId()%>">
            
            <div class="mb-3">
                <label>상품명</label>
                <input type="text" name="name" value="<%=item.getName()%>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>가격</label>
                <input type="number" name="price" value="<%=item.getPrice()%>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>재고</label>
                <input type="number" name="stock" value="<%=item.getStock()%>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>이미지 URL</label>
                <input type="text" name="imageUrl" value="<%=item.getImageUrl()%>" class="form-control">
            </div>
            <div class="mb-3">
                <label>설명</label>
                <textarea name="desc" class="form-control" rows="3"><%=item.getDescription()%></textarea>
            </div>
            <button type="submit" class="btn btn-primary w-100">수정 완료</button>
            <a href="shop.jsp" class="btn btn-secondary w-100 mt-2">취소</a>
        </form>
    </div>
</body>
</html>