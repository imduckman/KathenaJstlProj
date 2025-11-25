<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 세션 정보 삭제 (로그아웃)
    session.invalidate();
    
    // 메인 페이지로 다시 이동
    response.sendRedirect("main.jsp");
%>