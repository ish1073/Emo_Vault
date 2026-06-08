<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alerts & Notifications - EmoVault</title>
    <link rel="stylesheet" href="css/design-system.css">
    <style>
        .emotion-layout {
            display: flex;
            min-height: 100vh;
            background: var(--color-cream);
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 40px 20px;
            overflow-y: auto;
        }

        .emotion-container {
            max-width: 700px;
            margin: 0 auto;
        }

        .emotion-card {
            background: white;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #443C5E;
            font-size: 1.8rem;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #777;
            font-size: 0.95rem;
            margin-bottom: 20px;
        }

        .alert-counter {
            display: flex;
            gap: 16px;
            margin-bottom: 20px;
        }

        .counter-box {
            background: white;
            padding: 16px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            flex: 1;
        }

        .counter-box .number {
            font-size: 1.8rem;
            font-weight: bold;
            color: #679F9F;
        }

        .counter-box .label {
            font-size: 0.85rem;
            color: #777;
            text-transform: uppercase;
            margin-top: 4px;
        }

        .alert-item {
            background: white;
            border: 2px solid #E6D4BF;
            border-left: 6px solid #679F9F;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
            transition: all 0.3s;
        }

        .alert-item:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .alert-item.unread {
            background: #FFFBF7;
        }

        .alert-item.high-priority {
            border-left-color: #E18299;
            background: #FFF5F7;
        }

        .alert-item.medium-priority {
            border-left-color: #F5B977;
        }

        .alert-item.low-priority {
            border-left-color: #2D4729;
        }

        .alert-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 8px;
        }

        .alert-title {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-icon {
            font-size: 1.3rem;
        }

        .alert-title h3 {
            color: #443C5E;
            margin: 0;
            font-size: 1rem;
        }

        .alert-time {
            color: #999;
            font-size: 0.85rem;
        }

        .alert-priority {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .priority-high {
            background: #E18299;
            color: white;
        }

        .priority-medium {
            background: #F5B977;
            color: white;
        }

        .priority-low {
            background: #2D4729;
            color: white;
        }

        .alert-message {
            color: #555;
            font-size: 0.95rem;
            margin: 12px 0;
            line-height: 1.5;
        }

        .alert-actions {
            display: flex;
            gap: 8px;
            margin-top: 12px;
        }

        .alert-btn {
            padding: 6px 12px;
            border: 1px solid #E6D4BF;
            background: white;
            color: #443C5E;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .alert-btn:hover {
            background: #F5F0EB;
            border-color: #443C5E;
        }

        .alert-btn.primary {
            background: #679F9F;
            color: white;
            border-color: #679F9F;
        }

        .alert-btn.primary:hover {
            background: #5A8A8A;
        }

        .no-alerts {
            background: #F5F0EB;
            padding: 32px;
            border-radius: 8px;
            text-align: center;
            color: #443C5E;
        }

        .no-alerts .icon {
            font-size: 2.5rem;
            margin-bottom: 12px;
        }

        .no-alerts p {
            font-size: 0.95rem;
            color: #777;
        }
    </style>
</head>
<body>
    <div class="emotion-layout">
        <!-- Sidebar -->
        <% request.setAttribute("currentPage", "alerts"); %>
        <%@ include file="components/sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="emotion-container">
                <h1>Alerts & Notifications</h1>
                <p class="subtitle">Real-time notifications based on your emotional state and activity patterns</p>

                <!-- Alert Counters -->
                <div class="alert-counter">
                    <div class="counter-box">
                        <div class="number">${not empty alertCount ? alertCount : 0}</div>
                        <div class="label">Total Alerts</div>
                    </div>
                    <div class="counter-box">
                        <div class="number">${not empty unreadCount ? unreadCount : 0}</div>
                        <div class="label">Unread</div>
                    </div>
                </div>

                <!-- Display Alerts -->
                <c:if test="${empty alerts}">
                    <div class="no-alerts">
                        <div class="icon">🔔</div>
                        <h3>No Alerts Right Now</h3>
                        <p>Your emotional patterns are stable. Keep maintaining your habits!</p>
                    </div>
                </c:if>

                <c:forEach var="alert" items="${alerts}">
                    <div class="alert-item 
                        ${alert.priority == 'HIGH' ? 'high-priority' : alert.priority == 'MEDIUM' ? 'medium-priority' : 'low-priority'} 
                        ${!alert.is_read ? 'unread' : ''}">
                        
                        <div class="alert-header">
                            <div class="alert-title">
                                <span class="alert-icon">${not empty alert.icon ? alert.icon : 'ℹ️'}</span>
                                <div>
                                    <h3>${not empty alert.title ? alert.title : 'Notification'}</h3>
                                    <c:if test="${not empty alert.formattedDate}">
                                        <div class="alert-time">
                                            ${alert.formattedDate}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <span class="alert-priority 
                                ${alert.priority == 'HIGH' ? 'priority-high' : alert.priority == 'MEDIUM' ? 'priority-medium' : 'priority-low'}">
                                ${not empty alert.priority ? alert.priority : 'LOW'}
                            </span>
                        </div>

                        <p class="alert-message">${not empty alert.message ? alert.message : ''}</p>

                        <c:if test="${not empty alert.actionUrl}">
                            <div class="alert-actions">
                                <a href="${alert.actionUrl}" class="alert-btn primary">Take Action</a>
                                <c:if test="${!alert.is_read && not empty alert.alert_id}">
                                    <button class="alert-btn" onclick="markAsRead('${alert.alert_id}')">Dismiss</button>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script>
        function markAsRead(alertId) {
            fetch('<%=request.getContextPath()%>/Alerts', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=mark_read&alert_id=' + alertId
            }).then(response => {
                // Reload page to show updated state
                location.reload();
            }).catch(error => {
                console.error('Error marking alert as read:', error);
                location.reload();
            });
        }
    </script>
</body>
</html>