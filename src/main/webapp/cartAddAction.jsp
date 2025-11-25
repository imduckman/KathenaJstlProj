<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CartDAO"%>
<%@ page import="dto.MemberDTO"%>

<%
    // 1. 로그인 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        %> <script>alert("로그인이 필요합니다."); location.href="login.jsp";</script> <%
        return;
    }

    // 2. 상품 번호 받기
    int itemId = Integer.parseInt(request.getParameter("itemId"));

    // 3. 장바구니에 넣기
    CartDAO dao = CartDAO.getInstance();
    int result = dao.addToCart(loginUser.getMemberId(), itemId);

    if(result > 0) {
        %>
        <script>
            if(confirm("장바구니에 담았습니다. 확인하러 가시겠습니까?")) {
                location.href = "cart.jsp";
            } else {
                history.back(); // 쇼핑 계속하기
            }
        </script>
        <%
    } else {
        %> <script>alert("장바구니 담기 실패!"); history.back();</script> <%
    }
%>