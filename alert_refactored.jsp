<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.Alert" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Alert> alerts = (List<Alert>) request.getAttribute("alerts");
    if (alerts == null) {
        alerts = new java.util.ArrayList<>();
    }
    
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (unreadCount == null) {
        unreadCount = 0;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Behavioral Alerts - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: linear-gradient(135deg, var(--color-peach-blossom) 0%, var(--color-off-white) 100%);
            min-height: 100vh;
        }

        .navbar {
            background: rgba(243, 205, 159, 0.6);
            backdrop-filter: var(--backdrop-glass);
            border-bottom: 2px solid rgba(202, 168, 171, 0.2);
            padding: var(--spacing-lg) 0;
            position: sticky;
            top: 0;
            z-index: var(--z-sticky);
            animation: slideInDown 0.6s ease;
        }

        .navbar-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--spacing-lg);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            font-family: var(--font-serif);
            font-size: var(--font-h3);
            color: var(--color-plum-wine);
            font-weight: 700;
        }

        .navbar-menu {
            display: flex;
            gap: var(--spacing-xl);
            align-items: center;
        }

        .navbar-menu a {
            color: var(--color-stormy-blue);
            text-decoration: none;
            font-weight: 500;
            transition: all var(--transition-normal);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--radius-md);
        }

        .navbar-menu a:hover {
            background: rgba(106, 55, 78, 0.1);
            color: var(--color-plum-wine);
        }

        .page-wrapper {
            min-height: calc(100vh - 80px);
            padding: var(--spacing-xl);
        }

        .container-lg {
            max-width: 900px;
            margin: 0 auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-3xl);
            animation: fadeIn 0.6s ease;
        }

        .page-header h1 {
            font-family: var(--font-serif);
            font-size: var(--font-h2);
            color: var(--color-plum-wine);
        }

        .badge {
            background: var(--color-dusty-rose);
            color: white;
            padding: var(--spacing-sm) var(--spacing-lg);
            border-radius: var(--radius-2xl);
            font-size: 12px;
            font-weight: 600;
        }

        .alerts-list {
            display: grid;
            gap: var(--spacing-lg);
        }

        .alert-card {
            background: rgba(250, 232, 230, 0.6);
            backdrop-filter: var(--backdrop-glass);
            border-left: 4px solid var(--color-dusty-rose);
            padding: var(--spacing-2xl);
            border-radius: var(--radius-xl);
            border: 1px solid rgba(255, 255, 255, 0.6);
            box-shadow: var(--shadow-medium);
            transition: all var(--transition-normal);
            animation: slideInUp 0.6s ease;
        }

        .alert-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-large);
        }

        .alert-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--spacing-lg);
        }

        .alert-type {
            display: inline-block;
            background: var(--color-plum-wine);
            color: white;
            padding: var(--spacing-sm) var(--spacing-lg);
            border-radius: var(--radius-lg);
            font-size: 12px;
            font-weight: 600;
        }

        .alert-message {
            color: var(--color-text-dark);
            font-size: var(--font-body);
            line-height: var(--line-height-normal);
            margin-bottom: var(--spacing-lg);
        }

        .alert-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: var(--color-stormy-blue);
            font-size: var(--font-body-sm);
            padding-top: var(--spacing-lg);
            border-top: 1px solid rgba(202, 168, 171, 0.15);
        }

        .alert-actions {
            display: flex;
            gap: var(--spacing-md);
        }

        .btn-action {
            padding: var(--spacing-md) var(--spacing-lg);
            border: none;
            border-radius: var(--radius-lg);
            font-size: var(--font-body-sm);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-normal);
        }

        .btn-read {
            background: var(--color-plum-wine);
            color: white;
        }

        .btn-read:hover {
            background: linear-gradient(135deg, var(--color-plum-wine) 0%, #5A2D3E 100%);
            transform: translateY(-2px);
        }

        .btn-delete {
            background: rgba(184, 117, 122, 0.2);
            color: var(--color-danger);
        }

        .btn-delete:hover {
            background: rgba(184, 117, 122, 0.3);
            transform: translateY(-2px);
        }

        .empty-state {
            text-align: center;
            padding: var(--spacing-3xl);
            background: rgba(250, 232, 230, 0.6);
            backdrop-filter: var(--backdrop-glass);
            border-radius: var(--radius-xl);
            border: 1px solid rgba(255, 255, 255, 0.6);
            box-shadow: var(--shadow-medium);
            color: var(--color-stormy-blue);
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: var(--spacing-lg);
        }

        .empty-state p {
            font-size: var(--font-body);
            line-height: var(--line-height-normal);
        }

        @media (max-width: 768px) {
            .navbar-menu {
                flex-direction: column;
                gap: var(--spacing-lg);
            }

            .page-header {
                flex-direction: column;
                gap: var(--spacing-lg);
            }

            .alert-meta {
                flex-direction: column;
                gap: var(--spacing-md);
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">⚠️ Alerts</div>
            <div class="navbar-menu">
                <a href="${pageContext.request.contextPath}/emotion.jsp">Emotions</a>
                <a href="${pageContext.request.contextPath}/diary">Diary</a>
                <a href="${pageContext.request.contextPath}/alert">Alerts</a>
                <a href="javascript:void(0)" onclick="logout()">Logout</a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="page-wrapper">
        <div class="container-lg">
            <div class="page-header">
                <h1>⚠️ Behavioral Insights</h1>
                <% if (unreadCount > 0) { %>
                    <div class="badge"><%= unreadCount %> unread</div>
                <% } %>
            </div>

            <!-- Alerts List -->
            <% if (alerts.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">🎉</div>
                    <p>No alerts! Keep tracking your emotions and habits.</p>
                </div>
            <% } else { %>
                <div class="alerts-list">
                    <% for (Alert alert : alerts) { %>
                        <div class="alert-card <%= alert.isRead() ? "" : "unread" %>">
                            <div class="alert-header">
                                <span class="alert-type"><%= alert.getAlertType() %></span>
                                <% 
                                    String severityColor = "var(--color-success)";
                                    if (alert.getSeverity() >= 4) {
                                        severityColor = "var(--color-danger)";
                                    } else if (alert.getSeverity() >= 2) {
                                        severityColor = "var(--color-warning)";
                                    }
                                %>
                                <span style="color: <%= severityColor %>; font-weight: 600;">Severity: <%= alert.getSeverity() %>/5</span>
                            </div>

                            <p class="alert-message"><%= alert.getMessage() %></p>

                            <div class="alert-meta">
                                <span><%= new java.text.SimpleDateFormat("MMM dd, yyyy hh:mm a").format(alert.getCreatedDate()) %></span>
                                <div class="alert-actions">
                                    <% if (!alert.isRead()) { %>
                                        <form method="POST" action="${pageContext.request.contextPath}/alert" style="display: inline;">
                                            <input type="hidden" name="action" value="read">
                                            <input type="hidden" name="alertId" value="<%= alert.getAlertId() %>">
                                            <button type="submit" class="btn-action btn-read">Mark as Read</button>
                                        </form>
                                    <% } %>
                                    
                                    <form method="POST" action="${pageContext.request.contextPath}/alert" style="display: inline;"
                                          onsubmit="return confirm('Delete this alert?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="alertId" value="<%= alert.getAlertId() %>">
                                        <button type="submit" class="btn-action btn-delete">🗑 Delete</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logout.jsp';
            }
        }
    </script>
</body>
</html>
