<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.model.Habit" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--space-3xl) var(--space-2xl) var(--space-4xl) var(--space-2xl);
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            min-height: 100vh;
            transition: margin-left 0.3s ease-in-out, width 0.3s ease-in-out;
        }

        .dashboard-main {
            width: 100%;
            max-width: 1200px;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-2xl);
            flex-wrap: wrap;
            gap: var(--space-lg);
        }

        .dashboard-title {
            color: var(--color-pale-dogwood);
            font-size: 2rem;
            font-weight: 700;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }

        .user-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--gradient-button);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #FFF;
            font-weight: 700;
            font-size: 1.2rem;
        }

        .user-name {
            color: var(--color-pale-dogwood);
            font-weight: 600;
        }

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .stat-box {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .stat-icon {
            font-size: 2rem;
            margin-bottom: var(--space-sm);
        }

        .stat-number {
            color: var(--color-puce);
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: var(--space-xs);
        }

        .stat-label {
            color: var(--color-text-soft);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .card-title {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-lg);
        }

        .today-mood {
            text-align: center;
            padding: var(--space-lg) 0;
        }

        .mood-emoji {
            font-size: 3rem;
            margin-bottom: var(--space-lg);
        }

        .mood-text {
            color: var(--color-pale-dogwood);
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: var(--space-md);
        }

        .mood-scale {
            display: flex;
            justify-content: space-around;
            gap: var(--space-sm);
            margin: var(--space-lg) 0;
        }

        .mood-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid var(--color-rose-quartz);
            background: transparent;
            cursor: pointer;
            font-size: 1.3rem;
            transition: all var(--transition-fast);
        }

        .mood-btn:hover {
            border-color: var(--color-puce);
            transform: scale(1.1);
        }

        .upcoming-events {
            list-style: none;
        }

        .event-item {
            padding: var(--space-lg) 0;
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            gap: var(--space-lg);
            align-items: flex-start;
        }

        .event-item:last-child {
            border-bottom: none;
        }

        .event-time {
            color: var(--color-puce);
            font-weight: 700;
            min-width: 60px;
        }

        .event-content {
            flex: 1;
        }

        .event-title {
            color: var(--color-pale-dogwood);
            font-weight: 600;
            margin-bottom: var(--space-xs);
        }

        .event-desc {
            color: var(--color-text-soft);
            font-size: 0.85rem;
        }

        .progress-section {
            margin-bottom: var(--space-lg);
        }

        .progress-item {
            margin-bottom: var(--space-lg);
        }

        .progress-label {
            color: var(--color-pale-dogwood);
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: var(--space-sm);
            display: flex;
            justify-content: space-between;
        }

        .progress-bar {
            height: 8px;
            background: var(--glass-overlay);
            border-radius: var(--radius-xl);
            overflow: hidden;
            border: 1px solid var(--glass-border);
        }

        .progress-fill {
            height: 100%;
            background: var(--gradient-button);
            border-radius: var(--radius-xl);
        }

        .cta-button {
            width: 100%;
            padding: var(--space-lg);
            background: var(--color-puce);
            color: #FFF;
            border: none;
            border-radius: var(--radius-md);
            font-weight: 700;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: var(--space-lg);
            transition: all var(--transition-base);
            box-shadow: var(--shadow-glow);
        }

        .cta-button:hover {
            transform: translateY(-4px);
            box-shadow: 0 0 40px rgba(191, 113, 133, 0.5);
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
        <!-- Sidebar -->
        <% request.setAttribute("currentPage", "dashboard"); %>
        <%@ include file="components/sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content dashboard-main">
            <div class="dashboard-header">
                <h1 class="dashboard-title">Welcome back, <%= request.getAttribute("userName") != null ? request.getAttribute("userName") : "User" %> 👋</h1>
                <div class="user-profile">
                    <div>
                        <div class="user-name">Today's Date</div>
                        <div style="color: var(--color-text-muted); font-size: 0.85rem;"><%= request.getAttribute("todayDate") != null ? request.getAttribute("todayDate") : "" %></div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats - Real-time Habit Data -->
            <div class="quick-stats">
                <div class="stat-box">
                    <div class="stat-icon"><%= request.getAttribute("todayMoodEmoji") != null ? request.getAttribute("todayMoodEmoji") : "😊" %></div>
                    <div class="stat-number"><%= request.getAttribute("moodScore") != null ? request.getAttribute("moodScore") : "0.0" %></div>
                    <div class="stat-label">Today's Mood</div>
                </div>
                <div class="stat-box">
                    <div class="stat-icon">🎯</div>
                    <div class="stat-number"><%= request.getAttribute("habitsCompletedToday") != null ? request.getAttribute("habitsCompletedToday") : "0" %>/<%= request.getAttribute("totalHabits") != null ? request.getAttribute("totalHabits") : "0" %></div>
                    <div class="stat-label">Habits Completed</div>
                </div>
                <div class="stat-box">
                    <div class="stat-icon">🔥</div>
                    <div class="stat-number"><%= request.getAttribute("habitStreak") != null ? request.getAttribute("habitStreak") : "0" %></div>
                    <div class="stat-label">Best Streak</div>
                </div>
                <div class="stat-box">
                    <div class="stat-icon">📈</div>
                    <div class="stat-number"><%= request.getAttribute("habitConsistency") != null ? String.format("%.0f", (Double) request.getAttribute("habitConsistency")) : "0" %>%</div>
                    <div class="stat-label">Consistency</div>
                </div>
            </div>

            <!-- Main Grid -->
            <div class="dashboard-grid">
                <!-- Today's Mood -->
                <div class="card">
                    <div class="card-title">How are you feeling today?</div>

                    <div class="today-mood">
                        <div class="mood-emoji"><%= request.getAttribute("todayMoodEmoji") != null ? request.getAttribute("todayMoodEmoji") : "😐" %></div>
                        <div class="mood-text"><%= request.getAttribute("todayMoodText") != null ? request.getAttribute("todayMoodText") : "How are you feeling?" %></div>
                        <div class="mood-scale">
                            <button class="mood-btn">😭</button>
                            <button class="mood-btn">😔</button>
                            <button class="mood-btn">😐</button>
                            <button class="mood-btn">😊</button>
                            <button class="mood-btn">😄</button>
                        </div>
                    </div>

                    <button class="cta-button">Log Emotion</button>
                </div>

                <!-- Quick Actions -->
                <div class="card">
                    <div class="card-title">Quick Actions</div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                        <button style="padding: var(--space-lg); background: var(--glass-overlay); border: 1px solid var(--glass-border); color: var(--color-pale-dogwood); border-radius: var(--radius-md); cursor: pointer; font-weight: 600; transition: all var(--transition-fast);" onmouseover="this.style.borderColor='var(--color-puce)'" onmouseout="this.style.borderColor='var(--glass-border)'">
                            📝 Write
                        </button>
                        <button style="padding: var(--space-lg); background: var(--glass-overlay); border: 1px solid var(--glass-border); color: var(--color-pale-dogwood); border-radius: var(--radius-md); cursor: pointer; font-weight: 600; transition: all var(--transition-fast);" onmouseover="this.style.borderColor='var(--color-puce)'" onmouseout="this.style.borderColor='var(--glass-border)'">
                            🧘 Meditate
                        </button>
                        <button style="padding: var(--space-lg); background: var(--glass-overlay); border: 1px solid var(--glass-border); color: var(--color-pale-dogwood); border-radius: var(--radius-md); cursor: pointer; font-weight: 600; transition: all var(--transition-fast);" onmouseover="this.style.borderColor='var(--color-puce)'" onmouseout="this.style.borderColor='var(--glass-border)'">
                            📊 Analyze
                        </button>
                        <button style="padding: var(--space-lg); background: var(--glass-overlay); border: 1px solid var(--glass-border); color: var(--color-pale-dogwood); border-radius: var(--radius-md); cursor: pointer; font-weight: 600; transition: all var(--transition-fast);" onmouseover="this.style.borderColor='var(--color-puce)'" onmouseout="this.style.borderColor='var(--glass-border)'">
                            🎯 Consult AI
                        </button>
                    </div>
                </div>

                <!-- Today's Habits -->
                <div class="card">
                    <div class="card-title">Today's Habits</div>

                    <div class="progress-section">
                        <%
                            @SuppressWarnings("unchecked")
                            List<Habit> habitsList = (List<Habit>) request.getAttribute("habitsList");
                            @SuppressWarnings("unchecked")
                            Map<Integer, Boolean> habitsCompletedTodayMap = (Map<Integer, Boolean>) request.getAttribute("habitsCompletedTodayMap");
                            
                            if (habitsList != null && !habitsList.isEmpty()) {
                                for (Habit habit : habitsList) {
                                    boolean completedToday = habitsCompletedTodayMap != null && habitsCompletedTodayMap.getOrDefault(habit.getHabitId(), false);
                                    String statusText = completedToday ? "✓ Done" : "Not done";
                                    int progressPercent = completedToday ? 100 : 0;
                        %>
                            <div class="progress-item">
                                <div class="progress-label">
                                    <span><%= habit.getName() != null ? habit.getName() : "Habit" %></span>
                                    <span><%= statusText %></span>
                                </div>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: <%= progressPercent %>%;"></div>
                                </div>
                            </div>
                        <%
                                }
                            } else {
                        %>
                            <div style="text-align: center; padding: 20px; color: var(--color-text-soft);">
                                <p>No habits tracked yet. <a href="habit_complete.jsp" style="color: var(--color-puce);">Create your first habit</a></p>
                            </div>
                        <%
                            }
                        %>
                    </div>
                </div>

                <!-- Upcoming Events -->
                <div class="card">
                    <div class="card-title">Today's Schedule</div>

                    <ul class="upcoming-events">
                        <li class="event-item">
                            <div class="event-time">10:00</div>
                            <div class="event-content">
                                <div class="event-title">Team Meeting</div>
                                <div class="event-desc">Project kickoff discussion</div>
                            </div>
                        </li>
                        <li class="event-item">
                            <div class="event-time">12:00</div>
                            <div class="event-content">
                                <div class="event-title">Lunch Break</div>
                                <div class="event-desc">Relaxation time</div>
                            </div>
                        </li>
                        <li class="event-item">
                            <div class="event-time">15:00</div>
                            <div class="event-content">
                                <div class="event-title">Exercise</div>
                                <div class="event-desc">30 min cardio session</div>
                            </div>
                        </li>
                        <li class="event-item">
                            <div class="event-time">19:00</div>
                            <div class="event-content">
                                <div class="event-title">Meditation</div>
                                <div class="event-desc">Evening mindfulness</div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
