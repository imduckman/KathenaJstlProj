<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CartDAO"%>
<%
    int cartId = Integer.parseInt(request.getParameter("cartId"));
    CartDAO.getInstance().deleteCart(cartId);
    response.sendRedirect("cart.jsp");
%>