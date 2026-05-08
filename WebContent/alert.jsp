<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.Alert" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Alert> alerts = (List<Alert>) request.getAttribute("alerts");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .alert-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--space-2xl);
            display: flex;
            flex-direction: column;
            transition: margin-left 0.3s ease-in-out, width 0.3s ease-in-out;
        }

        .alert-section {
            margin-bottom: var(--space-3xl);
            animation: fade-in-up 0.6s ease-out;
        }

        .section-header {
            margin-bottom: var(--space-xl);
        }

        .section-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
        }

        .section-subtitle {
            font-size: var(--font-size-base);
            color: var(--color-warm-gray);
        }

        .alerts-list {
            display: flex;
            flex-direction: column;
            gap: var(--space-lg);
        }

        .alert-item {
            background: var(--color-white);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: var(--shadow-md);
            border-left: 4px solid var(--color-candy);
            transition: all var(--transition-base);
            animation: fade-in-up 0.6s ease-out;
        }

        .alert-item:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .alert-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: var(--space-md);
        }

        .alert-type {
            display: inline-block;
            background: rgba(225, 130, 153, 0.1);
            color: var(--color-candy);
            padding: var(--space-sm) var(--space-md);
            border-radius: var(--radius-md);
            font-size: var(--font-size-xs);
            font-weight: var(--font-weight-semibold);
        }

        .alert-time {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
        }

        .alert-message {
            color: var(--color-azur);
            font-size: var(--font-size-base);
            line-height: var(--line-height-normal);
            margin-bottom: var(--space-md);
        }

        .alert-action {
            font-size: var(--font-size-sm);
        }

        .alert-action a {
            color: var(--color-viridian);
            text-decoration: none;
            font-weight: var(--font-weight-medium);
            transition: all var(--transition-base);
        }

        .alert-action a:hover {
            text-decoration: underline;
        }

        .no-alerts {
            text-align: center;
            padding: var(--space-3xl);
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            color: var(--color-warm-gray);
            box-shadow: var(--shadow-md);
        }

        .no-alerts h3 {
            color: var(--color-heather);
            font-size: var(--font-size-lg);
            margin: var(--space-lg) 0 var(--space-sm) 0;
        }

        .no-alerts p {
            font-size: var(--font-size-base);
            margin-bottom: 0;
        }

        .no-alerts-icon {
            font-size: var(--font-size-4xl);
            margin-bottom: var(--space-lg);
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }
        }
    </style>
</head>
<body>
    <div class="alert-layout">
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="alert" />
        </jsp:include>

        <div class="main-content">
            <div class="alert-section">
                <div class="section-header">
                    <h1 class="section-title">🔔 Notifications</h1>
                    <p class="section-subtitle">Stay informed about your emotional wellness journey</p>
                </div>

                <% if (alerts != null && !alerts.isEmpty()) { %>
                    <div class="alerts-list">
                        <% for (Alert alert : alerts) { %>
                            <div class="alert-item">
                                <div class="alert-header">
                                    <div>
                                        <span class="alert-type"><%= alert.getAlertType() != null ? alert.getAlertType() : "General" %></span>
                                    </div>
                                    <div class="alert-time"><%= dateFormat.format(alert.getCreatedDate()) %></div>
                                </div>
                                <div class="alert-message"><%= alert.getMessage() %></div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="no-alerts">
                        <div class="no-alerts-icon">🌟</div>
                        <h3>All caught up!</h3>
                        <p>You don't have any notifications right now</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
