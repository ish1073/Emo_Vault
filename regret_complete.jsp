<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Regret Minimizer</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .regret-page {
            min-height: 100vh;
            background: var(--color-van-dyke);
            padding: var(--space-xl);
        }

        .regret-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .regret-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .regret-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            margin-bottom: var(--space-md);
        }

        .regret-subtitle {
            color: var(--color-text-soft);
            font-size: 1rem;
        }

        .regret-timeline {
            position: relative;
            padding: var(--space-lg) 0;
        }

        .regret-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 2px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-bottom: var(--space-lg);
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
            position: relative;
        }

        .regret-card:hover {
            border-color: var(--color-puce);
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
        }

        .regret-card.recurring {
            border-color: var(--color-puce);
            background: var(--glass-bg);
        }

        .regret-header-section {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: var(--space-lg);
            gap: var(--space-md);
        }

        .regret-info {
            flex: 1;
        }

        .regret-emoji {
            font-size: 2rem;
        }

        .regret-description {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-sm);
        }

        .regret-date {
            color: var(--color-text-muted);
            font-size: 0.85rem;
        }

        .regret-badge {
            display: inline-block;
            padding: var(--space-xs) var(--space-sm);
            background: var(--color-puce);
            color: #FFF;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .regret-details {
            color: var(--color-text-soft);
            margin-bottom: var(--space-lg);
            line-height: 1.8;
        }

        .reflection-box {
            background: rgba(169, 159, 191, 0.1);
            border: 1px solid var(--color-rose-quartz);
            border-radius: var(--radius-md);
            padding: var(--space-lg);
            margin-bottom: var(--space-lg);
        }

        .reflection-title {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-bottom: var(--space-sm);
        }

        .reflection-text {
            color: var(--color-text-soft);
            font-size: 0.95rem;
            line-height: 1.7;
        }

        .regret-actions {
            display: flex;
            gap: var(--space-md);
            flex-wrap: wrap;
        }

        .btn-action {
            padding: var(--space-sm) var(--space-lg);
            background: transparent;
            border: 1px solid var(--color-rose-quartz);
            color: var(--color-pale-dogwood);
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all var(--transition-fast);
        }

        .btn-action:hover {
            background: var(--color-rose-quartz);
            color: #FFF;
        }

        .btn-action.resolve {
            border-color: var(--color-puce);
            color: var(--color-puce);
        }

        .btn-action.resolve:hover {
            background: var(--color-puce);
            color: #FFF;
        }

        .empty-state {
            text-align: center;
            padding: var(--space-3xl);
            color: var(--color-text-muted);
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: var(--space-lg);
        }

        .empty-state-text {
            color: var(--color-text-soft);
            font-size: 1.1rem;
            margin-bottom: var(--space-lg);
        }

        .btn-add {
            padding: var(--space-md) var(--space-xl);
            background: var(--gradient-button);
            color: #FFF;
            border: none;
            border-radius: var(--radius-md);
            font-weight: 600;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all var(--transition-base);
            box-shadow: var(--shadow-glow);
        }

        .btn-add:hover {
            transform: translateY(-4px);
            box-shadow: 0 0 40px rgba(191, 113, 133, 0.5);
        }
    </style>
</head>
<body>
    <header style="background: var(--color-english-violet); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
    <div class="regret-page">
        <div class="regret-container">
            <div class="regret-header">
                <h1 class="regret-title">😞 Regret Minimizer</h1>
                <p class="regret-subtitle">Transform regrets into learning opportunities and personal growth</p>
            </div>

            <div class="regret-timeline">
                <!-- Regret Card 1 - Recurring -->
                <div class="regret-card recurring">
                    <div class="regret-header-section">
                        <div class="regret-info">
                            <div class="regret-description">Procrastinating on Important Projects</div>
                            <div class="regret-date">Last occurred: March 28, 2024 • Recurring 12 times</div>
                        </div>
                        <span class="regret-badge">🔄 Recurring</span>
                    </div>

                    <div class="regret-details">
                        I keep delaying starting important work projects, even when I know they're time-sensitive. This leads to stress and rushed quality.
                    </div>

                    <div class="reflection-box">
                        <div class="reflection-title">🧠 Reflection & Learning</div>
                        <div class="reflection-text">
                            <strong>Pattern Recognition:</strong> I procrastinate when facing ambiguous or overwhelming projects. <br>
                            <strong>Root Cause:</strong> Fear of making mistakes combined with perfectionism. <br>
                            <strong>Action Taken:</strong> Breaking projects into smaller tasks and setting daily goals. <br>
                            <strong>Result:</strong> 60% reduction in last-minute rushing over 2 months.
                        </div>
                    </div>

                    <div class="regret-actions">
                        <button class="btn-action resolve">✓ Mark Resolved</button>
                        <button class="btn-action">📝 Edit</button>
                        <button class="btn-action">🗑️ Archive</button>
                    </div>
                </div>

                <!-- Regret Card 2 -->
                <div class="regret-card">
                    <div class="regret-header-section">
                        <div class="regret-info">
                            <div class="regret-description">Not Speaking Up in Team Meeting</div>
                            <div class="regret-date">Occurred: March 15, 2024</div>
                        </div>
                    </div>

                    <div class="regret-details">
                        I had a valuable idea during the meeting but didn't share it due to self-doubt. Someone else proposed something similar and got credit.
                    </div>

                    <div class="reflection-box">
                        <div class="reflection-title">🧠 Reflection & Learning</div>
                        <div class="reflection-text">
                            <strong>Lesson:</strong> My voice matters and contributes to team success. <br>
                            <strong>Growth Goal:</strong> Share one idea per meeting, even if uncertain. <br>
                            <strong>Progress:</strong> Participated in 5 meetings with increasing confidence.
                        </div>
                    </div>

                    <div class="regret-actions">
                        <button class="btn-action resolve">✓ Mark Resolved</button>
                        <button class="btn-action">📝 Edit</button>
                        <button class="btn-action">🗑️ Archive</button>
                    </div>
                </div>

                <!-- Regret Card 3 -->
                <div class="regret-card">
                    <div class="regret-header-section">
                        <div class="regret-info">
                            <div class="regret-description">Missed Family Dinner</div>
                            <div class="regret-date">Occurred: March 10, 2024</div>
                        </div>
                    </div>

                    <div class="regret-details">
                        I canceled family dinner to finish work, but the work could have waited. I hurt my family's feelings for something that wasn't urgent.
                    </div>

                    <div class="reflection-box">
                        <div class="reflection-title">🧠 Reflection & Learning</div>
                        <div class="reflection-text">
                            <strong>Realization:</strong> Relationships are more important than completing tasks. <br>
                            <strong>Commitment:</strong> Schedule personal time as non-negotiable. <br>
                            <strong>Outcome:</strong> Made 4 consecutive family dinners without cancellation. Rebuilt trust.
                        </div>
                    </div>

                    <div class="regret-actions">
                        <button class="btn-action resolve">✓ Mark Resolved</button>
                        <button class="btn-action">📝 Edit</button>
                        <button class="btn-action">🗑️ Archive</button>
                    </div>
                </div>
            </div>

            <div style="text-align: center; margin-top: var(--space-2xl);">
                <button class="btn-add">+ Add New Regret</button>
            </div>
        </div>
    </div>
</body>
</html>
