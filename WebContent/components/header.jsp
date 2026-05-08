<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) {
        pageTitle = "EmoVault";
    }
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        userName = "User";
    }
%>

<header class="header">
    <h1 class="header-title"><%= pageTitle %></h1>
    <div class="header-user">
        <span style="color: var(--color-azur);">Hello, <strong><%= userName %></strong>!</span>
        <div class="user-avatar">
            <%= userName.length() > 0 ? userName.charAt(0) : "U" %>
        </div>
    </div>
</header>
