<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.time.*" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Sample demo alerts for now (will be replaced with database queries)
    class DemoAlert {
        public String id;
        public String type;
        public String priority;
        public String icon;
        public String title;
        public String message;
        public String actionUrl;
        public LocalDateTime createdAt;
        
        public DemoAlert(String id, String type, String priority, String icon, String title, String message, String actionUrl) {
            this.id = id;
            this.type = type;
            this.priority = priority;
            this.icon = icon;
            this.title = title;
            this.message = message;
            this.actionUrl = actionUrl;
            this.createdAt = LocalDateTime.now().minusMinutes((int)(Math.random() * 120));
        }
    }
    
    List<DemoAlert> alerts = new ArrayList<>();
    alerts.add(new DemoAlert("1", "TIME_SENSITIVE", "MEDIUM", "📬", "Time Capsule Ready", 
        "Your time capsule \"Recovery Plan\" from March 15, 2026 is ready to open!",
        "/EmoVault/timecapsule"));
    alerts.add(new DemoAlert("2", "EMOTIONAL_RISK", "HIGH", "⚠️", "High Stress Detected",
        "Your stress levels have been consistently high this week. Consider trying a coping strategy.",
        "/EmoVault/emotion"));
    alerts.add(new DemoAlert("3", "HABIT_DISRUPTION", "MEDIUM", "🔥", "Streak Broken",
        "Your 12-day meditation streak has been broken. Ready to start a new one?",
        "/EmoVault/habit"));
    alerts.add(new DemoAlert("4", "BEHAVIORAL_PATTERN", "MEDIUM", "📊", "Pattern Detected",
        "You've mentioned \"perfectionism stress\" 4 times this week. This might be worth exploring deeper.",
        "/EmoVault/diary"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Alerts</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/emovault-complete-ui.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .alerts-layout {
            display: flex;
            min-height: 100vh;
        }

        .alerts-main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--space-2xl);
            overflow-y: auto;
            transition: margin-left 0.3s ease-in-out;
        }
        
        .alerts-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .alerts-header {
            margin-bottom: 2.5rem;
        }
        
        .alerts-title {
            font-size: 2.5rem;
            color: #3D3D3D;
            font-weight: 700;
            margin-bottom: 0.5rem;
            font-family: var(--font-secondary);
        }
        
        .alerts-subtitle {
            color: #5C4B47;
            font-size: 1.1rem;
        }
        
        .alerts-list {
            margin-top: 2rem;
        }
        
        .alert-empty {
            background: #F5EBE8;
            border: 2px dashed #C4A29E;
            border-radius: 12px;
            padding: 3rem 2rem;
            text-align: center;
            color: #6B5B56;
        }
        
        .alert-empty-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        
        .alert-card {
            background: white;
            border-left: 4px solid;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .alert-card:hover {
            transform: translateX(8px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }
        
        .alert-critical { border-color: #D32F2F; }
        .alert-high { border-color: #F57C00; }
        .alert-medium { border-color: #FBC02D; }
        .alert-low { border-color: #1976D2; }
        
        .alert-icon {
            font-size: 2.5rem;
            flex-shrink: 0;
        }
        
        .alert-content {
            flex: 1;
        }
        
        .alert-type {
            font-size: 0.85rem;
            color: #6B5B56;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }
        
        .alert-title {
            font-size: 1.2rem;
            color: #2C2C2C;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .alert-message {
            color: #4A4A4A;
            line-height: 1.6;
            margin-bottom: 1rem;
            font-size: 0.95rem;
        }
        
        .alert-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .alert-btn {
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            text-decoration: none;
            display: inline-block;
        }
        
        .alert-btn-action {
            background: #BF7185;
            color: white;
        }
        
        .alert-btn-action:hover {
            background: #A55F72;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(191, 113, 133, 0.3);
        }
        
        .alert-btn-dismiss {
            background: transparent;
            color: #6B5B56;
            border: 1px solid #C4A29E;
        }
        
        .alert-btn-dismiss:hover {
            background: #F5EBE8;
            color: #2C2C2C;
            border-color: #8B7B76;
        }
        
        .alert-time {
            font-size: 0.85rem;
            color: #8B7B76;
            margin-top: 0.75rem;
        }
        
        .priority-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            margin-left: 0.5rem;
        }
        
        .priority-critical { background: rgba(211, 47, 47, 0.15); color: #C62828; }
        .priority-high { background: rgba(245, 124, 0, 0.15); color: #E65100; }
        .priority-medium { background: rgba(251, 192, 45, 0.15); color: #F57F17; }
        .priority-low { background: rgba(25, 118, 210, 0.15); color: #1565C0; }
        
        @media (max-width: 768px) {
            .alerts-main-content {
                margin-left: 0;
                padding: 1rem;
            }
            .alert-card { flex-direction: column; gap: 0.75rem; }
            .alert-actions { flex-direction: column; }
            .alert-btn { width: 100%; text-align: center; }
        }

        @media (max-width: 1024px) {
            .alerts-main-content {
                margin-left: 70px;
            }
        }
    </style>
</head>
<body>
    <div class="alerts-layout">
        <jsp:include page="components/sidebar.jsp" />
        
        <div class="alerts-main-content">
            <div class="alerts-container">
                <div class="alerts-header">
                    <h1 class="alerts-title">📢 Your Alerts</h1>
                    <p class="alerts-subtitle">Stay informed about important patterns and events</p>
                </div>
                
                <div class="alerts-list">
                    <% if (alerts.isEmpty()) { %>
                        <div class="alert-empty">
                            <div class="alert-empty-icon">✨</div>
                            <h2 style="color: #2C2C2C; margin-bottom: 0.5rem;">No Alerts</h2>
                            <p>You're all caught up! No important patterns or events at the moment.</p>
                        </div>
                    <% } else {
                        for (DemoAlert alert : alerts) {
                            String priorityClass = "alert-" + alert.priority.toLowerCase();
                    %>
                        <div class="alert-card <%= priorityClass %>" data-priority="<%= alert.priority.toLowerCase() %>">
                            <div class="alert-icon"><%= alert.icon %></div>
                            
                            <div class="alert-content">
                                <div class="alert-type">
                                    <%= alert.type.replace('_', ' ') %>
                                    <span class="priority-badge priority-<%= alert.priority.toLowerCase() %>">
                                        <%= alert.priority %>
                                    </span>
                                </div>
                                
                                <h3 class="alert-title"><%= alert.title %></h3>
                                <p class="alert-message"><%= alert.message %></p>
                                
                                <div class="alert-actions">
                                    <% if (alert.actionUrl != null && !alert.actionUrl.isEmpty()) { %>
                                        <a href="<%= alert.actionUrl %>" class="alert-btn alert-btn-action">
                                            Take Action →
                                        </a>
                                    <% } %>
                                    <button class="alert-btn alert-btn-dismiss" onclick="dismissAlert(this)">
                                        Dismiss
                                    </button>
                                </div>
                                
                                <div class="alert-time" id="time-<%= alert.id %>"></div>
                            </div>
                        </div>
                    <% }
                    } %>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function dismissAlert(btn) {
            const card = btn.closest('.alert-card');
            card.style.opacity = '0.5';
            card.style.pointerEvents = 'none';
            setTimeout(() => {
                card.style.display = 'none';
            }, 300);
        }
        
        function formatTime(dateTime) {
            const now = new Date();
            const mins = Math.floor((now - dateTime) / 60000);
            const hours = Math.floor(mins / 60);
            const days = Math.floor(hours / 24);
            
            if (mins < 1) return 'Just now';
            if (mins < 60) return mins + ' min ago';
            if (hours < 24) return hours + 'h ago';
            if (days < 7) return days + 'd ago';
            return dateTime.toLocaleDateString();
        }
        
        // Format time for each alert
        document.querySelectorAll('[id^="time-"]').forEach(elem => {
            const alertId = elem.id.replace('time-', '');
            const timeStr = formatTime(new Date(Date.now() - Math.random() * 7200000));
            elem.textContent = timeStr;
        });
    </script>
</body>
</html>
