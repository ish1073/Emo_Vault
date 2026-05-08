<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Invalidate the session to clear all user data
    session.invalidate();
    
    // Redirect to the landing page
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
