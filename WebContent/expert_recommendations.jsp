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
    
    List<Map<String, Object>> expertRecommendations = (List<Map<String, Object>>) request.getAttribute("expertRecommendations");
    Map<String, Object> recommendationStats = (Map<String, Object>) request.getAttribute("recommendationStats");
    List<Map<String, Object>> highRiskUsers = (List<Map<String, Object>>) request.getAttribute("highRiskUsers");
    List<Map<String, Object>> attentionUsers = (List<Map<String, Object>>) request.getAttribute("attentionUsers");
    
    if (expertRecommendations == null) expertRecommendations = new ArrayList<>();
    if (recommendationStats == null) recommendationStats = new HashMap<>();
    if (highRiskUsers == null) highRiskUsers = new ArrayList<>();
    if (attentionUsers == null) attentionUsers = new ArrayList<>();
    
    int totalRecs = recommendationStats.get("total") != null ? (Integer) recommendationStats.get("total") : 0;
    int viewedRecs = recommendationStats.get("viewed") != null ? (Integer) recommendationStats.get("viewed") : 0;
    int activeRecs = recommendationStats.get("active") != null ? (Integer) recommendationStats.get("active") : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recommendations - EmoVault Expert</title>
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .stat-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
            text-align: center;
        }

        .stat-value {
            font-size: var(--font-size-3xl);
            color: var(--color-viridian);
            font-weight: var(--font-weight-bold);
        }

        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-sm);
        }

        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-xl);
            margin-bottom: var(--space-2xl);
        }

        .card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-lg);
        }

        .card-title {
            font-size: var(--font-size-xl);
            color: var(--color-heather);
            font-weight: var(--font-weight-semibold);
        }

        .recommendation-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .recommendation-item {
            padding: var(--space-md);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-sm);
            background: var(--color-cream);
            border-left: 4px solid var(--color-candy);
        }

        .recommendation-item:last-child {
            margin-bottom: 0;
        }

        .rec-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-sm);
        }

        .rec-title {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
        }

        .rec-user {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
        }

        .rec-meta {
            display: flex;
            gap: var(--space-md);
            font-size: var(--font-size-xs);
            color: var(--color-warm-gray);
        }

        .rec-status {
            display: inline-block;
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: var(--font-size-xs);
            font-weight: var(--font-weight-medium);
        }

        .status-viewed {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .status-pending {
            background: #fff3e0;
            color: #e65100;
        }

        .priority-high {
            border-left-color: #e74c3c;
        }

        .priority-medium {
            border-left-color: #e65100;
        }

        .priority-low {
            border-left-color: #2e7d32;
        }

        .user-suggestions {
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
        }

        .user-item:last-child {
            margin-bottom: 0;
        }

        .user-name {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
        }

        .user-reason {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
        }

        .action-btn {
            background: var(--color-viridian);
            color: white;
            border: none;
            padding: var(--space-sm) var(--space-md);
            border-radius: var(--radius-lg);
            cursor: pointer;
            font-weight: var(--font-weight-medium);
            transition: all var(--transition-base);
            text-decoration: none;
            display: inline-block;
        }

        .action-btn:hover {
            background: var(--color-candy);
            transform: translateY(-2px);
        }

        .empty-state {
            text-align: center;
            padding: var(--space-2xl);
            color: var(--color-warm-gray);
        }

        .empty-state-icon {
            font-size: 2rem;
            margin-bottom: var(--space-md);
        }

        @media (max-width: 1024px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }

            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="expert-layout">
        <!-- Expert Sidebar -->
        <jsp:include page="components/expert-sidebar.jsp">
            <jsp:param name="currentPage" value="recommendations" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header-bar">
                <div>
                    <h1 class="section-title">📝 Recommendations</h1>
                    <p class="user-greeting">Welcome back, <%= expertName %></p>
                </div>
                <form action="${pageContext.request.contextPath}/expert" method="post" style="margin: 0;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">🚪 Logout</button>
                </form>
            </div>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value"><%= totalRecs %></div>
                    <div class="stat-label">Total Recommendations</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= activeRecs %></div>
                    <div class="stat-label">Active</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= viewedRecs %></div>
                    <div class="stat-label">Viewed by Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= totalRecs > 0 ? (viewedRecs * 100 / totalRecs) : 0 %>%</div>
                    <div class="stat-label">View Rate</div>
                </div>
            </div>

            <div class="content-grid">
                <!-- Recent Recommendations -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Recent Recommendations</h3>
                        <span><%= expertRecommendations.size() %> total</span>
                    </div>
                    <% if (expertRecommendations.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">📝</div>
                            <p>No recommendations created yet</p>
                        </div>
                    <% } else { %>
                        <ul class="recommendation-list">
                            <% for (Map<String, Object> rec : expertRecommendations) { %>
                                <li class="recommendation-item priority-<%= rec.get("priority") == 1 ? "high" : rec.get("priority") == 2 ? "medium" : "low" %>">
                                    <div class="rec-header">
                                        <span class="rec-title"><%= rec.get("title") %></span>
                                        <span class="rec-status <%= (Boolean)rec.get("isViewed") ? "status-viewed" : "status-pending" %>">
                                            <%= (Boolean)rec.get("isViewed") ? "Viewed" : "Pending" %>
                                        </span>
                                    </div>
                                    <div class="rec-user">For: <%= rec.get("username") %></div>
                                    <div class="rec-meta">
                                        <span>📅 <%= rec.get("createdAt") %></span>
                                        <span>🎯 Priority: <%= rec.get("priority") %></span>
                                    </div>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>

                <!-- Users Who May Need Recommendations -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Users Who May Need Guidance</h3>
                    </div>
                    <% if (highRiskUsers.isEmpty() && attentionUsers.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">👍</div>
                            <p>All users are doing well</p>
                        </div>
                    <% } else { %>
                        <ul class="user-suggestions">
                            <% for (Map<String, Object> user : highRiskUsers) { %>
                                <li class="user-item">
                                    <div>
                                        <div class="user-name"><%= user.get("username") %></div>
                                        <div class="user-reason">High emotional risk - <%= user.get("highIntensityCount") %> high intensity emotions</div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/expert/recommendations?action=create&userId=<%= user.get("userId") %>" class="action-btn">
                                        Create Recommendation
                                    </a>
                                </li>
                            <% } %>
                            <% for (Map<String, Object> user : attentionUsers) { %>
                                <li class="user-item">
                                    <div>
                                        <div class="user-name"><%= user.get("username") %></div>
                                        <div class="user-reason"><%= user.get("attentionReason") %></div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/expert/recommendations?action=create&userId=<%= user.get("userId") %>" class="action-btn">
                                        Create Recommendation
                                    </a>
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