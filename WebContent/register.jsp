<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: var(--gradient-bg-primary);
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            padding: var(--space-3xl) var(--space-lg);
            margin-bottom: var(--space-3xl);
        }

        .page-title {
            text-align: center;
            margin-top: var(--space-2xl);
            margin-bottom: var(--space-3xl);
            width: 100%;
        }

        .page-title h1 {
            font-size: var(--font-size-4xl);
            color: var(--color-heather);
            font-family: var(--font-secondary);
            font-weight: 700;
            text-transform: capitalize;
            letter-spacing: -0.5px;
        }

        .register-container {
            width: 100%;
            max-width: 460px;
            animation: fade-in-up 0.8s ease-out;
            margin-bottom: var(--space-3xl);
        }

        .register-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-2xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }

        .register-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .register-header h1 {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
        }

        .register-header .tagline {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            line-height: var(--line-height-normal);
        }

        .alert {
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-lg);
            border-left: 4px solid;
            animation: fade-in-up 0.4s ease-out;
            font-weight: var(--font-weight-medium);
            font-size: var(--font-size-sm);
        }

        .alert-error {
            background: #FCE4E9;
            border-left-color: var(--color-candy);
            color: #C91D5F;
        }

        .alert-success {
            background: #E8F5E9;
            border-left-color: var(--color-viridian);
            color: #1B5E20;
        }

        .form-section {
            margin-bottom: var(--space-xl);
        }

        .form-section-title {
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-semibold);
            color: var(--color-heather);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: var(--space-md);
            display: block;
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-group label {
            display: block;
            font-weight: var(--font-weight-medium);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-size: var(--font-size-sm);
        }

        .form-group input {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            background: var(--color-cream);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-md);
            color: var(--color-azur);
            transition: all var(--transition-base);
            box-sizing: border-box;
        }

        .form-group input::placeholder {
            color: var(--color-warm-gray);
        }

        .form-group input:focus {
            outline: none;
            background: var(--color-white);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }

        .role-selector {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-md);
        }

        .role-option {
            position: relative;
        }

        .role-option input[type="radio"] {
            display: none;
        }

        .role-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: var(--space-sm);
            padding: var(--space-lg);
            background: var(--color-cream);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all var(--transition-base);
            text-align: center;
        }

        .role-option input[type="radio"]:checked + .role-label {
            background: var(--color-sandstone);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }

        .role-emoji {
            font-size: var(--font-size-2xl);
        }

        .role-name {
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-medium);
            color: var(--color-azur);
        }

        .role-option input[type="radio"]:checked + .role-label .role-name {
            color: var(--color-viridian);
        }

        .form-help {
            font-size: var(--font-size-xs);
            color: var(--color-warm-gray);
            margin-top: var(--space-sm);
            font-style: italic;
        }

        .register-button {
            width: 100%;
            padding: var(--space-md) var(--space-xl);
            background: var(--color-viridian);
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: all var(--transition-base);
            margin-top: var(--space-xl);
            box-shadow: var(--shadow-md);
        }

        .register-button:hover {
            background: #5F8A8A;
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .register-button:active {
            transform: translateY(0);
        }

        .register-footer {
            text-align: center;
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-warm-gray);
            margin-top: var(--space-lg);
        }

        .register-footer p {
            color: var(--color-azur);
            font-size: var(--font-size-sm);
            margin-bottom: var(--space-sm);
        }

        .register-footer a {
            color: var(--color-viridian);
            text-decoration: none;
            font-weight: var(--font-weight-semibold);
            transition: color var(--transition-base);
        }

        .register-footer a:hover {
            color: var(--color-candy);
        }

        @media (max-width: 640px) {
            .page-title h1 {
                font-size: var(--font-size-2xl);
                margin-top: var(--space-lg);
            }

            .register-card {
                padding: var(--space-xl);
            }

            .register-header h1 {
                font-size: var(--font-size-2xl);
            }

            .role-selector {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="page-title">
        <h1>Create Your Account</h1>
    </div>

    <div class="register-container">
        <div class="register-card">
            <div class="register-header">
                <h1>✨ Join EmoVault</h1>
                <p class="tagline">Your journey to emotional wellness begins here</p>
            </div>

            <% 
                String alertMessage = (String) session.getAttribute("alertMessage");
                String alertType = (String) session.getAttribute("alertType");
                if (alertMessage != null) { 
                    String alertClass = "alert-error";
                    if ("success".equals(alertType)) {
                        alertClass = "alert-success";
                    }
            %>
                <div class="alert <%= alertClass %>">
                    <%= alertMessage %>
                </div>
            <% 
                    session.removeAttribute("alertMessage");
                    session.removeAttribute("alertType");
                }
            %>

            <form action="${pageContext.request.contextPath}/register_handler.jsp" method="post" onsubmit="return validateForm()">
                <!-- Account Type Selection -->
                <div class="form-section">
                    <label class="form-section-title">Account Type</label>
                    <div class="role-selector">
                        <div class="role-option">
                            <input type="radio" id="roleUser" name="role" value="user" checked required>
                            <label for="roleUser" class="role-label">
                                <span class="role-emoji">📝</span>
                                <span class="role-name">User</span>
                            </label>
                        </div>
                        <div class="role-option">
                            <input type="radio" id="roleExpert" name="role" value="expert">
                            <label for="roleExpert" class="role-label">
                                <span class="role-emoji">🧠</span>
                                <span class="role-name">Expert</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Personal Information -->
                <div class="form-section">
                    <label class="form-section-title">Personal Information</label>
                    
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input 
                            type="text" 
                            id="name" 
                            name="name" 
                            placeholder="Your full name" 
                            required
                            autocomplete="name">
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            placeholder="you@example.com" 
                            required
                            autocomplete="email">
                    </div>
                </div>

                <!-- Security -->
                <div class="form-section">
                    <label class="form-section-title">Security</label>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            placeholder="••••••••" 
                            minlength="6"
                            required
                            autocomplete="new-password">
                        <div class="form-help">At least 6 characters</div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input 
                            type="password" 
                            id="confirmPassword" 
                            name="confirmPassword" 
                            placeholder="••••••••" 
                            minlength="6"
                            required
                            autocomplete="new-password">
                    </div>
                </div>

                <button type="submit" class="register-button">Create Account</button>
            </form>

            <div class="register-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Sign in</a></p>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Passwords do not match. Please try again.');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>
