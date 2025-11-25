<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDAO"%>
<%
    // 관리자 권한 체크
    dto.MemberDTO loginUser = (dto.MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.getRole().equals("ADMIN")) {
        response.sendRedirect("main.jsp");
        return;
    }

    String id = request.getParameter("id");
    // 관리자 자신은 삭제 못하게 막음
    if(id.equals(loginUser.getMemberId())) {
        %> <script>alert("관리자 본인은 삭제할 수 없습니다."); history.back();</script> <%
    } else {
        MemberDAO.getInstance().deleteMember(id);
        response.sendRedirect("admin_member_list.jsp");
    }
%>