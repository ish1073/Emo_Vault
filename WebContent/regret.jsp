<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.Regret" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Regret> regrets = (List<Regret>) request.getAttribute("regrets");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reflections - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .regret-layout {
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

        .regret-section {
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

        .regret-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-2xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-label {
            display: block;
            font-weight: var(--font-weight-medium);
            color: var(--color-heather);
            margin-bottom: var(--space-md);
            font-size: var(--font-size-base);
        }

        .form-control {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            background: var(--color-cream);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-md);
            color: var(--color-azur);
            transition: all var(--transition-base);
            min-height: 120px;
            resize: vertical;
        }

        .form-control:focus {
            outline: none;
            background: var(--color-white);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }

        .form-actions {
            display: flex;
            gap: var(--space-md);
            margin-top: var(--space-lg);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-warm-gray);
        }

        .btn {
            padding: var(--space-sm) var(--space-lg);
            border: none;
            border-radius: var(--radius-lg);
            font-weight: var(--font-weight-medium);
            cursor: pointer;
            transition: all var(--transition-base);
            font-family: var(--font-primary);
        }

        .btn-primary {
            background: var(--color-viridian);
            color: white;
            box-shadow: var(--shadow-md);
        }

        .btn-primary:hover {
            background: #5F8A8A;
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .entries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: var(--space-lg);
        }

        .regret-entry {
            background: var(--color-white);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: var(--shadow-md);
            border-left: 4px solid var(--color-candy);
            transition: all var(--transition-base);
        }

        .regret-entry:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .entry-date {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-bottom: var(--space-md);
        }

        .entry-section {
            margin-bottom: var(--space-md);
        }

        .entry-label {
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
            font-size: var(--font-size-sm);
            margin-bottom: var(--space-sm);
        }

        .entry-text {
            color: var(--color-azur);
            line-height: var(--line-height-normal);
            font-size: var(--font-size-base);
        }

        .no-entries {
            text-align: center;
            padding: var(--space-3xl);
            color: var(--color-warm-gray);
        }

        .success-message {
            background: #E8F5E9;
            border-left: 4px solid #4CAF50;
            color: #1B5E20;
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-lg);
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }

            .entries-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="regret-layout">
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="regret" />
        </jsp:include>

        <div class="main-content">
            <div class="regret-section">
                <div class="section-header">
                    <h1 class="section-title">💭 Reflections & Lessons</h1>
                    <p class="section-subtitle">Learn from your experiences</p>
                </div>

                <div class="regret-card">
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="success-message">✓ <%= request.getAttribute("success") %></div>
                    <% } %>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="error-message" style="color: red; background: rgba(255, 0, 0, 0.1); padding: 10px; border-radius: 5px; margin-bottom: 15px;">✗ <%= request.getAttribute("error") %></div>
                    <% } %>
                    
                    <form action="${pageContext.request.contextPath}/regret" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="form-group">
                            <label class="form-label">What do you regret?</label>
                            <textarea id="regret" name="description" class="form-control" placeholder="Describe what happened..." required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">What did you learn?</label>
                            <textarea id="lesson" name="lesson_learned" class="form-control" placeholder="What insight or lesson came from this experience?" required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Tag (category)</label>
                            <select name="tag" class="form-control" required>
                                <option value="">Select a category...</option>
                                <option value="procrastination">Procrastination</option>
                                <option value="communication">Communication</option>
                                <option value="stress">Stress</option>
                                <option value="relationships">Relationships</option>
                                <option value="health">Health</option>
                                <option value="work">Work</option>
                                <option value="other">Other</option>
                            </select>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">✓ Save Reflection</button>
                        </div>
                    </form>
                </div>

                <% if (regrets != null && !regrets.isEmpty()) { %>
                    <div style="margin-top: var(--space-3xl);">
                        <h2 style="font-size: var(--font-size-2xl); color: var(--color-heather); margin-bottom: var(--space-lg);">📚 Past Reflections</h2>
                        <div class="entries-grid">
                            <% for (Regret regret : regrets) { %>
                                <div class="regret-entry">
                                    <div class="entry-date"><%= dateFormat.format(regret.getCreatedDate()) %></div>
                                    <div class="entry-section">
                                        <div class="entry-label">Regret:</div>
                                        <div class="entry-text"><%= regret.getDescription() %></div>
                                    </div>
                                    <div class="entry-section">
                                        <div class="entry-label">Lesson:</div>
                                        <div class="entry-text"><%= regret.getLessonLearned() %></div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
