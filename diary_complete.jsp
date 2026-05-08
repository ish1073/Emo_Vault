<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Diary</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .diary-page {
            min-height: 100vh;
            background: var(--color-van-dyke);
            padding: var(--space-xl);
        }

        .diary-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .diary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-2xl);
            flex-wrap: wrap;
            gap: var(--space-lg);
        }

        .diary-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            font-weight: 700;
        }

        .diary-controls {
            display: flex;
            gap: var(--space-sm);
        }

        .btn-control {
            padding: var(--space-sm) var(--space-lg);
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            color: var(--color-pale-dogwood);
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 600;
            transition: all var(--transition-fast);
        }

        .btn-control:hover {
            border-color: var(--color-puce);
            background: var(--color-puce);
            color: #FFF;
        }

        .diary-meta {
            display: flex;
            gap: var(--space-lg);
            margin-bottom: var(--space-xl);
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: var(--space-sm);
            color: var(--color-text-soft);
        }

        .meta-label {
            font-weight: 600;
        }

        .meta-value {
            color: var(--color-puce);
        }

        .entry-editor {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 2px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-bottom: var(--space-xl);
            animation: slideUp 0.6s ease-out;
        }

        .editor-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-lg);
            padding-bottom: var(--space-lg);
            border-bottom: 1px solid var(--glass-border);
        }

        .editor-date {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
        }

        .editor-tools {
            display: flex;
            gap: var(--space-sm);
        }

        .tool-btn {
            width: 36px;
            height: 36px;
            border-radius: var(--radius-sm);
            background: var(--glass-overlay);
            border: 1px solid var(--glass-border);
            color: var(--color-pale-dogwood);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all var(--transition-fast);
        }

        .tool-btn:hover {
            border-color: var(--color-puce);
            background: var(--color-puce);
            color: #FFF;
        }

        .entry-title-input {
            width: 100%;
            background: transparent;
            border: none;
            color: var(--color-pale-dogwood);
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: var(--space-lg);
            font-family: 'Playfair Display', serif;
            outline: none;
            padding: 0;
        }

        .entry-title-input::placeholder {
            color: var(--color-text-muted);
        }

        .entry-textarea {
            width: 100%;
            min-height: 400px;
            background: transparent;
            border: none;
            color: var(--color-text-soft);
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            line-height: 1.8;
            resize: vertical;
            outline: none;
            padding: 0;
        }

        .entry-textarea::placeholder {
            color: var(--color-text-muted);
        }

        .editor-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: var(--space-lg);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--glass-border);
        }

        .word-count {
            color: var(--color-text-muted);
            font-size: 0.85rem;
        }

        .editor-actions {
            display: flex;
            gap: var(--space-sm);
        }

        .btn-cancel {
            padding: var(--space-sm) var(--space-lg);
            background: transparent;
            border: 1px solid var(--color-rose-quartz);
            color: var(--color-rose-quartz);
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 600;
            transition: all var(--transition-fast);
        }

        .btn-cancel:hover {
            background: var(--color-rose-quartz);
            color: #FFF;
        }

        .btn-save {
            padding: var(--space-sm) var(--space-xl);
            background: var(--color-puce);
            border: none;
            color: #FFF;
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            transition: all var(--transition-base);
            box-shadow: var(--shadow-glow);
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 40px rgba(191, 113, 133, 0.5);
        }

        .entry-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-xl);
        }

        .option-group {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            animation: slideUp 0.6s ease-out;
        }

        .option-label {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: var(--space-md);
            display: block;
        }

        .mood-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: var(--space-sm);
        }

        .mood-option {
            padding: var(--space-sm);
            background: var(--glass-overlay);
            border: 2px solid var(--glass-border);
            border-radius: var(--radius-md);
            cursor: pointer;
            text-align: center;
            transition: all var(--transition-fast);
            color: var(--color-pale-dogwood);
            font-weight: 600;
            font-size: 0.85rem;
        }

        .mood-option:hover {
            border-color: var(--color-puce);
            background: var(--color-puce);
            color: #FFF;
        }

        .mood-option.selected {
            background: var(--color-puce);
            border-color: var(--color-puce);
            color: #FFF;
            box-shadow: var(--shadow-glow);
        }

        .toggle-option {
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }

        .toggle-switch {
            width: 44px;
            height: 24px;
            background: var(--glass-overlay);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            cursor: pointer;
            position: relative;
            transition: all var(--transition-fast);
        }

        .toggle-switch.active {
            background: var(--color-puce);
            border-color: var(--color-puce);
        }

        .toggle-knob {
            width: 20px;
            height: 20px;
            background: #FFF;
            border-radius: 50%;
            position: absolute;
            top: 2px;
            left: 2px;
            transition: all var(--transition-fast);
        }

        .toggle-switch.active .toggle-knob {
            left: 22px;
        }

        .toggle-label {
            color: var(--color-text-soft);
            font-size: 0.9rem;
        }

        .past-entries {
            margin-top: var(--space-2xl);
        }

        .past-title {
            color: var(--color-pale-dogwood);
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: var(--space-lg);
        }

        .entry-preview {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-bottom: var(--space-lg);
            cursor: pointer;
            transition: all var(--transition-base);
            animation: slideUp 0.6s ease-out;
        }

        .entry-preview:hover {
            border-color: var(--color-puce);
            transform: translateY(-4px);
            box-shadow: var(--shadow-glow);
        }

        .entry-preview-date {
            color: var(--color-puce);
            font-weight: 700;
            font-size: 0.85rem;
            margin-bottom: var(--space-sm);
        }

        .entry-preview-title {
            color: var(--color-pale-dogwood);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: var(--space-sm);
        }

        .entry-preview-excerpt {
            color: var(--color-text-soft);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: var(--space-sm);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .entry-preview-meta {
            display: flex;
            gap: var(--space-lg);
            font-size: 0.85rem;
            color: var(--color-text-muted);
        }

        @media (max-width: 768px) {
            .entry-textarea {
                min-height: 300px;
            }

            .mood-selector {
                grid-template-columns: repeat(2, 1fr);
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
    <div class="diary-page">
        <div class="diary-container">
            <div class="diary-header">
                <h1 class="diary-title">📖 My Diary</h1>
                <div class="diary-controls">
                    <button class="btn-control">📋 All Entries</button>
                    <button class="btn-control">🔍 Search</button>
                </div>
            </div>

            <!-- Entry Metadata -->
            <div class="diary-meta">
                <div class="meta-item">
                    <span class="meta-label">📅 Today:</span>
                    <span class="meta-value">April 11, 2024</span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">⏰ Time:</span>
                    <span class="meta-value">3:45 PM</span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">📊 Entries this month:</span>
                    <span class="meta-value">28</span>
                </div>
            </div>

            <!-- New Entry Options -->
            <div class="entry-options">
                <div class="option-group">
                    <label class="option-label">How are you feeling?</label>
                    <div class="mood-selector">
                        <button class="mood-option">😊 Happy</button>
                        <button class="mood-option">😌 Calm</button>
                        <button class="mood-option">😰 Anxious</button>
                        <button class="mood-option">😢 Sad</button>
                        <button class="mood-option selected">😐 Neutral</button>
                        <button class="mood-option">🤩 Excited</button>
                    </div>
                </div>

                <div class="option-group">
                    <label class="option-label">Privacy</label>
                    <div class="toggle-option">
                        <div class="toggle-switch active">
                            <div class="toggle-knob"></div>
                        </div>
                        <span class="toggle-label">Private</span>
                    </div>
                </div>
            </div>

            <!-- Entry Editor -->
            <div class="entry-editor">
                <div class="editor-header">
                    <div class="editor-date">April 11, 2024</div>
                    <div class="editor-tools">
                        <button class="tool-btn" title="Bold">B</button>
                        <button class="tool-btn" title="Italic">I</button>
                        <button class="tool-btn" title="Underline">U</button>
                    </div>
                </div>

                <input type="text" class="entry-title-input" placeholder="Give your entry a title...">

                <textarea class="entry-textarea" placeholder="Start writing your thoughts and feelings... Let it flow naturally. Remember, this space is entirely yours."></textarea>

                <div class="editor-footer">
                    <div class="word-count">Words: 0 | Characters: 0</div>
                    <div class="editor-actions">
                        <button class="btn-cancel">Cancel</button>
                        <button class="btn-save">💾 Save Entry</button>
                    </div>
                </div>
            </div>

            <!-- Past Entries -->
            <div class="past-entries">
                <h3 class="past-title">Recent Entries</h3>

                <div class="entry-preview">
                    <div class="entry-preview-date">April 10, 2024</div>
                    <div class="entry-preview-title">A Day of Reflection and Growth</div>
                    <div class="entry-preview-excerpt">
                        Today was a turning point for me. I finally said yes to the job opportunity I've been hesitating about. The fear is still there, but I've decided to trust myself...
                    </div>
                    <div class="entry-preview-meta">
                        <span>😊 Excited</span>
                        <span>1,247 words</span>
                        <span>🔒 Private</span>
                    </div>
                </div>

                <div class="entry-preview">
                    <div class="entry-preview-date">April 9, 2024</div>
                    <div class="entry-preview-title">Morning Thoughts: New Perspectives</div>
                    <div class="entry-preview-excerpt">
                        Woke up this morning feeling different. Maybe it's the meditation practice, or maybe it's just time catching up. Either way, I feel more grounded...
                    </div>
                    <div class="entry-preview-meta">
                        <span>😌 Calm</span>
                        <span>856 words</span>
                        <span>🔒 Private</span>
                    </div>
                </div>

                <div class="entry-preview">
                    <div class="entry-preview-date">April 8, 2024</div>
                    <div class="entry-preview-title">Dealing with Self-Doubt</div>
                    <div class="entry-preview-excerpt">
                        Today was challenging. I found myself spiraling into negative thoughts about my abilities. But I recognized the pattern and used the techniques...
                    </div>
                    <div class="entry-preview-meta">
                        <span>😢 Vulnerable</span>
                        <span>1,123 words</span>
                        <span>🔒 Private</span>
                    </div>
                </div>

                <div class="entry-preview">
                    <div class="entry-preview-date">April 7, 2024</div>
                    <div class="entry-preview-title">Weekend Adventures</div>
                    <div class="entry-preview-excerpt">
                        Spent the weekend hiking with friends. The fresh air and physical activity reminded me of how important it is to disconnect from work stress...
                    </div>
                    <div class="entry-preview-meta">
                        <span>🤩 Excited</span>
                        <span>932 words</span>
                        <span>🔒 Private</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
