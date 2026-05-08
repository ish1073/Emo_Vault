<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Habit Formation</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .habit-page {
            min-height: 100vh;
            background: var(--color-van-dyke);
            padding: var(--space-xl);
        }

        .habit-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .habit-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .habit-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            margin-bottom: var(--space-md);
        }

        .habit-subtitle {
            color: var(--color-text-soft);
            font-size: 1rem;
        }

        .habit-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .habit-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 2px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .habit-card:hover {
            transform: translateY(-8px);
            border-color: var(--color-puce);
            box-shadow: var(--shadow-glow);
        }

        .habit-card.completed {
            border-color: var(--color-puce);
            background: rgba(191, 113, 133, 0.1);
        }

        .habit-header-section {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: var(--space-lg);
        }

        .habit-info {
            flex: 1;
        }

        .habit-emoji {
            font-size: 1.8rem;
            margin-bottom: var(--space-sm);
        }

        .habit-name {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-xs);
        }

        .habit-subtitle-small {
            color: var(--color-text-muted);
            font-size: 0.85rem;
        }

        .streak-badge {
            text-align: center;
            padding: var(--space-md) var(--space-lg);
            background: linear-gradient(135deg, rgba(191, 113, 133, 0.2), rgba(169, 159, 191, 0.1));
            border-radius: var(--radius-md);
            border: 1px solid var(--color-rose-quartz);
        }

        .streak-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--color-puce);
        }

        .streak-label {
            color: var(--color-text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .habit-progress {
            margin: var(--space-lg) 0;
        }

        .progress-label {
            color: var(--color-pale-dogwood);
            font-weight: 600;
            font-size: 0.85rem;
            margin-bottom: var(--space-sm);
            display: flex;
            justify-content: space-between;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background: var(--glass-overlay);
            border-radius: var(--radius-xl);
            overflow: hidden;
            border: 1px solid var(--glass-border);
        }

        .progress-fill {
            height: 100%;
            background: var(--gradient-button);
            transition: width var(--transition-slow);
            box-shadow: var(--shadow-glow-subtle);
        }

        .habit-actions {
            display: flex;
            gap: var(--space-sm);
            margin-top: var(--space-lg);
        }

        .btn-check {
            flex: 1;
            padding: var(--space-sm) var(--space-md);
            background: var(--color-puce);
            color: #FFF;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 600;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all var(--transition-fast);
        }

        .btn-check:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-glow);
        }

        .btn-check.checked {
            background: var(--color-rose-quartz);
            opacity: 0.7;
        }

        .btn-more {
            padding: var(--space-sm) var(--space-md);
            background: transparent;
            color: var(--color-rose-quartz);
            border: 1px solid var(--color-rose-quartz);
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all var(--transition-fast);
        }

        .btn-more:hover {
            background: var(--color-rose-quartz);
            color: #FFF;
        }

        .calendar-week {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: var(--space-xs);
            margin-top: var(--space-md);
        }

        .calendar-day {
            aspect-ratio: 1;
            border-radius: var(--radius-sm);
            background: var(--glass-overlay);
            border: 1px solid var(--glass-border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--color-text-muted);
        }

        .calendar-day.completed {
            background: var(--color-puce);
            color: #FFF;
            border-color: var(--color-puce);
        }

        .add-habit-btn {
            width: 100%;
            padding: var(--space-lg);
            background: var(--gradient-button);
            color: #FFF;
            border: none;
            border-radius: var(--radius-md);
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all var(--transition-base);
            box-shadow: var(--shadow-glow);
        }

        .add-habit-btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 0 40px rgba(191, 113, 133, 0.5);
        }

        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-2xl);
        }

        .stat-item {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: var(--space-lg);
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-puce);
            margin-bottom: var(--space-sm);
        }

        .stat-text {
            color: var(--color-text-muted);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
    </style>
</head>
<body>
    <header style="background: var(--color-english-violet); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
    <div class="habit-page">
        <div class="habit-container">
            <div class="habit-header">
                <h1 class="habit-title">🔁 Habit Formation</h1>
                <p class="habit-subtitle">Build positive habits and track your progress toward lasting change</p>
            </div>

            <!-- Statistics -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-number">5</div>
                    <div class="stat-text">Active Habits</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">23</div>
                    <div class="stat-text">Current Streak</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">89%</div>
                    <div class="stat-text">Completion Rate</div>
                </div>
            </div>

            <!-- Habit Cards -->
            <div class="habit-grid">
                <!-- Meditation Habit -->
                <div class="habit-card completed">
                    <div class="habit-header-section">
                        <div class="habit-info">
                            <div class="habit-emoji">🧘</div>
                            <div class="habit-name">Daily Meditation</div>
                            <div class="habit-subtitle-small">15 minutes each day</div>
                        </div>
                    </div>

                    <div class="streak-badge">
                        <div class="streak-number">23</div>
                        <div class="streak-label">Day Streak</div>
                    </div>

                    <div class="habit-progress">
                        <div class="progress-label">
                            <span>This Week</span>
                            <span>5/7</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 71%;"></div>
                        </div>
                    </div>

                    <div class="calendar-week">
                        <div class="calendar-day completed">Mon</div>
                        <div class="calendar-day completed">Tue</div>
                        <div class="calendar-day">Wed</div>
                        <div class="calendar-day completed">Thu</div>
                        <div class="calendar-day completed">Fri</div>
                        <div class="calendar-day completed">Sat</div>
                        <div class="calendar-day">Sun</div>
                    </div>

                    <div class="habit-actions">
                        <button class="btn-check checked">✓ Done Today</button>
                        <button class="btn-more">⋮</button>
                    </div>
                </div>

                <!-- Exercise Habit -->
                <div class="habit-card">
                    <div class="habit-header-section">
                        <div class="habit-info">
                            <div class="habit-emoji">💪</div>
                            <div class="habit-name">Exercise</div>
                            <div class="habit-subtitle-small">30 minutes cardio</div>
                        </div>
                    </div>

                    <div class="streak-badge">
                        <div class="streak-number">15</div>
                        <div class="streak-label">Day Streak</div>
                    </div>

                    <div class="habit-progress">
                        <div class="progress-label">
                            <span>This Week</span>
                            <span>4/7</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 57%;"></div>
                        </div>
                    </div>

                    <div class="calendar-week">
                        <div class="calendar-day completed">Mon</div>
                        <div class="calendar-day">Tue</div>
                        <div class="calendar-day completed">Wed</div>
                        <div class="calendar-day">Thu</div>
                        <div class="calendar-day completed">Fri</div>
                        <div class="calendar-day completed">Sat</div>
                        <div class="calendar-day">Sun</div>
                    </div>

                    <div class="habit-actions">
                        <button class="btn-check">Mark Done</button>
                        <button class="btn-more">⋮</button>
                    </div>
                </div>

                <!-- Journaling Habit -->
                <div class="habit-card completed">
                    <div class="habit-header-section">
                        <div class="habit-info">
                            <div class="habit-emoji">📝</div>
                            <div class="habit-name">Journaling</div>
                            <div class="habit-subtitle-small">5+ minutes writing</div>
                        </div>
                    </div>

                    <div class="streak-badge">
                        <div class="streak-number">42</div>
                        <div class="streak-label">Day Streak</div>
                    </div>

                    <div class="habit-progress">
                        <div class="progress-label">
                            <span>This Week</span>
                            <span>7/7</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 100%;"></div>
                        </div>
                    </div>

                    <div class="calendar-week">
                        <div class="calendar-day completed">Mon</div>
                        <div class="calendar-day completed">Tue</div>
                        <div class="calendar-day completed">Wed</div>
                        <div class="calendar-day completed">Thu</div>
                        <div class="calendar-day completed">Fri</div>
                        <div class="calendar-day completed">Sat</div>
                        <div class="calendar-day completed">Sun</div>
                    </div>

                    <div class="habit-actions">
                        <button class="btn-check checked">✓ Done Today</button>
                        <button class="btn-more">⋮</button>
                    </div>
                </div>

                <!-- Reading Habit -->
                <div class="habit-card">
                    <div class="habit-header-section">
                        <div class="habit-info">
                            <div class="habit-emoji">📚</div>
                            <div class="habit-name">Reading</div>
                            <div class="habit-subtitle-small">20 pages daily</div>
                        </div>
                    </div>

                    <div class="streak-badge">
                        <div class="streak-number">8</div>
                        <div class="streak-label">Day Streak</div>
                    </div>

                    <div class="habit-progress">
                        <div class="progress-label">
                            <span>This Week</span>
                            <span>3/7</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 43%;"></div>
                        </div>
                    </div>

                    <div class="calendar-week">
                        <div class="calendar-day completed">Mon</div>
                        <div class="calendar-day">Tue</div>
                        <div class="calendar-day">Wed</div>
                        <div class="calendar-day">Thu</div>
                        <div class="calendar-day completed">Fri</div>
                        <div class="calendar-day completed">Sat</div>
                        <div class="calendar-day">Sun</div>
                    </div>

                    <div class="habit-actions">
                        <button class="btn-check">Mark Done</button>
                        <button class="btn-more">⋮</button>
                    </div>
                </div>

                <!-- Sleep Habit -->
                <div class="habit-card">
                    <div class="habit-header-section">
                        <div class="habit-info">
                            <div class="habit-emoji">😴</div>
                            <div class="habit-name">Sleep Schedule</div>
                            <div class="habit-subtitle-small">7-8 hours nightly</div>
                        </div>
                    </div>

                    <div class="streak-badge">
                        <div class="streak-number">18</div>
                        <div class="streak-label">Day Streak</div>
                    </div>

                    <div class="habit-progress">
                        <div class="progress-label">
                            <span>This Week</span>
                            <span>6/7</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 86%;"></div>
                        </div>
                    </div>

                    <div class="calendar-week">
                        <div class="calendar-day completed">Mon</div>
                        <div class="calendar-day completed">Tue</div>
                        <div class="calendar-day completed">Wed</div>
                        <div class="calendar-day completed">Thu</div>
                        <div class="calendar-day completed">Fri</div>
                        <div class="calendar-day">Sat</div>
                        <div class="calendar-day completed">Sun</div>
                    </div>

                    <div class="habit-actions">
                        <button class="btn-check">Mark Done</button>
                        <button class="btn-more">⋮</button>
                    </div>
                </div>
            </div>

            <button class="add-habit-btn">+ Create New Habit</button>
        </div>
    </div>
</body>
</html>
