<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ItemDAO"%>
<%@ page import="dto.ItemDTO"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 입력값 받기
    String name = request.getParameter("name");
    int price = Integer.parseInt(request.getParameter("price"));
    int stock = Integer.parseInt(request.getParameter("stock"));
    String imageUrl = request.getParameter("imageUrl");
    String desc = request.getParameter("desc");
    
    // 이미지 주소 없으면 기본 이미지 넣기
    if(imageUrl == null || imageUrl.trim().equals("")) {
        imageUrl = "https://dummyimage.com/450x300/dee2e6/6c757d.jpg";
    }

    // DTO 포장
    ItemDTO item = new ItemDTO();
    item.setName(name);
    item.setPrice(price);
    item.setStock(stock);
    item.setImageUrl(imageUrl);
    item.setDescription(desc);
    
    // DAO 호출
    ItemDAO dao = ItemDAO.getInstance();
    int result = dao.insertItem(item);
    
    if(result > 0) {
%>
        <script>
            alert("상품이 등록되었습니다!");
            location.href = "shop.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("등록 실패! 입력값을 확인하세요.");
            history.back();
        </script>
<%
    }
%>