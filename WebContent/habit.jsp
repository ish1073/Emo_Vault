<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.Habit" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

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
    
    @SuppressWarnings("unchecked")
    Map<Integer, Boolean> completedTodayMap = (Map<Integer, Boolean>) request.getAttribute("completedTodayMap");
    if (completedTodayMap == null) {
        completedTodayMap = new java.util.HashMap<>();
    }
    
    // Get insights from request attributes (set by servlet with real data)
    int totalHabits = request.getAttribute("totalHabits") != null ? (Integer) request.getAttribute("totalHabits") : habits.size();
    int activeHabits = request.getAttribute("activeHabits") != null ? (Integer) request.getAttribute("activeHabits") : 0;
    int totalStreak = request.getAttribute("totalStreak") != null ? (Integer) request.getAttribute("totalStreak") : 0;
    int maxStreak = request.getAttribute("maxStreak") != null ? (Integer) request.getAttribute("maxStreak") : 0;
    double avgConsistency = request.getAttribute("avgConsistency") != null ? (Double) request.getAttribute("avgConsistency") : 0.0;
    double activePercentage = request.getAttribute("activePercentage") != null ? (Double) request.getAttribute("activePercentage") : 0.0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Habit Tracking - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #E6D4BF 0%, #FBF8F3 100%);
            font-family: var(--font-primary);
            color: var(--color-azur);
            min-height: 100vh;
        }

        .habit-container {
            display: flex;
            min-height: 100vh;
            gap: 0;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 48px 40px;
            overflow-y: auto;
            transition: margin-left 0.3s ease-in-out, width 0.3s ease-in-out;
        }

        /* ==================== HEADER SECTION ==================== */
        .header-section {
            margin-bottom: 48px;
            animation: fadeInDown 0.6s ease-out;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 32px;
        }

        .header-title {
            flex: 1;
        }

        .header-title h1 {
            font-family: var(--font-secondary);
            font-size: 48px;
            color: var(--color-heather);
            margin-bottom: 8px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .header-title p {
            font-size: 16px;
            color: var(--color-warm-gray);
            line-height: 1.5;
        }

        .create-habit-btn {
            padding: 14px 28px;
            background: linear-gradient(135deg, var(--color-viridian) 0%, #5F8A8A 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            box-shadow: 0 8px 24px rgba(103, 159, 159, 0.2);
            transition: all 0.3s ease;
            font-family: var(--font-primary);
        }

        .create-habit-btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 12px 32px rgba(103, 159, 159, 0.3);
        }

        .create-habit-btn:active {
            transform: translateY(-1px) scale(0.98);
        }

        /* ==================== MAIN CONTENT AREA ==================== */
        .content-wrapper {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 32px;
            align-items: start;
        }

        /* ==================== HABITS GRID ==================== */
        .habits-section {
            animation: fadeInUp 0.6s ease-out 0.1s both;
        }

        .habits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }

        .habit-card {
            background: white;
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(230, 212, 191, 0.4);
            transition: all 0.35s cubic-bezier(0.4, 0.0, 0.2, 1);
            animation: fadeInUp 0.6s ease-out both;
            position: relative;
            overflow: hidden;
            transform: rotate(var(--rotation));
        }

        /* Alternate rotation for visual interest */
        .habit-card:nth-child(1) { --rotation: -1.2deg; }
        .habit-card:nth-child(2) { --rotation: 0.8deg; }
        .habit-card:nth-child(3) { --rotation: -0.9deg; }
        .habit-card:nth-child(4) { --rotation: 1.1deg; }
        .habit-card:nth-child(5) { --rotation: -0.7deg; }
        .habit-card:nth-child(6) { --rotation: 0.9deg; }

        .habit-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at 20% 50%, rgba(103, 159, 159, 0) 0%, transparent 50%);
            opacity: 0;
            transition: opacity 0.35s ease;
            pointer-events: none;
        }

        .habit-card:hover {
            transform: translateY(-12px) rotate(0deg) scale(1.02);
            box-shadow: 0 20px 48px rgba(103, 159, 159, 0.15);
        }

        .habit-card:hover::before {
            opacity: 1;
        }

        .habit-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }

        .habit-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--color-heather);
            margin: 0;
            flex: 1;
            line-height: 1.4;
        }

        .habit-emoji {
            font-size: 28px;
            margin-left: 12px;
        }

        .habit-description {
            font-size: 14px;
            color: var(--color-warm-gray);
            margin-bottom: 20px;
            line-height: 1.5;
        }

        /* ==================== STREAK DISPLAY ==================== */
        .streak-container {
            background: linear-gradient(135deg, rgba(225, 130, 153, 0.1) 0%, rgba(225, 130, 153, 0.05) 100%);
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: 1px solid rgba(225, 130, 153, 0.2);
        }

        .streak-label {
            font-size: 13px;
            color: var(--color-warm-gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .streak-count {
            font-size: 24px;
            font-weight: 700;
            color: #E18299;
            font-family: var(--font-secondary);
        }

        /* ==================== CONSISTENCY BADGE ==================== */
        .consistency-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, rgba(103, 159, 159, 0.08) 0%, rgba(135, 116, 153, 0.08) 100%);
            border-radius: 8px;
            padding: 8px 12px;
            margin-bottom: 20px;
            font-size: 13px;
            font-weight: 600;
            color: var(--color-heather);
        }

        .consistency-bar {
            width: 100%;
            height: 6px;
            background: rgba(212, 196, 185, 0.5);
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .consistency-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--color-viridian) 0%, #5F8A8A 100%);
            border-radius: 3px;
            transition: width 0.4s ease;
        }

        /* ==================== MARK DONE BUTTON ==================== */
        .habit-action {
            display: flex;
            gap: 10px;
        }

        .mark-done-btn {
            flex: 1;
            padding: 12px 16px;
            background: linear-gradient(135deg, var(--color-viridian) 0%, #5F8A8A 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(103, 159, 159, 0.15);
        }

        .mark-done-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(103, 159, 159, 0.25);
        }

        .mark-done-btn:active:not(:disabled) {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(103, 159, 159, 0.2);
        }

        .mark-done-btn:disabled {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
            cursor: default;
            opacity: 0.95;
        }

        .mark-done-btn.completed {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
        }

        .mark-done-btn:disabled:hover {
            transform: none;
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
        }

        .habit-delete-btn {
            padding: 12px 12px;
            background: #FBF8F3;
            color: var(--color-warm-gray);
            border: 1px solid rgba(212, 196, 185, 0.5);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
        }

        .habit-delete-btn:hover {
            background: #F5F0EA;
            color: #E18299;
            border-color: rgba(225, 130, 153, 0.3);
        }

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            animation: fadeInUp 0.6s ease-out;
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 24px;
        }

        .empty-state h2 {
            font-family: var(--font-secondary);
            font-size: 28px;
            color: var(--color-heather);
            margin-bottom: 12px;
            font-weight: 700;
        }

        .empty-state p {
            font-size: 16px;
            color: var(--color-warm-gray);
            margin-bottom: 32px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        .empty-state-btn {
            padding: 14px 32px;
            background: linear-gradient(135deg, var(--color-viridian) 0%, #5F8A8A 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            box-shadow: 0 8px 24px rgba(103, 159, 159, 0.2);
            transition: all 0.3s ease;
        }

        .empty-state-btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 12px 32px rgba(103, 159, 159, 0.3);
        }

        /* ==================== INSIGHTS SIDEBAR ==================== */
        .insights-sidebar {
            animation: fadeInRight 0.6s ease-out 0.2s both;
        }

        .insights-panel {
            background: white;
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(230, 212, 191, 0.4);
            position: sticky;
            top: 48px;
        }

        .insights-title {
            font-family: var(--font-secondary);
            font-size: 20px;
            color: var(--color-heather);
            margin-bottom: 24px;
            font-weight: 700;
        }

        .insight-item {
            margin-bottom: 28px;
            padding-bottom: 28px;
            border-bottom: 1px solid rgba(212, 196, 185, 0.3);
        }

        .insight-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .insight-label {
            font-size: 13px;
            color: var(--color-warm-gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .insight-value {
            font-family: var(--font-secondary);
            font-size: 32px;
            font-weight: 700;
            color: var(--color-heather);
            margin-bottom: 8px;
        }

        .insight-description {
            font-size: 14px;
            color: var(--color-warm-gray);
            line-height: 1.5;
        }

        .insight-progress {
            width: 100%;
            height: 8px;
            background: rgba(212, 196, 185, 0.5);
            border-radius: 4px;
            overflow: hidden;
        }

        .insight-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--color-viridian) 0%, #5F8A8A 100%);
            border-radius: 4px;
            transition: width 0.5s ease;
        }

        /* ==================== CREATE HABIT MODAL ==================== */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
        }

        .modal.active {
            display: flex;
            animation: fadeIn 0.3s ease-out;
        }

        .modal-content {
            background: white;
            border-radius: 24px;
            padding: 40px;
            max-width: 480px;
            width: 90%;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            animation: slideUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .modal-header {
            margin-bottom: 28px;
        }

        .modal-header h2 {
            font-family: var(--font-secondary);
            font-size: 28px;
            color: var(--color-heather);
            margin: 0;
            font-weight: 700;
        }

        .modal-header p {
            font-size: 14px;
            color: var(--color-warm-gray);
            margin: 8px 0 0 0;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--color-heather);
            margin-bottom: 8px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            font-family: var(--font-primary);
            font-size: 16px;
            background: #FBF8F3;
            border: 2px solid rgba(212, 196, 185, 0.6);
            border-radius: 12px;
            color: var(--color-azur);
            transition: all 0.3s ease;
        }

        .form-input::placeholder {
            color: var(--color-warm-gray);
        }

        .form-input:focus {
            outline: none;
            background: white;
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 4px rgba(103, 159, 159, 0.1);
        }

        .form-textarea {
            min-height: 100px;
            resize: vertical;
            font-family: var(--font-primary);
        }

        .modal-footer {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid rgba(212, 196, 185, 0.3);
        }

        .modal-btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: var(--font-primary);
        }

        .modal-btn-cancel {
            background: #FBF8F3;
            color: var(--color-heather);
            border: 2px solid var(--color-heather);
        }

        .modal-btn-cancel:hover {
            background: #F5F0EA;
        }

        .modal-btn-create {
            background: linear-gradient(135deg, var(--color-viridian) 0%, #5F8A8A 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(103, 159, 159, 0.2);
        }

        .modal-btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(103, 159, 159, 0.3);
        }

        /* ==================== ANIMATIONS ==================== */
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInRight {
            from {
                opacity: 0;
                transform: translateX(20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
            }
        }

        /* ==================== RESPONSIVE DESIGN ==================== */
        @media (max-width: 1024px) {
            .content-wrapper {
                grid-template-columns: 1fr;
            }

            .insights-sidebar {
                display: none;
            }

            .habits-grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 32px 20px;
            }

            .header-top {
                flex-direction: column;
                gap: 16px;
            }

            .header-title h1 {
                font-size: 32px;
            }

            .create-habit-btn {
                width: 100%;
            }

            .habits-grid {
                grid-template-columns: 1fr;
            }

            .habit-card {
                transform: rotate(0deg) !important;
            }

            .habit-card:hover {
                transform: translateY(-8px) rotate(0deg) scale(1.01) !important;
            }

            .modal-content {
                padding: 32px 24px;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 24px 16px;
            }

            .header-title h1 {
                font-size: 24px;
            }

            .habit-card {
                padding: 20px;
            }

            .empty-state {
                padding: 40px 20px;
            }

            .empty-state-icon {
                font-size: 48px;
            }

            .empty-state h2 {
                font-size: 22px;
            }
        }
    </style>

    </style>
</head>
<body>
    <div class="habit-container">
        <!-- Sidebar Navigation -->
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="habit" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header Section -->
            <div class="header-section">
                <div class="header-top">
                    <div class="header-title">
                        <h1>🌱 Your Habits</h1>
                        <p>Build consistency, track progress, celebrate growth</p>
                    </div>
                    <button class="create-habit-btn" onclick="openCreateHabitModal()">+ Create Habit</button>
                </div>
            </div>

            <!-- Main Content Wrapper -->
            <div class="content-wrapper">
                <!-- Habits Section -->
                <div class="habits-section">
                    <% if (habits != null && !habits.isEmpty()) { %>
                        <div class="habits-grid">
                            <% for (Habit habit : habits) {
                                int streak = habit.getCurrentStreak() != 0 ? habit.getCurrentStreak() : 0;
                                int consistency = habit.getConsistencyScore() != 0 ? habit.getConsistencyScore() : 0;
                            %>
                                <div class="habit-card">
                                    <div class="habit-card-header">
                                        <h3 class="habit-title"><%= habit.getName() %></h3>
                                        <span class="habit-emoji">🎯</span>
                                    </div>

                                    <% if (habit.getDescription() != null && !habit.getDescription().isEmpty()) { %>
                                        <p class="habit-description"><%= habit.getDescription() %></p>
                                    <% } %>

                                    <!-- Streak Display -->
                                    <div class="streak-container">
                                        <span class="streak-label">🔥 Current Streak</span>
                                        <span class="streak-count"><%= streak %></span>
                                    </div>

                                    <!-- Consistency Badge -->
                                    <div class="consistency-badge">
                                        <span>📈 Consistency</span>
                                    </div>

                                    <div class="consistency-bar">
                                        <div class="consistency-fill" style="width: <%= consistency %>%"></div>
                                    </div>

                                    <!-- Mark Done & Delete Action -->
                                    <div class="habit-action">
                                        <%
                                            boolean completedToday = completedTodayMap.getOrDefault(habit.getHabitId(), false);
                                            String buttonText = completedToday ? "✓ Done Today!" : "✓ Mark Done";
                                            String buttonClass = completedToday ? "mark-done-btn completed" : "mark-done-btn";
                                            String buttonDisabled = completedToday ? "disabled" : "";
                                        %>
                                        <form method="post" action="${pageContext.request.contextPath}/habit" style="flex: 1; display: flex; gap: 10px;">
                                            <input type="hidden" name="habitId" value="<%= habit.getHabitId() %>">
                                            <input type="hidden" name="action" value="complete">
                                            <button type="submit" class="<%= buttonClass %>" <%= buttonDisabled %> title="<%= completedToday ? "Completed today" : "Mark this habit as done" %>"><%= buttonText %></button>
                                        </form>
                                        
                                        <form method="post" action="${pageContext.request.contextPath}/habit" style="display: inline;">
                                            <input type="hidden" name="habitId" value="<%= habit.getHabitId() %>">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="habit-delete-btn" title="Delete Habit">🗑</button>
                                        </form>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">🌱</div>
                            <h2>No Habits Yet</h2>
                            <p>Start building positive routines today. Create your first habit to begin tracking your progress.</p>
                            <button class="empty-state-btn" onclick="openCreateHabitModal()">Create Your First Habit</button>
                        </div>
                    <% } %>
                </div>

                <!-- Insights Sidebar -->
                <div class="insights-sidebar">
                    <div class="insights-panel">
                        <h3 class="insights-title">📊 Insights</h3>

                        <!-- Total Habits -->
                        <div class="insight-item">
                            <div class="insight-label">Total Habits</div>
                            <div class="insight-value"><%= totalHabits %></div>
                            <div class="insight-description">
                                <%= totalHabits == 1 ? "1 habit tracked" : totalHabits + " habits tracked" %>
                            </div>
                        </div>

                        <!-- Consistency -->
                        <div class="insight-item">
                            <div class="insight-label">Consistency</div>
                            <div class="insight-value"><%= String.format("%.0f", activePercentage) %>%</div>
                            <div class="insight-progress">
                                <div class="insight-progress-fill" style="width: <%= activePercentage %>%"></div>
                            </div>
                            <div class="insight-description">Active vs Total Habits</div>
                        </div>

                        <!-- Best Streak -->
                        <div class="insight-item">
                            <div class="insight-label">🔥 Best Streak</div>
                            <div class="insight-value"><%= maxStreak %></div>
                            <div class="insight-description">
                                <%= maxStreak == 0 ? "Start tracking to build streaks" : "Keep it up! " + maxStreak + " days" %>
                            </div>
                        </div>

                        <!-- Total Streak Sum -->
                        <div class="insight-item">
                            <div class="insight-label">Combined Streak</div>
                            <div class="insight-value"><%= totalStreak %></div>
                            <div class="insight-description">Sum of all habit streaks</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Habit Modal -->
    <div id="createHabitModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Create a New Habit</h2>
                <p>Define your habit and start building a better routine today</p>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/habit">
                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label class="form-label">Habit Title</label>
                    <input type="text" name="name" class="form-input" placeholder="e.g., Morning Meditation" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Description (Optional)</label>
                    <textarea name="description" class="form-input form-textarea" placeholder="Why is this habit important to you?"></textarea>
                </div>

                <div class="modal-footer">
                    <button type="button" class="modal-btn modal-btn-cancel" onclick="closeCreateHabitModal()">Cancel</button>
                    <button type="submit" class="modal-btn modal-btn-create">Create Habit</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Modal Controls
        function openCreateHabitModal() {
            const modal = document.getElementById('createHabitModal');
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeCreateHabitModal() {
            const modal = document.getElementById('createHabitModal');
            modal.classList.remove('active');
            document.body.style.overflow = 'auto';
        }

        // Close modal when clicking outside
        document.getElementById('createHabitModal').addEventListener('click', function(event) {
            if (event.target === this) {
                closeCreateHabitModal();
            }
        });

        // Close modal with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeCreateHabitModal();
            }
        });

        // Form validation and submission
        const habitForm = document.querySelector('.modal-content form');
        if (habitForm) {
            habitForm.addEventListener('submit', function(e) {
                const habitTitle = this.querySelector('input[name="name"]').value.trim();
                if (!habitTitle || habitTitle.length < 2) {
                    e.preventDefault();
                    alert('Please enter a habit title (at least 2 characters)');
                    return false;
                }
                // Form will submit normally here
                console.log('[Habit Form] Submitting habit:', habitTitle);
            });
        }
    </script>
</body>
</html>
