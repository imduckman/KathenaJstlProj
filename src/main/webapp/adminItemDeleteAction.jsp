<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ItemDAO"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    ItemDAO.getInstance().deleteItem(id);
    response.sendRedirect("shop.jsp");
%>