<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.Habit" %>
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
    List<Habit> habits = (List<Habit>) request.getAttribute("habits");
    if (habits == null) {
        habits = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Habits - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: linear-gradient(135deg, var(--color-sandstone) 0%, var(--color-off-white) 100%);
            min-height: 100vh;
        }

        .navbar {
            background: rgba(230, 212, 191, 0.6);
            backdrop-filter: var(--backdrop-glass);
            border-bottom: 2px solid rgba(135, 116, 153, 0.2);
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
            color: var(--color-heather);
            font-weight: 700;
        }

        .navbar-menu {
            display: flex;
            gap: var(--spacing-xl);
            align-items: center;
        }

        .navbar-menu a {
            color: var(--color-azur);
            text-decoration: none;
            font-weight: 500;
            transition: all var(--transition-normal);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--radius-md);
        }

        .navbar-menu a:hover {
            background: rgba(103, 159, 159, 0.1);
            color: var(--color-viridian);
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
            margin-bottom: var(--spacing-3xl);
            animation: fadeIn 0.6s ease;
        }

        .page-header h1 {
            font-family: var(--font-serif);
            font-size: var(--font-h2);
            color: var(--color-plum-wine);
            margin-bottom: var(--spacing-md);
        }

        .add-habit-section {
            background: rgba(250, 232, 230, 0.6);
            backdrop-filter: var(--backdrop-glass);
            padding: var(--spacing-2xl);
            border-radius: var(--radius-xl);
            margin-bottom: var(--spacing-3xl);
            border: 1px solid rgba(255, 255, 255, 0.6);
            box-shadow: var(--shadow-medium);
            animation: slideInUp 0.6s ease;
        }

        .add-habit-section h2 {
            font-family: var(--font-serif);
            font-size: var(--font-h5);
            color: var(--color-plum-wine);
            margin-bottom: var(--spacing-lg);
        }

        .form-group {
            margin-bottom: var(--spacing-lg);
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: var(--color-plum-wine);
            margin-bottom: var(--spacing-sm);
            font-size: var(--font-body-sm);
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: var(--spacing-md);
            border: 2px solid rgba(202, 168, 171, 0.3);
            border-radius: var(--radius-lg);
            font-family: var(--font-sans);
            font-size: var(--font-body);
            background: rgba(255, 255, 255, 0.7);
            color: var(--color-text-dark);
            transition: all var(--transition-normal);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--color-dusty-rose);
            box-shadow: var(--shadow-soft), 0 0 0 3px rgba(202, 168, 171, 0.2);
            background: rgba(255, 255, 255, 0.9);
        }

        .form-group textarea {
            min-height: 80px;
            resize: vertical;
        }

        .btn-add {
            background: var(--color-plum-wine);
            color: white;
            padding: var(--spacing-lg) var(--spacing-2xl);
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-normal);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-add:hover {
            background: linear-gradient(135deg, var(--color-plum-wine) 0%, #5A2D3E 100%);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .habits-list {
            display: grid;
            gap: var(--spacing-lg);
        }

        .habit-card {
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

        .habit-card:hover {
            box-shadow: var(--shadow-large);
            transform: translateY(-2px);
        }

        .habit-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--spacing-lg);
        }

        .habit-name {
            font-size: var(--font-h5);
            font-weight: 700;
            color: var(--color-plum-wine);
            margin: 0;
            font-family: var(--font-serif);
        }

        .habit-status {
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .habit-status.active {
            color: var(--color-success);
        }

        .habit-status.inactive {
            color: var(--color-stormy-blue);
        }

        .habit-description {
            color: var(--color-stormy-blue);
            font-size: var(--font-body-sm);
            margin: var(--spacing-md) 0;
            line-height: var(--line-height-normal);
        }

        .habit-actions {
            display: flex;
            gap: var(--spacing-md);
            margin-top: var(--spacing-lg);
        }

        .btn-complete,
        .btn-delete {
            padding: var(--spacing-md) var(--spacing-lg);
            border: none;
            border-radius: var(--radius-lg);
            font-size: var(--font-body-sm);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-normal);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-complete {
            background: var(--color-plum-wine);
            color: white;
            flex: 1;
        }

        .btn-complete:hover {
            background: linear-gradient(135deg, var(--color-plum-wine) 0%, #5A2D3E 100%);
            transform: translateY(-2px);
        }

        .btn-delete {
            background: rgba(202, 168, 171, 0.2);
            color: var(--color-dusty-rose);
        }

        .btn-delete:hover {
            background: rgba(202, 168, 171, 0.3);
            transform: translateY(-2px);
        }

        .empty-state {
            text-align: center;
            padding: var(--spacing-3xl);
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

            .habit-actions {
                flex-direction: column;
            }

            .btn-complete,
            .btn-delete {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">📌 Habits</div>
            <div class="navbar-menu">
                <a href="${pageContext.request.contextPath}/emotion.jsp">Emotions</a>
                <a href="${pageContext.request.contextPath}/diary">Diary</a>
                <a href="${pageContext.request.contextPath}/habit">Habits</a>
                <a href="javascript:void(0)" onclick="logout()">Logout</a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="page-wrapper">
        <div class="container-lg">
            <h1 class="page-header">🌱 Build Your Habits</h1>

            <!-- Add Habit Form -->
            <div class="add-habit-section">
                <h2>Create New Habit</h2>
                <form method="POST" action="${pageContext.request.contextPath}/habit">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-group">
                        <label for="name">Habit Name</label>
                        <input type="text" id="name" name="name" placeholder="e.g., Morning Exercise" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" placeholder="Why do you want to build this habit?"></textarea>
                    </div>

                    <button type="submit" class="btn-add">✓ Add Habit</button>
                </form>
            </div>

            <!-- Habits List -->
            <% if (habits.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">✨</div>
                    <p>No habits yet. Create your first habit to get started!</p>
                </div>
            <% } else { %>
                <div class="habits-list">
                    <% for (Habit habit : habits) { %>
                        <div class="habit-card">
                            <div class="habit-header">
                                <div>
                                    <h3 class="habit-name"><%= habit.getName() %></h3>
                                    <p class="habit-description"><%= habit.getDescription() != null ? habit.getDescription() : "" %></p>
                                </div>
                                <% if (habit.isActive()) { %>
                                    <span class="habit-status active">✓ Active</span>
                                <% } else { %>
                                    <span class="habit-status inactive">○ Inactive</span>
                                <% } %>
                            </div>

                            <div class="habit-actions">
                                <form method="POST" action="${pageContext.request.contextPath}/habit" style="flex: 1;">
                                    <input type="hidden" name="action" value="complete">
                                    <input type="hidden" name="habitId" value="<%= habit.getHabitId() %>">
                                    <button type="submit" class="btn-complete">✓ Complete Today</button>
                                </form>
                                
                                <form method="POST" action="${pageContext.request.contextPath}/habit"
                                      onsubmit="return confirm('Are you sure you want to delete this habit?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="habitId" value="<%= habit.getHabitId() %>">
                                    <button type="submit" class="btn-delete">🗑 Delete</button>
                                </form>
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
