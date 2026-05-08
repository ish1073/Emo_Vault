<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Log Emotion</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .emotion-page {
            min-height: 100vh;
            background: var(--color-van-dyke);
            padding: var(--space-xl);
        }

        .emotion-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .emotion-header {
            text-align: center;
            margin-bottom: var(--space-3xl);
        }

        .emotion-title {
            color: var(--color-pale-dogwood);
            font-size: 2.2rem;
            margin-bottom: var(--space-md);
        }

        .emotion-subtitle {
            color: var(--color-text-soft);
            font-size: 1rem;
        }

        .emotion-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: var(--space-2xl);
            box-shadow: var(--shadow-lg);
            animation: slideUp 0.6s ease-out;
        }

        .mood-selector {
            margin-bottom: var(--space-2xl);
        }

        .mood-label {
            color: var(--color-pale-dogwood);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: var(--space-lg);
            text-align: center;
        }

        .mood-chips {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: var(--space-md);
            margin-bottom: var(--space-lg);
        }

        .mood-chip {
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            border: 2px solid var(--color-rose-quartz);
            background: transparent;
            color: var(--color-pale-dogwood);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-base);
            text-align: center;
            font-size: 0.95rem;
        }

        .mood-chip:hover {
            background: var(--glass-overlay);
            border-color: var(--color-puce);
            transform: scale(1.05);
        }

        .mood-chip.active {
            background: var(--color-puce);
            border-color: var(--color-puce);
            color: #FFF;
            box-shadow: var(--shadow-glow);
        }

        .emotion-scale {
            margin-bottom: var(--space-2xl);
        }

        .scale-label {
            color: var(--color-pale-dogwood);
            font-weight: 600;
            margin-bottom: var(--space-md);
        }

        .scale-input {
            width: 100%;
            height: 8px;
            background: var(--glass-overlay);
            border-radius: var(--radius-xl);
            outline: none;
            -webkit-appearance: none;
        }

        .scale-input::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--gradient-button);
            cursor: pointer;
            box-shadow: var(--shadow-glow);
            transition: all var(--transition-fast);
        }

        .scale-input::-moz-range-thumb {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--gradient-button);
            cursor: pointer;
            border: none;
            box-shadow: var(--shadow-glow);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-label {
            display: block;
            color: var(--color-pale-dogwood);
            font-weight: 600;
            margin-bottom: var(--space-sm);
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .form-textarea {
            width: 100%;
            padding: var(--space-lg);
            background: var(--color-pale-dogwood);
            border: 2px solid var(--color-rose-quartz);
            border-radius: var(--radius-md);
            color: var(--color-van-dyke);
            font-family: var(--font-primary);
            font-size: 0.95rem;
            resize: vertical;
            min-height: 120px;
            transition: all var(--transition-base);
        }

        .form-textarea:focus {
            outline: none;
            border-color: var(--color-puce);
            box-shadow: 0 0 0 4px rgba(191, 113, 133, 0.2);
        }

        .form-textarea::placeholder {
            color: var(--color-rose-quartz);
            opacity: 0.6;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            margin-bottom: var(--space-md);
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            accent-color: var(--color-puce);
            cursor: pointer;
        }

        .checkbox-group label {
            color: var(--color-text-soft);
            cursor: pointer;
            margin: 0;
        }

        .emotion-actions {
            display: flex;
            gap: var(--space-lg);
            margin-top: var(--space-2xl);
        }

        .btn-submit {
            flex: 1;
            padding: var(--space-lg);
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

        .btn-submit:hover {
            transform: translateY(-4px);
            box-shadow: 0 0 40px rgba(191, 113, 133, 0.5);
        }

        .btn-cancel {
            flex: 1;
            padding: var(--space-lg);
            background: transparent;
            color: var(--color-puce);
            border: 2px solid var(--color-puce);
            border-radius: var(--radius-md);
            font-weight: 600;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all var(--transition-base);
        }

        .btn-cancel:hover {
            background: rgba(191, 113, 133, 0.1);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <header style="background: var(--color-english-violet); padding: var(--space-lg); margin-bottom: var(--space-xl);">
        <a href="dashboard_complete.jsp" style="color: var(--color-pale-dogwood); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: var(--space-sm); width: fit-content;">
            <span>← Back to Dashboard</span>
        </a>
    </header>
    <div class="emotion-page">
        <div class="emotion-container">
            <div class="emotion-header">
                <h1 class="emotion-title">🎯 How Are You Feeling?</h1>
                <p class="emotion-subtitle">Track your emotional state to understand patterns and improve wellbeing</p>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/emotion" class="emotion-card">
                <!-- Mood Selection -->
                <div class="mood-selector">
                    <div class="mood-label">Select Your Primary Emotion</div>
                    <div class="mood-chips">
                        <button type="button" class="mood-chip" onclick="setMood(this, 'happy')">😊 Happy</button>
                        <button type="button" class="mood-chip" onclick="setMood(this, 'sad')">😢 Sad</button>
                        <button type="button" class="mood-chip" onclick="setMood(this, 'angry')">😠 Angry</button>
                        <button type="button" class="mood-chip" onclick="setMood(this, 'anxious')">😰 Anxious</button>
                        <button type="button" class="mood-chip" onclick="setMood(this, 'calm')">😌 Calm</button>
                        <button type="button" class="mood-chip" onclick="setMood(this, 'excited')">🤩 Excited</button>
                    </div>
                    <input type="hidden" name="mood" id="mood_value">
                </div>

                <!-- Intensity Scale -->
                <div class="emotion-scale">
                    <div class="scale-label">Emotional Intensity</div>
                    <p style="color: var(--color-text-muted); font-size: 0.85rem; margin-bottom: var(--space-md);">1 (Low) to 10 (High)</p>
                    <input type="range" class="scale-input" name="intensity" min="1" max="10" value="5">
                </div>

                <!-- Triggers -->
                <div class="form-group">
                    <label class="form-label">What Triggered This Emotion?</label>
                    <textarea class="form-textarea" name="trigger" placeholder="Describe what caused this feeling..."></textarea>
                </div>

                <!-- Notes -->
                <div class="form-group">
                    <label class="form-label">Additional Notes</label>
                    <textarea class="form-textarea" name="notes" placeholder="Any additional thoughts or observations..."></textarea>
                </div>

                <!-- Options -->
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="private" name="private">
                        <label for="private">Keep this entry private</label>
                    </div>
                </div>

                <!-- Actions -->
                <div class="emotion-actions">
                    <button type="submit" class="btn-submit">Save Emotion Log</button>
                    <button type="button" class="btn-cancel" onclick="history.back()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function setMood(element, mood) {
            document.querySelectorAll('.mood-chip').forEach(chip => chip.classList.remove('active'));
            element.classList.add('active');
            document.getElementById('mood_value').value = mood;
        }
    </script>
</body>
</html>
