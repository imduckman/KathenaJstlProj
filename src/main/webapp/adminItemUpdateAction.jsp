<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ItemDAO, dto.ItemDTO"%>

<%
    // 1. 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    // 2. 관리자 체크 (필수)
    dto.MemberDTO loginUser = (dto.MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.getRole().equals("ADMIN")) {
        %> <script>alert("관리자 권한이 없습니다."); location.href="main.jsp";</script> <%
        return;
    }

    try {
        // 3. 데이터 수신 확인 (이클립스 콘솔창을 확인하세요!)
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String imageUrl = request.getParameter("imageUrl");
        String desc = request.getParameter("desc");

        System.out.println("=== [상품 수정 디버깅] ===");
        System.out.println("ID: " + idStr);
        System.out.println("Name: " + name);
        System.out.println("Price: " + priceStr);
        
        // 4. 유효성 검사 (값이 비어있으면 튕겨내기)
        if(idStr == null || name == null || priceStr == null) {
            %> <script>alert("필수 입력값이 누락되었습니다."); history.back();</script> <%
            return;
        }

        // 5. 숫자 변환
        int id = Integer.parseInt(idStr);
        int price = Integer.parseInt(priceStr);
        int stock = Integer.parseInt(stockStr);

        // 6. DTO 담기
        ItemDTO item = new ItemDTO();
        item.setItemId(id);
        item.setName(name);
        item.setPrice(price);
        item.setStock(stock);
        item.setImageUrl(imageUrl);
        item.setDescription(desc);

        // 7. DAO 실행
        int result = ItemDAO.getInstance().updateItem(item);
        
        System.out.println("수정 결과(result): " + result); // 1이면 성공, 0이면 실패

        // 8. 결과 처리
        if(result > 0) {
            %>
            <script>
                alert("상품 정보가 성공적으로 수정되었습니다.");
                location.href = "shop.jsp";
            </script>
            <%
        } else {
            %>
            <script>
                alert("수정 실패! 데이터베이스 오류이거나 해당 ID가 없습니다.");
                history.back();
            </script>
            <%
        }

    } catch (NumberFormatException e) {
        // 숫자가 아닌 문자가 들어왔을 때 (예: 가격에 '천원' 입력함)
        e.printStackTrace();
        %>
        <script>
            alert("가격이나 재고는 숫자만 입력해야 합니다.");
            history.back();
        </script>
        <%
    } catch (Exception e) {
        e.printStackTrace();
        %>
        <script>
            alert("시스템 오류 발생: <%=e.getMessage()%>");
            history.back();
        </script>
        <%
    }
%>