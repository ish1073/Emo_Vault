<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    Integer expertId = (Integer) session.getAttribute("expertId");
    String expertName = (String) session.getAttribute("expertName");

    if (expertId == null) {
        response.sendRedirect(request.getContextPath() + "/expert_login.jsp");
        return;
    }
    
    if (expertName == null) {
        expertName = "Expert";
    }
    
    List<Map<String, Object>> highRiskUsers = (List<Map<String, Object>>) request.getAttribute("highRiskUsers");
    List<Map<String, Object>> attentionUsers = (List<Map<String, Object>>) request.getAttribute("attentionUsers");
    List<Map<String, Object>> regretPatternUsers = (List<Map<String, Object>>) request.getAttribute("regretPatternUsers");
    List<Map<String, Object>> decliningHabitUsers = (List<Map<String, Object>>) request.getAttribute("decliningHabitUsers");
    
    if (highRiskUsers == null) highRiskUsers = new ArrayList<>();
    if (attentionUsers == null) attentionUsers = new ArrayList<>();
    if (regretPatternUsers == null) regretPatternUsers = new ArrayList<>();
    if (decliningHabitUsers == null) decliningHabitUsers = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Monitoring - EmoVault Expert</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .expert-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--space-2xl);
            transition: margin-left 0.3s ease-in-out;
        }

        .section-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
        }

        .user-greeting {
            color: var(--color-warm-gray);
            font-size: var(--font-size-base);
        }

        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-xl);
        }

        .logout-btn {
            background: var(--color-cream);
            color: var(--color-heather);
            border: 2px solid var(--color-heather);
            padding: var(--space-sm) var(--space-lg);
            border-radius: var(--radius-lg);
            cursor: pointer;
            font-weight: var(--font-weight-medium);
            transition: all var(--transition-base);
        }

        .logout-btn:hover {
            background: var(--color-sandstone);
        }

        .monitoring-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: var(--space-xl);
            margin-bottom: var(--space-2xl);
        }

        .user-category-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }

        .category-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-lg);
            padding-bottom: var(--space-md);
            border-bottom: 2px solid var(--color-cream);
        }

        .category-title {
            font-size: var(--font-size-xl);
            color: var(--color-heather);
            font-weight: var(--font-weight-semibold);
            display: flex;
            align-items: center;
            gap: var(--space-sm);
        }

        .category-badge {
            background: var(--color-cream);
            color: var(--color-viridian);
            padding: var(--space-xs) var(--space-md);
            border-radius: var(--radius-lg);
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-medium);
        }

        .user-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .user-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-md);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-sm);
            background: var(--color-cream);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .user-item:hover {
            transform: translateX(4px);
            background: var(--color-sandstone);
        }

        .user-item:last-child {
            margin-bottom: 0;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
        }

        .user-meta {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-xs);
        }

        .user-status {
            text-align: right;
        }

        .status-value {
            font-size: var(--font-size-lg);
            font-weight: var(--font-weight-bold);
            color: var(--color-candy);
        }

        .status-label {
            font-size: var(--font-size-xs);
            color: var(--color-warm-gray);
        }

        .risk-high { color: #e74c3c; }
        .risk-medium { color: #e65100; }
        .risk-low { color: #2e7d32; }

        .empty-state {
            text-align: center;
            padding: var(--space-2xl);
            color: var(--color-warm-gray);
        }

        .empty-state-icon {
            font-size: 2rem;
            margin-bottom: var(--space-md);
        }

        .view-all-link {
            display: inline-block;
            margin-top: var(--space-md);
            color: var(--color-viridian);
            text-decoration: none;
            font-weight: var(--font-weight-medium);
            transition: color 0.2s ease;
        }

        .view-all-link:hover {
            color: var(--color-candy);
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }

            .monitoring-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="expert-layout">
        <!-- Expert Sidebar -->
        <jsp:include page="components/expert-sidebar.jsp">
            <jsp:param name="currentPage" value="users" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header-bar">
                <div>
                    <h1 class="section-title">👥 User Monitoring</h1>
                    <p class="user-greeting">Welcome back, <%= expertName %></p>
                </div>
                <form action="${pageContext.request.contextPath}/expert" method="post" style="margin: 0;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">🚪 Logout</button>
                </form>
            </div>

            <div class="monitoring-grid">
                <!-- High Risk Users -->
                <div class="user-category-card">
                    <div class="category-header">
                        <h3 class="category-title">⚠️ High Risk Users</h3>
                        <span class="category-badge"><%= highRiskUsers.size() %></span>
                    </div>
                    <% if (highRiskUsers.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">✅</div>
                            <p>No high risk users detected</p>
                        </div>
                    <% } else { %>
                        <ul class="user-list">
                            <% for (Map<String, Object> user : highRiskUsers) { %>
                                <li class="user-item" onclick="location.href='${pageContext.request.contextPath}/expert/users?action=detail&userId=<%= user.get("userId") %>'">
                                    <div class="user-info">
                                        <span class="user-name"><%= user.get("username") %></span>
                                        <span class="user-meta">
                                            <%= user.get("highIntensityCount") %> high intensity | 
                                            <%= user.get("negativeEmotionCount") %> negative
                                        </span>
                                    </div>
                                    <div class="user-status">
                                        <div class="status-value risk-high"><%= String.format("%.1f", user.get("avgIntensity")) %></div>
                                        <div class="status-label">Avg Intensity</div>
                                    </div>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>

                <!-- Users Needing Attention -->
                <div class="user-category-card">
                    <div class="category-header">
                        <h3 class="category-title">📋 Needs Attention</h3>
                        <span class="category-badge"><%= attentionUsers.size() %></span>
                    </div>
                    <% if (attentionUsers.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">👍</div>
                            <p>All users are doing well</p>
                        </div>
                    <% } else { %>
                        <ul class="user-list">
                            <% for (Map<String, Object> user : attentionUsers) { %>
                                <li class="user-item" onclick="location.href='${pageContext.request.contextPath}/expert/users?action=detail&userId=<%= user.get("userId") %>'">
                                    <div class="user-info">
                                        <span class="user-name"><%= user.get("username") %></span>
                                        <span class="user-meta"><%= user.get("attentionReason") %></span>
                                    </div>
                                    <div class="user-status">
                                        <div class="status-value risk-medium"><%= String.format("%.1f", user.get("avgIntensity")) %></div>
                                        <div class="status-label">Avg Intensity</div>
                                    </div>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>

                <!-- Regret Pattern Users -->
                <div class="user-category-card">
                    <div class="category-header">
                        <h3 class="category-title">💭 Regret Patterns</h3>
                        <span class="category-badge"><%= regretPatternUsers.size() %></span>
                    </div>
                    <% if (regretPatternUsers.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">🌟</div>
                            <p>No repeated regret patterns</p>
                        </div>
                    <% } else { %>
                        <ul class="user-list">
                            <% for (Map<String, Object> user : regretPatternUsers) { %>
                                <li class="user-item" onclick="location.href='${pageContext.request.contextPath}/expert/users?action=detail&userId=<%= user.get("userId") %>'">
                                    <div class="user-info">
                                        <span class="user-name"><%= user.get("username") %></span>
                                        <span class="user-meta"><%= user.get("regretCount") %> regrets | Tags: <%= user.get("commonTags") %></span>
                                    </div>
                                    <div class="user-status">
                                        <div class="status-value risk-low"><%= user.get("regretCount") %></div>
                                        <div class="status-label">Count</div>
                                    </div>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>

                <!-- Declining Habit Users -->
                <div class="user-category-card">
                    <div class="category-header">
                        <h3 class="category-title">📉 Declining Habits</h3>
                        <span class="category-badge"><%= decliningHabitUsers.size() %></span>
                    </div>
                    <% if (decliningHabitUsers.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">🌱</div>
                            <p>Habit consistency is stable</p>
                        </div>
                    <% } else { %>
                        <ul class="user-list">
                            <% for (Map<String, Object> user : decliningHabitUsers) { %>
                                <li class="user-item" onclick="location.href='${pageContext.request.contextPath}/expert/users?action=detail&userId=<%= user.get("userId") %>'">
                                    <div class="user-info">
                                        <span class="user-name"><%= user.get("username") %></span>
                                        <span class="user-meta"><%= user.get("totalHabits") %> habits | Recent: <%= user.get("recentCompletions") %></span>
                                    </div>
                                    <div class="user-status">
                                        <div class="status-value risk-medium"><%= user.get("previousCompletions") - user.get("recentCompletions") %></div>
                                        <div class="status-label">Decline</div>
                                    </div>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>