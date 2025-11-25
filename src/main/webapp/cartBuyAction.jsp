<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CartDAO, dao.PurchaseDAO, dto.CartDTO, dto.MemberDTO, java.util.List"%>

<%
    // 1. 로그인 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) { response.sendRedirect("login.jsp"); return; }

    // 2. 장바구니 목록 가져오기
    CartDAO cartDao = CartDAO.getInstance();
    List<CartDTO> cartList = cartDao.getCartList(loginUser.getMemberId());
    
    if(cartList.isEmpty()) {
        %> <script>alert("장바구니가 비어있습니다."); history.back();</script> <%
        return;
    }

    // 3. 총 가격 계산
    int totalPrice = 0;
    for(CartDTO c : cartList) totalPrice += c.getItemPrice();

    // 4. 포인트 부족 확인
    if(loginUser.getPoint() < totalPrice) {
        %> <script>alert("포인트가 부족하여 전체 구매를 할 수 없습니다."); history.back();</script> <%
        return;
    }

    // 5. 구매 진행 (반복문으로 하나씩 구매 처리)
    PurchaseDAO purchaseDao = PurchaseDAO.getInstance();
    int successCount = 0;

    for(CartDTO c : cartList) {
        // purchaseItem 메소드 재사용 (회원ID, 상품ID, 가격)
        // 주의: 여기서 포인트가 계속 차감되므로, 위에서 미리 계산한 총액으로 한 번에 뺄지,
        // 아니면 하나씩 뺄지 결정해야 하는데, 기존 PurchaseDAO는 하나씩 뺍니다.
        // ★ 중요: PurchaseDAO가 트랜잭션 처리가 되어 있어 하나씩 구매해도 안전합니다.
        
        boolean isSuccess = purchaseDao.purchaseItem(loginUser.getMemberId(), c.getItemId(), c.getItemPrice());
        if(isSuccess) successCount++;
    }

    // 6. 장바구니 비우기 및 세션 업데이트
    if(successCount > 0) {
        cartDao.clearCart(loginUser.getMemberId());
        loginUser.setPoint(loginUser.getPoint() - totalPrice); // 화면 갱신용 세션 업데이트
        %>
        <script>
            alert("총 <%=successCount%>건의 상품 구매가 완료되었습니다!");
            location.href = "mypage.jsp";
        </script>
        <%
    } else {
        %> <script>alert("구매 처리에 실패했습니다."); history.back();</script> <%
    }
%>