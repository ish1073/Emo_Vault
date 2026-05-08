<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

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
    <title>EmoVault - Log Your Emotion</title>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #E2C2BC 0%, #F0E8E4 50%, #E2C2BC 100%);
            color: #3D2B27;
        }

        body {
            background-attachment: fixed;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(191, 113, 133, 0.15);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 8px rgba(61, 43, 39, 0.08);
        }

        .navbar > div {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 2rem;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: #3D2B27;
            font-family: 'Merriweather', serif;
            letter-spacing: 0.5px;
        }

        .navbar-menu {
            flex: 1;
            display: flex;
            gap: 1.5rem;
            align-items: center;
            font-size: 0.95rem;
        }

        .navbar-menu a {
            color: #3D2B27;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            opacity: 0.85;
        }

        .navbar-menu a:hover {
            opacity: 1;
            color: #BF7185;
            background: rgba(191, 113, 133, 0.1);
        }

        .emotion-page {
            min-height: calc(100vh - 80px);
            padding: 3rem 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .emotion-container {
            max-width: 600px;
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 2.5rem;
        }

        .emotion-header {
            text-align: center;
            animation: slideUp 0.6s ease-out;
        }

        .emotion-header h1 {
            font-size: 2.2rem;
            font-family: 'Merriweather', serif;
            color: #3D2B27;
            margin-bottom: 0.5rem;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .emotion-header p {
            color: #443C5E;
            font-size: 1rem;
            line-height: 1.6;
            font-weight: 500;
        }

        .emotion-card {
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 2.5rem;
            border: 1px solid #E2C2BC;
            box-shadow: 0 8px 32px rgba(61, 43, 39, 0.1);
            animation: slideUp 0.7s ease-out 0.1s both;
        }

        .emotion-section {
            margin-bottom: 2rem;
            padding-bottom: 0;
            border-bottom: none;
        }

        .emotion-section:last-of-type {
            margin-bottom: 1.5rem;
        }

        .emotion-section h3 {
            font-size: 1.1rem;
            color: #443C5E;
            margin-bottom: 1.2rem;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #443C5E;
            margin-bottom: 0.6rem;
            letter-spacing: 0.4px;
            text-transform: uppercase;
            opacity: 0.9;
        }

        .form-group input:not([type="radio"]),
        .form-group textarea {
            width: 100%;
            padding: 1rem 1.2rem;
            border: 2px solid #E2C2BC;
            border-radius: 12px;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.7);
            color: #3D2B27;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
        }

        .form-group input:not([type="radio"])::placeholder,
        .form-group textarea::placeholder {
            color: #A99FBF;
            opacity: 0.7;
        }

        .form-group input:not([type="radio"]):focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #BF7185;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 0 0 4px rgba(191, 113, 133, 0.1);
            transform: translateY(-2px);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.6;
        }

        .mood-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
        }

        .mood-option {
            display: flex;
            align-items: center;
        }

        .mood-option input[type="radio"] {
            display: none;
        }

        .mood-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            padding: 1.2rem;
            background: rgba(255, 255, 255, 0.5);
            border: 1.5px solid #E2C2BC;
            border-radius: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1.8rem;
            font-weight: 600;
            color: #A99FBF;
            margin: 0;
            width: 100%;
        }

        .mood-label > span {
            font-size: 0.75rem;
            color: #3D2B27;
            font-weight: 600;
            text-transform: capitalize;
        }

        .mood-option input[type="radio"]:checked + .mood-label {
            background: rgba(191, 113, 133, 0.15);
            border-color: #BF7185;
            color: #BF7185;
            box-shadow: 0 4px 12px rgba(191, 113, 133, 0.2);
            transform: scale(1.05) translateY(-2px);
        }

        .mood-label:hover {
            background: rgba(191, 113, 133, 0.1);
            border-color: #BF7185;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(191, 113, 133, 0.15);
        }

        .intensity-section {
            background: rgba(191, 113, 133, 0.06);
            padding: 1.5rem;
            border-radius: 14px;
            border: 1px solid rgba(191, 113, 133, 0.15);
        }

        .intensity-labels {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
        }

        .intensity-label {
            font-size: 0.8rem;
            color: #443C5E;
            font-weight: 600;
        }

        .intensity-slider input[type="range"] {
            width: 100%;
            height: 8px;
            border-radius: 10px;
            background: linear-gradient(to right, #A99FBF 0%, #BF7185 100%);
            outline: none;
            -webkit-appearance: none;
            appearance: none;
            cursor: pointer;
        }

        .intensity-slider input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: white;
            border: 2px solid #BF7185;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(191, 113, 133, 0.3);
        }

        .intensity-slider input[type="range"]::-webkit-slider-thumb:hover {
            transform: scale(1.2);
            box-shadow: 0 4px 12px rgba(191, 113, 133, 0.4);
        }

        .intensity-slider input[type="range"]::-moz-range-thumb {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: white;
            border: 2px solid #BF7185;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(191, 113, 133, 0.3);
        }

        .intensity-slider input[type="range"]::-moz-range-thumb:hover {
            transform: scale(1.2);
            box-shadow: 0 4px 12px rgba(191, 113, 133, 0.4);
        }

        .intensity-display {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin-top: 1.2rem;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            border: 1px solid #E2C2BC;
        }

        .intensity-value {
            font-family: 'Merriweather', serif;
            font-weight: 700;
            color: #BF7185;
            font-size: 1.8rem;
        }

        .intensity-text {
            color: #443C5E;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .emotion-button {
            width: 100%;
            padding: 1.2rem 1.5rem;
            background: linear-gradient(135deg, #3D2B27 0%, #BF7185 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-top: 0.5rem;
            box-shadow: 0 4px 12px rgba(191, 113, 133, 0.25);
        }

        .emotion-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(191, 113, 133, 0.35);
        }

        .emotion-button:active {
            transform: translateY(0);
        }

        .emotion-quote {
            text-align: center;
            margin-top: 1.5rem;
            padding: 1.2rem;
            background: rgba(191, 113, 133, 0.08);
            border-radius: 12px;
            border-left: 3px solid #BF7185;
        }

        .emotion-quote p {
            font-family: 'Merriweather', serif;
            font-size: 1rem;
            color: #3D2B27;
            font-style: italic;
            font-weight: 500;
            opacity: 0.9;
        }

        .alert {
            padding: 1rem 1.2rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            border-left: 3px solid;
            animation: slideDown 0.4s ease-out;
        }

        .alert-error {
            background: rgba(225, 130, 153, 0.1);
            border-left-color: #E18299;
            color: #877499;
        }

        .alert-success {
            background: rgba(103, 159, 159, 0.1);
            border-left-color: #679F9F;
            color: #2D4729;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .emotion-card {
                padding: 1.5rem;
            }

            .mood-options {
                grid-template-columns: repeat(2, 1fr);
            }

            .emotion-header h1 {
                font-size: 1.8rem;
            }

            .navbar-menu {
                gap: 1rem;
                font-size: 0.85rem;
            }

            .navbar-menu a {
                padding: 0.4rem 0.8rem;
            }

            .emotion-page {
                padding: 2rem 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <div>
            <div class="navbar-brand">✨ EmoVault</div>
            <div class="navbar-menu">
                <a href="${pageContext.request.contextPath}/emotion.jsp">Emotions</a>
                <a href="${pageContext.request.contextPath}/diary.jsp">Diary</a>
                <a href="${pageContext.request.contextPath}/regret.jsp">Regrets</a>
                <a href="${pageContext.request.contextPath}/habit.jsp">Habits</a>
                <a href="${pageContext.request.contextPath}/alert.jsp">Alerts</a>
                <a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a>
                <span style="color: #877499; font-size: 0.9rem; margin-left: auto; font-weight: 500;">
                    Welcome, <strong><%= userName != null ? userName : "User" %></strong>
                </span>
                <a href="javascript:void(0)" onclick="logout()" style="color: #E18299; font-weight: 600;">Logout</a>
            </div>
        </div>
    </div>

    <div class="emotion-page">
        <div class="emotion-container">
            <div class="emotion-header">
                <h1>How are you feeling today?</h1>
                <p>Take a quiet moment to reflect on what's in your heart.<br>Your feelings matter, and they deserve to be understood.</p>
            </div>

            <div class="emotion-card">
                <!-- Error Message -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <!-- Success Message -->
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success">
                        ✓ <%= request.getAttribute("success") %>
                        <br><small>Your emotion has been recorded. Feel free to add another entry.</small>
                    </div>
                <% } %>

                <!-- Emotion Logging Form -->
                <form action="${pageContext.request.contextPath}/emotion" method="post">
                    <!-- Trigger Section -->
                    <div class="emotion-section">
                        <h3>What triggered this feeling?</h3>
                        <div class="form-group">
                            <label for="trigger">Describe the situation or event</label>
                            <input 
                                type="text" 
                                id="trigger" 
                                name="trigger" 
                                placeholder="E.g., A difficult conversation, good news, work challenge..." 
                                required>
                        </div>
                    </div>

                    <!-- Mood Selection -->
                    <div class="emotion-section">
                        <h3>How are you feeling right now?</h3>
                        <div class="mood-options">
                            <div class="mood-option">
                                <input type="radio" id="mood1" name="mood" value="Happy" required>
                                <label for="mood1" class="mood-label">
                                    😊
                                    <span>Happy</span>
                                </label>
                            </div>
                            <div class="mood-option">
                                <input type="radio" id="mood2" name="mood" value="Sad">
                                <label for="mood2" class="mood-label">
                                    😢
                                    <span>Sad</span>
                                </label>
                            </div>
                            <div class="mood-option">
                                <input type="radio" id="mood3" name="mood" value="Angry">
                                <label for="mood3" class="mood-label">
                                    😠
                                    <span>Angry</span>
                                </label>
                            </div>
                            <div class="mood-option">
                                <input type="radio" id="mood4" name="mood" value="Anxious">
                                <label for="mood4" class="mood-label">
                                    😰
                                    <span>Anxious</span>
                                </label>
                            </div>
                            <div class="mood-option">
                                <input type="radio" id="mood5" name="mood" value="Calm">
                                <label for="mood5" class="mood-label">
                                    😌
                                    <span>Calm</span>
                                </label>
                            </div>
                            <div class="mood-option">
                                <input type="radio" id="mood6" name="mood" value="Frustrated">
                                <label for="mood6" class="mood-label">
                                    😤
                                    <span>Frustrated</span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Intensity Section -->
                    <div class="emotion-section">
                        <h3>How intense is this emotion?</h3>
                        <div class="intensity-section">
                            <div class="intensity-labels">
                                <span class="intensity-label">Mild</span>
                                <span class="intensity-label">Moderate</span>
                                <span class="intensity-label">Intense</span>
                            </div>
                            <div class="intensity-slider">
                                <input 
                                    type="range" 
                                    id="intensity" 
                                    name="intensity" 
                                    min="1" 
                                    max="10" 
                                    value="5"
                                    required>
                            </div>
                            <div class="intensity-display">
                                <div class="intensity-value" id="intensityValue">5</div>
                                <div class="intensity-text">out of 10</div>
                            </div>
                        </div>
                    </div>

                    <!-- Response Section -->
                    <div class="emotion-section">
                        <h3>How did you respond or cope?</h3>
                        <div class="form-group">
                            <label for="response">Describe your reaction or coping strategy</label>
                            <textarea 
                                id="response" 
                                name="response" 
                                placeholder="What action did you take? How did you process this emotion? What helped you?" 
                                required></textarea>
                        </div>
                    </div>

                    <button type="submit" class="emotion-button">💾 Save Emotion Entry</button>
                </form>
            </div>

            <div class="emotion-quote">
                <p>"It's okay to feel everything. Your emotions are valid, and they matter."</p>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('intensity').addEventListener('input', function() {
            document.getElementById('intensityValue').textContent = this.value;
        });

        document.querySelector('form').addEventListener('submit', function(e) {
            const trigger = document.getElementById('trigger').value.trim();
            const mood = document.querySelector('input[name="mood"]:checked');
            const intensity = document.getElementById('intensity').value;
            const response = document.getElementById('response').value.trim();

            if (!trigger || !mood || !intensity || !response) {
                e.preventDefault();
                alert('Please fill in all fields');
                return;
            }

            if (trigger.length < 3) {
                e.preventDefault();
                alert('Please provide more details about the trigger');
                return;
            }

            if (response.length < 10) {
                e.preventDefault();
                alert('Please provide more details about how you responded');
                return;
            }
        });

        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logout.jsp';
            }
        }
    </script>
</body>
</html>
</html>
