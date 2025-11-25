<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDAO"%>
<%@ page import="dto.MemberDTO"%>

<%
    // 1. 관리자 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.getRole().equals("ADMIN")) {
        response.sendRedirect("main.jsp");
        return;
    }

    // 2. 데이터 받기
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    String amountStr = request.getParameter("amount");
    
    if(id != null && amountStr != null) {
        int amount = Integer.parseInt(amountStr);
        
        // 3. DAO 호출
        MemberDAO dao = MemberDAO.getInstance();
        int result = dao.updatePoint(id, amount);
        
        // 4. 관리자 본인의 포인트가 변경되었을 경우 세션도 업데이트 (화면 갱신용)
        if(id.equals(loginUser.getMemberId())) {
            loginUser.setPoint(loginUser.getPoint() + amount);
        }
        
        if(result > 0) {
%>
            <script>
                alert("포인트가 정상적으로 변경되었습니다.");
                location.href = "admin_member_list.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("변경 실패!");
                history.back();
            </script>
<%
        }
    } else {
        response.sendRedirect("admin_member_list.jsp");
    }
%>