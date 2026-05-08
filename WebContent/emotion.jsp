<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userEmail = (String) session.getAttribute("userEmail");
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
    <title>Log Emotion - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .emotion-layout {
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
            align-items: center;
            min-height: 100vh;
            transition: margin-left 0.3s ease-in-out, width 0.3s ease-in-out;
        }

        .emotion-container {
            width: 100%;
            max-width: 700px;
            box-sizing: border-box;
            margin-bottom: var(--space-3xl);
        }

        .emotion-header {
            text-align: center;
            margin-bottom: var(--space-3xl);
            padding-bottom: 0;
            border-bottom: none;
        }

        .emotion-title {
            font-size: var(--font-size-4xl);
            color: var(--color-heather);
            margin-bottom: var(--space-md);
            margin-top: 0;
            font-family: var(--font-secondary);
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .emotion-subtitle {
            font-size: var(--font-size-base);
            color: var(--color-azur);
            margin: 0;
            line-height: var(--line-height-relaxed);
            font-weight: var(--font-weight-normal);
        }

        .emotion-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-3xl) var(--space-2xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
            animation: fade-in-up 0.6s ease-out;
            width: 100%;
            box-sizing: border-box;
        }

        .form-group {
            margin-bottom: var(--space-3xl);
            padding-bottom: 0;
            border-bottom: none;
            width: 100%;
            box-sizing: border-box;
        }

        .form-group:last-of-type {
            border-bottom: none;
            margin-bottom: var(--space-2xl);
        }

        .form-label {
            display: block;
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
            margin-bottom: var(--space-lg);
            font-size: var(--font-size-lg);
            font-family: var(--font-secondary);
            letter-spacing: -0.3px;
            width: 100%;
            text-align: left;
        }

        .mood-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: var(--space-lg);
            margin-bottom: 0;
            width: 100%;
            box-sizing: border-box;
            padding: var(--space-lg) 0;
        }

        .mood-option {
            position: relative;
        }

        .mood-option input {
            display: none;
        }

        .mood-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: var(--space-md);
            padding: var(--space-lg);
            background: var(--color-cream);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-lg);
            cursor: pointer;
            transition: all var(--transition-base);
            text-align: center;
        }

        .mood-option input:checked + .mood-label {
            background: var(--color-sandstone);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 4px rgba(103, 159, 159, 0.15);
            transform: translateY(-3px);
        }

        .mood-emoji {
            font-size: var(--font-size-4xl);
        }

        .mood-name {
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-semibold);
            color: var(--color-azur);
        }

        .intensity-slider {
            width: 100%;
            height: 10px;
            border-radius: var(--radius-full);
            background: linear-gradient(to right, #FBF8F3, #D4C4B9);
            outline: none;
            -webkit-appearance: none;
            appearance: none;
            margin: var(--space-2xl) 0 var(--space-xl) 0;
            cursor: pointer;
            padding: 0;
        }

        .intensity-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 28px;
            height: 28px;
            border-radius: var(--radius-full);
            background: var(--color-viridian);
            cursor: pointer;
            box-shadow: var(--shadow-md);
            transition: all var(--transition-base);
        }

        .intensity-slider::-moz-range-thumb {
            width: 28px;
            height: 28px;
            border-radius: var(--radius-full);
            background: var(--color-viridian);
            cursor: pointer;
            box-shadow: var(--shadow-md);
            border: none;
            transition: all var(--transition-base);
        }

        .intensity-slider::-webkit-slider-thumb:hover,
        .intensity-slider::-moz-range-thumb:hover {
            width: 32px;
            height: 32px;
            box-shadow: var(--shadow-lg);
        }

        .intensity-container {
            padding: var(--space-lg) 0;
            width: 100%;
            box-sizing: border-box;
        }

        .intensity-labels {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-lg);
            font-weight: var(--font-weight-medium);
            gap: var(--space-lg);
        }

        .intensity-center {
            display: flex;
            align-items: center;
            gap: var(--space-sm);
            justify-content: center;
        }

        .intensity-number {
            font-family: var(--font-secondary);
            font-weight: 700;
            color: var(--color-heather);
            font-size: var(--font-size-2xl);
            min-width: 40px;
            text-align: center;
        }

        .intensity-label-text {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            font-weight: var(--font-weight-medium);
        }

        .intensity-display {
            display: flex;
            align-items: center;
            gap: var(--space-lg);
            margin-top: var(--space-2xl);
            padding: var(--space-xl) var(--space-lg);
            background: rgba(230, 212, 191, 0.15);
            border-radius: var(--radius-lg);
            border: 1px solid rgba(230, 212, 191, 0.4);
        }

        .intensity-number-old {
            font-family: var(--font-secondary);
            font-weight: 700;
            color: var(--color-heather);
            font-size: var(--font-size-3xl);
            min-width: 50px;
        }

        .intensity-text {
            font-size: var(--font-size-base);
            color: var(--color-azur);
            font-weight: var(--font-weight-semibold);
        }

        .intensity-scale {
            display: flex;
            gap: var(--space-lg);
            margin-left: auto;
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            font-weight: var(--font-weight-medium);
        }

        .form-control {
            width: 100%;
            padding: var(--space-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            background: var(--color-cream);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-lg);
            color: var(--color-azur);
            transition: all var(--transition-base);
            resize: vertical;
            min-height: 90px;
            line-height: var(--line-height-loose);
            box-sizing: border-box;
        }

        .form-control::placeholder {
            color: var(--color-warm-gray);
        }

        .form-control:focus {
            outline: none;
            background: var(--color-white);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 4px rgba(103, 159, 159, 0.1);
        }

        .form-help {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-top: var(--space-md);
            font-style: italic;
        }

        .form-help-top {
            font-size: var(--font-size-sm);
            color: var(--color-azur);
            margin: var(--space-md) 0;
            font-weight: var(--font-weight-medium);
        }

        .submit-btn {
            width: 100%;
            padding: var(--space-lg) var(--space-xl);
            background: var(--color-viridian);
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: all var(--transition-base);
            margin-top: var(--space-2xl);
            box-shadow: var(--shadow-md);
            letter-spacing: 0.5px;
            box-sizing: border-box;
        }

        .submit-btn:hover {
            background: #5F8A8A;
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
        }

        .submit-btn:active {
            transform: translateY(-1px);
        }

        .success-message {
            background: #E8F5E9;
            border-left: 4px solid var(--color-viridian);
            color: #1B5E20;
            padding: var(--space-lg) var(--space-xl);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-3xl);
            animation: fade-in-up 0.4s ease-out;
            font-weight: var(--font-weight-medium);
            font-size: var(--font-size-base);
        }

        .error-message {
            background: #FCE4E9;
            border-left: 4px solid var(--color-candy);
            color: #C91D5F;
            padding: var(--space-lg) var(--space-xl);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-3xl);
            animation: fade-in-up 0.4s ease-out;
            font-weight: var(--font-weight-medium);
            font-size: var(--font-size-base);
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-2xl) var(--space-lg);
            }

            .emotion-card {
                padding: var(--space-2xl) var(--space-lg);
            }

            .emotion-title {
                font-size: var(--font-size-2xl);
            }

            .emotion-header {
                margin-bottom: var(--space-2xl);
            }

            .mood-selector {
                grid-template-columns: repeat(3, 1fr);
                gap: var(--space-md);
            }

            .form-group {
                margin-bottom: var(--space-2xl);
                padding-bottom: var(--space-lg);
            }
        }
    </style>
</head>
<body>
    <div class="emotion-layout">
        <!-- Sidebar -->
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="emotion" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="emotion-container">
                <div class="emotion-header">
                    <h1 class="emotion-title">💭 Log Your Emotion</h1>
                    <p class="emotion-subtitle">Check in with yourself and understand what you're feeling</p>
                </div>

                <div class="emotion-card">
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="success-message">
                            ✓ <%= request.getAttribute("success") %>
                        </div>
                    <% } %>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="error-message">
                            ✗ <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/emotion" method="post">
                        <!-- What Triggered This Feeling -->
                        <div class="form-group">
                            <label class="form-label">What triggered this feeling?</label>
                            <textarea 
                                id="trigger" 
                                name="trigger" 
                                class="form-control" 
                                placeholder="Describe the situation or event (optional)"></textarea>
                        </div>

                        <!-- Mood Selection -->
                        <div class="form-group">
                            <label class="form-label">How are you feeling right now?</label>
                            <div class="mood-selector">
                                <div class="mood-option">
                                    <input type="radio" id="mood_happy" name="mood" value="Happy" required>
                                    <label for="mood_happy" class="mood-label">
                                        <span class="mood-emoji">😊</span>
                                        <span class="mood-name">Happy</span>
                                    </label>
                                </div>
                                <div class="mood-option">
                                    <input type="radio" id="mood_calm" name="mood" value="Calm">
                                    <label for="mood_calm" class="mood-label">
                                        <span class="mood-emoji">😌</span>
                                        <span class="mood-name">Calm</span>
                                    </label>
                                </div>
                                <div class="mood-option">
                                    <input type="radio" id="mood_sad" name="mood" value="Sad">
                                    <label for="mood_sad" class="mood-label">
                                        <span class="mood-emoji">😢</span>
                                        <span class="mood-name">Sad</span>
                                    </label>
                                </div>
                                <div class="mood-option">
                                    <input type="radio" id="mood_anxious" name="mood" value="Anxious">
                                    <label for="mood_anxious" class="mood-label">
                                        <span class="mood-emoji">😰</span>
                                        <span class="mood-name">Anxious</span>
                                    </label>
                                </div>
                                <div class="mood-option">
                                    <input type="radio" id="mood_angry" name="mood" value="Angry">
                                    <label for="mood_angry" class="mood-label">
                                        <span class="mood-emoji">😠</span>
                                        <span class="mood-name">Angry</span>
                                    </label>
                                </div>
                                <div class="mood-option">
                                    <input type="radio" id="mood_neutral" name="mood" value="Neutral">
                                    <label for="mood_neutral" class="mood-label">
                                        <span class="mood-emoji">😐</span>
                                        <span class="mood-name">Neutral</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Intensity Slider -->
                        <div class="form-group">
                            <label class="form-label">How intense is this emotion?</label>
                            <div class="intensity-container">
                                <div style="display: flex; justify-content: space-between; font-size: var(--font-size-sm); color: var(--color-warm-gray); margin-bottom: var(--space-lg); font-weight: var(--font-weight-medium);">
                                    <span>Mild</span>
                                    <span>Moderate</span>
                                    <span>Intense</span>
                                </div>
                                <input type="range" id="intensity" name="intensity" min="1" max="10" value="5" class="intensity-slider">
                                <div style="display: flex; justify-content: center; align-items: center; margin-top: var(--space-xl); gap: var(--space-md);">
                                    <span id="intensity-value" class="intensity-number">5</span>
                                    <span class="intensity-label-text">out of 10</span>
                                </div>
                            </div>
                        </div>

                        <!-- Response/Coping -->
                        <div class="form-group">
                            <label class="form-label">How did you respond or cope?</label>
                            <p class="form-help-top">Describe your reaction or coping strategy</p>
                            <textarea 
                                id="response" 
                                name="response" 
                                class="form-control" 
                                placeholder="What action did you take? How did you process this emotion? What helped you?"></textarea>
                        </div>

                        <!-- Submit -->
                        <button type="submit" class="submit-btn">💾 Save Emotion Entry</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        const intensitySlider = document.getElementById('intensity');
        const intensityValue = document.getElementById('intensity-value');

        intensitySlider.addEventListener('input', function() {
            intensityValue.textContent = this.value;
        });
    </script>
</body>
</html>