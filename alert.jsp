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
    <title>Alerts - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        .alerts-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-title {
            color: var(--color-text-dark);
            font-size: 28px;
            font-weight: 600;
            margin: 0;
        }

        .badge {
            background: var(--color-candy);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }

        .filter-btn {
            padding: 8px 16px;
            border: 2px solid var(--color-viridian);
            background: white;
            color: var(--color-viridian);
            border-radius: var(--radius-sm);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-normal);
        }

        .filter-btn.active {
            background: var(--color-viridian);
            color: white;
        }

        .filter-btn:hover {
            background: var(--color-sage);
            color: white;
        }

        .alerts-list {
            display: grid;
            gap: 15px;
        }

        .alert-card {
            background: var(--color-honey);
            border-left: 5px solid var(--color-blush);
            padding: 20px;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            transition: all var(--transition-normal);
        }

        .alert-card.unread {
            background: #FFFAF2;
            border-left-color: var(--color-sage);
        }

        .alert-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .alert-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 12px;
        }

        .alert-type {
            display: inline-block;
            background: var(--color-sage);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .alert-message {
            color: var(--text-dark);
            font-size: 15px;
            line-height: 1.5;
            margin: 12px 0;
        }

        .alert-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #999;
            font-size: 13px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
        }

        .alert-actions {
            display: flex;
            gap: 10px;
        }

        .btn-read,
        .btn-delete {
            padding: 6px 12px;
            border: none;
            border-radius: var(--radius-sm);
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-normal);
        }

        .btn-read {
            background: var(--color-sage);
            color: white;
        }

        .btn-read:hover {
            background: #999b6e;
        }

        .btn-delete {
            background: #ddd;
            color: var(--text-dark);
        }

        .btn-delete:hover {
            background: #ccc;
        }

        .severity-high {
            color: #d9534f;
        }

        .severity-medium {
            color: #f0ad4e;
        }

        .severity-low {
            color: var(--color-sage);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: var(--radius-sm);
            margin-bottom: 20px;
            border-left: 4px solid #c33;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div class="navbar-brand">💝 EmoVault</div>
        <div class="navbar-menu">
            <a href="<%= request.getContextPath() %>/emotion.jsp">Emotions</a>
            <a href="<%= request.getContextPath() %>/diary">Diary</a>
            <a href="<%= request.getContextPath() %>/regret">Regrets</a>
            <a href="<%= request.getContextPath() %>/habit">Habits</a>
            <a href="<%= request.getContextPath() %>/alert" class="active">Alerts</a>
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <span style="color: var(--color-text-dark); font-size: var(--font-size-sm);">
                Welcome, <strong><%= userName %></strong>
            </span>
            <a href="javascript:void(0)" onclick="logout()" style="color: var(--color-error);">Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="alerts-container">
        <div class="page-header">
            <h1 class="page-title">⚠️ Behavioral Alerts</h1>
            <% if (unreadCount > 0) { %>
                <div class="badge"><%= unreadCount %> unread</div>
            <% } %>
        </div>

        <!-- Filter Buttons -->
        <div class="filter-buttons">
            <a href="<%= request.getContextPath() %>/alert?view=unread">
                <button class="filter-btn active">Unread Only</button>
            </a>
            <a href="<%= request.getContextPath() %>/alert?view=all">
                <button class="filter-btn">All Alerts</button>
            </a>
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
                                String severityClass = "severity-low";
                                if (alert.getSeverity() >= 4) {
                                    severityClass = "severity-high";
                                } else if (alert.getSeverity() >= 2) {
                                    severityClass = "severity-medium";
                                }
                            %>
                            <span class="<%= severityClass %>">Severity: <%= alert.getSeverity() %>/5</span>
                        </div>

                        <p class="alert-message"><%= alert.getMessage() %></p>

                        <div class="alert-meta">
                            <span><%= new java.text.SimpleDateFormat("MMM dd, yyyy hh:mm a").format(alert.getCreatedDate()) %></span>
                            <div class="alert-actions">
                                <% if (!alert.isRead()) { %>
                                    <form method="POST" action="<%= request.getContextPath() %>/alert" style="display: inline;">
                                        <input type="hidden" name="action" value="read">
                                        <input type="hidden" name="alertId" value="<%= alert.getAlertId() %>">
                                        <button type="submit" class="btn-read">Mark as Read</button>
                                    </form>
                                <% } %>
                                
                                <form method="POST" action="<%= request.getContextPath() %>/alert" style="display: inline;"
                                      onsubmit="return confirm('Delete this alert?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="alertId" value="<%= alert.getAlertId() %>">
                                    <button type="submit" class="btn-delete">🗑 Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
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
