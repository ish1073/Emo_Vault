<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Time Capsule</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .capsule-page {
            min-height: 100vh;
            background: var(--color-van-dyke);
            padding: var(--space-xl);
        }

        .capsule-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .capsule-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .capsule-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            margin-bottom: var(--space-md);
        }

        .capsule-subtitle {
            color: var(--color-text-soft);
            font-size: 1rem;
        }

        .timeline {
            position: relative;
            padding: var(--space-xl) 0;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: 2px;
            height: 100%;
            background: linear-gradient(180deg, var(--color-puce) 0%, transparent 100%);
        }

        .timeline-item {
            margin-bottom: var(--space-2xl);
            display: flex;
            align-items: center;
            gap: var(--space-lg);
        }

        .timeline-item:nth-child(odd) .timeline-content {
            margin-left: auto;
            margin-right: 0;
            text-align: right;
        }

        .timeline-item:nth-child(even) .timeline-content {
            margin-left: 0;
            margin-right: auto;
        }

        .timeline-dot {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: var(--color-puce);
            border: 3px solid var(--color-van-dyke);
            position: relative;
            z-index: 1;
            flex-shrink: 0;
            box-shadow: var(--shadow-glow);
        }

        .timeline-content {
            flex: 1;
            max-width: 380px;
        }

        .capsule-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 2px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
        }

        .capsule-card:hover {
            transform: translateY(-4px);
            border-color: var(--color-puce);
            box-shadow: var(--shadow-glow);
        }

        .capsule-card.locked {
            border-color: var(--color-rose-quartz);
            opacity: 0.7;
            cursor: not-allowed;
        }

        .capsule-card.locked:hover {
            transform: none;
            box-shadow: none;
        }

        .capsule-date {
            color: var(--color-puce);
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: var(--space-sm);
        }

        .capsule-title-inner {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-md);
            display: flex;
            align-items: center;
            gap: var(--space-sm);
        }

        .lock-icon {
            color: var(--color-rose-quartz);
        }

        .capsule-content {
            color: var(--color-text-soft);
            font-size: 0.95rem;
            line-height: 1.8;
            margin-bottom: var(--space-lg);
        }

        .capsule-meta {
            display: flex;
            gap: var(--space-lg);
            flex-wrap: wrap;
            padding-top: var(--space-md);
            border-top: 1px solid var(--glass-border);
            font-size: 0.85rem;
            color: var(--color-text-muted);
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: var(--space-xs);
        }

        .mood-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--color-puce);
        }

        .capsule-actions {
            display: flex;
            gap: var(--space-sm);
            margin-top: var(--space-lg);
        }

        .btn-view {
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

        .btn-view:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-glow);
        }

        .btn-view:disabled, .capsule-card.locked .btn-view {
            background: var(--color-rose-quartz);
            cursor: not-allowed;
            transform: none;
        }

        .btn-share {
            flex: 1;
            padding: var(--space-sm) var(--space-md);
            background: transparent;
            color: var(--color-rose-quartz);
            border: 1px solid var(--color-rose-quartz);
            border-radius: var(--radius-sm);
            font-weight: 600;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all var(--transition-fast);
        }

        .btn-share:hover {
            background: var(--color-rose-quartz);
            color: #FFF;
        }

        .create-capsule {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 2px dashed var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-2xl);
            text-align: center;
            margin-top: var(--space-2xl);
            cursor: pointer;
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
        }

        .create-capsule:hover {
            border-color: var(--color-puce);
            background: rgba(191, 113, 133, 0.1);
        }

        .create-icon {
            font-size: 2.5rem;
            margin-bottom: var(--space-lg);
        }

        .create-text {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-sm);
        }

        .create-subtext {
            color: var(--color-text-soft);
            font-size: 0.95rem;
        }

        @media (max-width: 768px) {
            .timeline::before {
                display: none;
            }

            .timeline-item {
                flex-direction: column;
            }

            .timeline-item:nth-child(odd) .timeline-content,
            .timeline-item:nth-child(even) .timeline-content {
                margin: 0;
                text-align: left;
                max-width: 100%;
            }

            .timeline-dot {
                order: -1;
            }
        }
    </style>
</head>
<body>
    <header style="background: var(--color-english-violet); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
    <div class="capsule-page">
        <div class="capsule-container">
            <div class="capsule-header">
                <h1 class="capsule-title">⏳ Time Capsule</h1>
                <p class="capsule-subtitle">Messages to your future self and preserved memories from your past</p>
            </div>

            <div class="timeline">
                <!-- Capsule 1 - Locked (Future) -->
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="capsule-card locked">
                            <div class="capsule-date">📅 July 15, 2024 (52 days from now)</div>
                            <div class="capsule-title-inner">
                                <span class="lock-icon">🔒</span>
                                To My Summer Self
                            </div>
                            <div class="capsule-content">
                                Message locked until the scheduled date. Remember to reflect on your progress toward your summer goals.
                            </div>
                            <div class="capsule-meta">
                                <div class="meta-item">🎯 Personal Growth</div>
                                <div class="meta-item">📊 Unlocks in 52 days</div>
                            </div>
                            <div class="capsule-actions">
                                <button class="btn-view" disabled>🔒 Unlock July 15</button>
                                <button class="btn-share" disabled>⋮</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Capsule 2 - Locked (Future) -->
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="capsule-card locked">
                            <div class="capsule-date">📅 December 25, 2024 (258 days from now)</div>
                            <div class="capsule-title-inner">
                                <span class="lock-icon">🔒</span>
                                Christmas Message to Myself
                            </div>
                            <div class="capsule-content">
                                A message of hope and reflection for the holiday season. You'll open this to celebrate how far you've come.
                            </div>
                            <div class="capsule-meta">
                                <div class="meta-item">🎄 Celebration</div>
                                <div class="meta-item">📊 Unlocks in 258 days</div>
                            </div>
                            <div class="capsule-actions">
                                <button class="btn-view" disabled>🔒 Unlock Dec 25</button>
                                <button class="btn-share" disabled>⋮</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Capsule 3 - Unlocked (Past) -->
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="capsule-card">
                            <div class="capsule-date">📅 April 10, 2024 (Yesterday)</div>
                            <div class="capsule-title-inner">
                                ✨ Reflection on My Growth
                            </div>
                            <div class="capsule-content">
                                "This past month has been transformative. I've started meditating daily, reconnected with old friends, and feel more aligned with my values. The anxiety I felt about changing jobs has turned into excitement about the opportunity ahead."
                            </div>
                            <div class="capsule-meta">
                                <div class="meta-item"><span class="mood-indicator"></span> Excited</div>
                                <div class="meta-item">👥 Personal</div>
                                <div class="meta-item">📖 Opened 18 times</div>
                            </div>
                            <div class="capsule-actions">
                                <button class="btn-view">✓ View Full</button>
                                <button class="btn-share">📤 Share</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Capsule 4 - Unlocked (Past) -->
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="capsule-card">
                            <div class="capsule-date">📅 March 15, 2024</div>
                            <div class="capsule-title-inner">
                                💭 My March Manifesto
                            </div>
                            <div class="capsule-content">
                                "I commit to prioritizing my mental health. No more sacrificing self-care for work. I am worthy of rest, joy, and meaningful connections. This month marks a new chapter of intentional living."
                            </div>
                            <div class="capsule-meta">
                                <div class="meta-item"><span class="mood-indicator" style="background: var(--color-rose-quartz);"></span> Hopeful</div>
                                <div class="meta-item">🎯 Goals</div>
                                <div class="meta-item">📖 Opened 24 times</div>
                            </div>
                            <div class="capsule-actions">
                                <button class="btn-view">✓ View Full</button>
                                <button class="btn-share">📤 Share</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Capsule 5 - Unlocked (Past) -->
                <div class="timeline-item">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <div class="capsule-card">
                            <div class="capsule-date">📅 February 1, 2024</div>
                            <div class="capsule-title-inner">
                                📝 Letter to Past Me
                            </div>
                            <div class="capsule-content">
                                "Dear February self, the anxiety you're feeling right now is temporary. In two months, you'll look back and be proud of the choices you made. Trust yourself. Your resilience is stronger than you think."
                            </div>
                            <div class="capsule-meta">
                                <div class="meta-item"><span class="mood-indicator" style="background: #E2C2BC;"></span> Vulnerable</div>
                                <div class="meta-item">💪 Encouragement</div>
                                <div class="meta-item">📖 Opened 31 times</div>
                            </div>
                            <div class="capsule-actions">
                                <button class="btn-view">✓ View Full</button>
                                <button class="btn-share">📤 Share</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Create New Capsule -->
            <div class="create-capsule">
                <div class="create-icon">✉️</div>
                <div class="create-text">Create New Time Capsule</div>
                <div class="create-subtext">Write a message to your future self or save a precious memory from today</div>
            </div>
        </div>
    </div>
</body>
</html>
