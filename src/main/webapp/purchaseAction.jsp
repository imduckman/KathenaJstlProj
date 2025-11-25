<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.PurchaseDAO"%>
<%@ page import="dao.ItemDAO"%>
<%@ page import="dto.MemberDTO"%>
<%@ page import="dto.ItemDTO"%>
<%@ page import="java.util.List"%>

<%
    // 1. 로그인 체크 (로그인 안 된 사람이 주소 치고 들어오는 것 방지)
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "login.jsp";
    </script>
<%
        return;
    }

    // 2. 넘어온 상품 번호(itemId) 받기
    String itemIdStr = request.getParameter("itemId");
    if (itemIdStr == null) {
        response.sendRedirect("shop.jsp");
        return;
    }
    int itemId = Integer.parseInt(itemIdStr);

    // 3. 상품 정보 가져오기 (가격을 알기 위해)
    // (ItemDAO에 getOneItem 메소드가 없어서 리스트에서 찾거나 새로 만들어야 하는데,
    //  간단하게 리스트에서 찾는 방식으로 할게요)
    ItemDAO itemDao = ItemDAO.getInstance();
    List<ItemDTO> itemList = itemDao.getAllItems();
    ItemDTO targetItem = null;
    
    for(ItemDTO item : itemList) {
        if(item.getItemId() == itemId) {
            targetItem = item;
            break;
        }
    }

    // 4. 구매 가능 여부 검사
    if (targetItem == null) {
        %> <script>alert("존재하지 않는 상품입니다."); history.back();</script> <%
    } else if (targetItem.getStock() <= 0) {
        %> <script>alert("재고가 부족합니다."); history.back();</script> <%
    } else if (loginUser.getPoint() < targetItem.getPrice()) {
        %> <script>alert("포인트가 부족합니다!"); history.back();</script> <%
    } else {
        // 5. 모든 조건 통과 -> 구매 진행 (DAO 호출)
        PurchaseDAO purchaseDao = PurchaseDAO.getInstance();
        boolean isSuccess = purchaseDao.purchaseItem(loginUser.getMemberId(), itemId, targetItem.getPrice());
        
        if (isSuccess) {
            // ★ 중요: DB는 업데이트됐지만, 현재 로그인된 세션 정보(loginUser)의 포인트는 옛날 값임.
            // 세션 정보도 업데이트해줘야 화면에 바로 반영됨.
            loginUser.setPoint(loginUser.getPoint() - targetItem.getPrice());
            
            %>
            <script>
                alert("구매가 완료되었습니다!");
                location.href = "shop.jsp";
            </script>
            <%
        } else {
            %> <script>alert("구매 처리 중 오류가 발생했습니다."); history.back();</script> <%
        }
    }
%>