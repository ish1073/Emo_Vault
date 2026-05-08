<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.Regret" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Regret Minimizer - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        .regret-card {
            background: rgba(230, 212, 191, 0.5);
            border-left: 4px solid var(--color-candy);
            padding: var(--spacing-lg);
            margin: var(--spacing-md) 0;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-soft);
            transition: all var(--transition-normal);
        }

        .regret-card:hover {
            box-shadow: var(--shadow-medium);
            transform: translateY(-2px);
        }

        .regret-tag {
            display: inline-block;
            background: var(--color-viridian);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin: var(--spacing-xs) 0;
        }

        .regret-lesson {
            background: rgba(230, 212, 191, 0.4);
            color: var(--color-text-dark);
            padding: var(--spacing-md);
            border-radius: var(--radius-sm);
            margin: var(--spacing-md) 0 0 0;
            font-size: 14px;
            line-height: 1.6;
            border-left: 3px solid var(--color-viridian);
        }

        .tag-frequency {
            background: rgba(230, 212, 191, 0.4);
            padding: var(--spacing-lg);
            border-radius: var(--radius-md);
            margin: var(--spacing-lg) 0;
        }

        .tag-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--spacing-md) 0;
            border-bottom: 1px solid rgba(135, 116, 153, 0.1);
        }

        .tag-item:last-child {
            border-bottom: none;
        }

        .tag-count {
            background: var(--color-viridian);
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
        }

        .form-section {
            background: rgba(230, 212, 191, 0.5);
            padding: var(--spacing-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--spacing-lg);
            box-shadow: var(--shadow-soft);
        }

        .form-group {
            margin-bottom: var(--spacing-md);
        }

        .form-group label {
            display: block;
            margin-bottom: var(--spacing-sm);
            font-weight: 600;
            color: var(--color-heather);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: var(--spacing-md);
            border: 2px solid var(--color-viridian);
            border-radius: var(--radius-sm);
            font-family: inherit;
            font-size: 14px;
            background: white;
            transition: all var(--transition-normal);
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--color-heather);
            box-shadow: 0 0 0 3px rgba(135, 116, 153, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .delete-btn {
            background: var(--color-candy);
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all var(--transition-normal);
        }

        .delete-btn:hover {
            background: #D16B52;
            transform: translateY(-1px);
        }

        .two-column {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: var(--spacing-lg);
        }

        @media (max-width: 768px) {
            .two-column {
                grid-template-columns: 1fr;
            }

            .sidebar {
                order: -1;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div class="navbar-brand">💝 EmoVault</div>
        <div class="navbar-menu">
            <a href="${pageContext.request.contextPath}/emotion.jsp">Emotions</a>
            <a href="${pageContext.request.contextPath}/diary">Diary</a>
            <a href="${pageContext.request.contextPath}/regret">Regrets</a>
            <a href="${pageContext.request.contextPath}/habit">Habits</a>
            <a href="${pageContext.request.contextPath}/alert">Alerts</a>
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <span style="color: var(--color-text-dark); font-size: var(--font-size-sm);">
                Welcome, <strong><%= userName %></strong>
            </span>
            <a href="javascript:void(0)" onclick="logout()" style="color: var(--color-error);">Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="wrapper">
        <div class="container-lg">
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">✓ <%= request.getAttribute("success") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">✕ <%= request.getAttribute("error") %></div>
            <% } %>

            <!-- Header -->
            <div style="margin-bottom: var(--spacing-xl);">
                <h1 style="font-size: 32px; color: var(--color-sage); margin-bottom: var(--spacing-sm);">🪞 Regret Minimizer</h1>
                <p style="color: var(--text-muted); font-size: 16px;">Track your regrets, find patterns, and learn from them</p>
            </div>

            <!-- Two-Column Layout -->
            <div class="two-column">
                <!-- Left: Form & Regrets List -->
                <div>
                    <!-- Add Regret Form -->
                    <div class="form-section">
                        <h3 style="color: var(--color-sage); margin-bottom: var(--spacing-md);">📝 Add New Regret</h3>
                        <form method="POST" action="regret">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="form-group">
                                <label>What happened?</label>
                                <textarea name="description" placeholder="Describe the situation..." required></textarea>
                            </div>

                            <div class="form-group">
                                <label>Category</label>
                                <select name="tag" required>
                                    <option value="">Select a tag...</option>
                                    <option value="procrastination">⏰ Procrastination</option>
                                    <option value="communication">💬 Communication</option>
                                    <option value="stress">😰 Stress</option>
                                    <option value="fear">😨 Fear</option>
                                    <option value="health">❤️ Health</option>
                                    <option value="relationships">💝 Relationships</option>
                                    <option value="work">💼 Work</option>
                                    <option value="other">📌 Other</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>What did you learn?</label>
                                <textarea name="lesson_learned" placeholder="What can you do differently next time?"></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block" style="cursor: pointer;">
                                Save Regret & Learn
                            </button>
                        </form>
                    </div>

                    <!-- Regrets List -->
                    <div style="margin-top: var(--spacing-xl);">
                        <h3 style="color: var(--color-sage); margin-bottom: var(--spacing-md);">📚 Your Regrets</h3>
                        <%
                            List<Regret> regrets = (List<Regret>) request.getAttribute("regrets");
                            if (regrets != null && !regrets.isEmpty()) {
                                for (Regret regret : regrets) {
                        %>
                            <div class="regret-card">
                                <div style="display: flex; justify-content: space-between; align-items: start; gap: var(--spacing-md);">
                                    <div style="flex: 1;">
                                        <p style="margin: 0 0 var(--spacing-xs) 0; line-height: 1.6;"><%= regret.getDescription() %></p>
                                        <span class="regret-tag"><%= regret.getTag() %></span>
                                        <% if (regret.getLessonLearned() != null && !regret.getLessonLearned().isEmpty()) { %>
                                            <div class="regret-lesson">
                                                <strong>💡 Lesson:</strong> <%= regret.getLessonLearned() %>
                                            </div>
                                        <% } %>
                                        <p style="font-size: 12px; color: var(--text-muted); margin-top: var(--spacing-md); margin-bottom: 0;">
                                            <%= regret.getCreatedDate() %>
                                        </p>
                                    </div>
                                    <form method="POST" action="regret" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="regret_id" value="<%= regret.getRegretId() %>">
                                        <button type="submit" class="delete-btn" onclick="return confirm('Delete this regret?');">Delete</button>
                                    </form>
                                </div>
                            </div>
                        <% 
                                }
                            } else {
                        %>
                            <div class="card" style="text-align: center; padding: var(--spacing-xl);">
                                <p style="color: var(--text-muted); font-size: 16px;">No regrets logged yet. Start by adding one above! 🌱</p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Right: Sidebar Stats -->
                <div class="sidebar">
                    <!-- Pattern Insights -->
                    <div class="tag-frequency">
                        <h4 style="color: var(--color-sage); margin-top: 0;">🎯 Your Patterns</h4>
                        <%
                            Map<String, Integer> tagFreq = (Map<String, Integer>) request.getAttribute("tagFrequency");
                            if (tagFreq != null && !tagFreq.isEmpty()) {
                                for (Map.Entry<String, Integer> entry : tagFreq.entrySet()) {
                        %>
                            <div class="tag-item">
                                <span style="font-weight: 600; color: var(--text-dark);"><%= entry.getKey() %></span>
                                <span class="tag-count"><%= entry.getValue() %></span>
                            </div>
                        <% 
                                }
                            } else {
                        %>
                            <p style="color: var(--text-muted); font-size: 14px; margin: 0;">Add regrets to see patterns</p>
                        <% } %>
                    </div>

                    <!-- Insights Card -->
                    <div class="card" style="background: var(--color-avocado); margin-top: var(--spacing-lg);">
                        <h4 style="color: white; margin-top: 0;">💡 Insights</h4>
                        <%
                            if (tagFreq != null && !tagFreq.isEmpty()) {
                                int totalRegrets = 0;
                                String topTag = "";
                                int topCount = 0;
                                for (Map.Entry<String, Integer> entry : tagFreq.entrySet()) {
                                    totalRegrets += entry.getValue();
                                    if (entry.getValue() > topCount) {
                                        topCount = entry.getValue();
                                        topTag = entry.getKey();
                                    }
                                }
                        %>
                            <ul style="margin: 0; padding: 0; list-style: none; font-size: 14px; color: white; line-height: 1.8;">
                                <li>📊 Total regrets: <strong><%= totalRegrets %></strong></li>
                                <li>🔝 Most common: <strong><%= topTag %></strong></li>
                                <li>📈 Track patterns to improve</li>
                            </ul>
                        <% } else { %>
                            <p style="color: white; font-size: 14px; margin: 0;">Start tracking to get insights</p>
                        <% } %>
                    </div>

                    <!-- Quick Links -->
                    <div class="card" style="background: var(--color-peach); margin-top: var(--spacing-lg);">
                        <h4 style="color: var(--text-dark); margin-top: 0;">🔗 Quick Links</h4>
                        <div style="display: flex; flex-direction: column; gap: var(--spacing-sm);">
                            <a href="habit" class="btn btn-primary" style="text-align: center; text-decoration: none;">💪 Build Habits</a>
                            <a href="dashboard" class="btn btn-outline" style="text-align: center; text-decoration: none;">📊 Dashboard</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2026 EmoVault - Emotional Wellness Companion</p>
        </div>
    </footer>

    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logout.jsp';
            }
        }
    </script>
</body>
</html>
