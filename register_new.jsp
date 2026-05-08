<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="emovault-complete-ui.css">
    <style>
        .register-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: var(--space-lg);
            background: linear-gradient(135deg, #443C5E 0%, #BF7185 50%, #3D2B27 100%);
            position: relative;
            overflow: hidden;
        }

        .register-page::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 20% 50%, rgba(191, 113, 133, 0.2) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(169, 159, 191, 0.15) 0%, transparent 50%);
            pointer-events: none;
            animation: ambientGlow 20s ease-in-out infinite;
        }

        @keyframes ambientGlow {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.03); }
        }

        .register-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 550px;
        }

        .register-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-2xl);
            padding: var(--space-3xl);
            box-shadow: var(--shadow-lg);
            animation: slideUp 0.8s ease-out;
        }

        .register-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--color-puce), var(--color-rose-quartz));
        }

        .register-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
        }

        .register-header h1 {
            font-size: 2.5rem;
            color: var(--color-pale-dogwood);
            margin-bottom: var(--space-sm);
            font-weight: 700;
        }

        .register-header .tagline {
            color: var(--color-rose-quartz);
            font-size: 0.9rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            font-weight: 600;
        }

        .register-title {
            color: var(--color-pale-dogwood);
            font-size: 1.8rem;
            text-align: center;
            margin-bottom: var(--space-lg);
            font-weight: 700;
        }

        .register-subtitle {
            text-align: center;
            color: var(--color-text-soft);
            font-size: 0.95rem;
            margin-bottom: var(--space-2xl);
            opacity: 0.85;
        }

        .register-form {
            margin-bottom: var(--space-xl);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-label {
            display: block;
            color: var(--color-pale-dogwood);
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: var(--space-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-input {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            background: var(--color-pale-dogwood);
            border: 2px solid var(--color-rose-quartz);
            border-radius: var(--radius-md);
            color: var(--color-van-dyke);
            font-family: var(--font-primary);
            font-size: 0.95rem;
            transition: all var(--transition-base);
        }

        .form-input::placeholder {
            color: var(--color-rose-quartz);
            opacity: 0.6;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--color-puce);
            background: rgba(226, 194, 188, 0.95);
            box-shadow: 0 0 0 4px rgba(191, 113, 133, 0.2);
            transform: translateY(-2px);
        }

        .form-help {
            font-size: 0.8rem;
            color: var(--color-rose-quartz);
            margin-top: var(--space-sm);
        }

        .btn-register {
            width: 100%;
            padding: var(--space-lg) var(--space-xl);
            background: var(--gradient-button);
            color: #FFF;
            border: none;
            border-radius: var(--radius-md);
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-base);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            box-shadow: var(--shadow-glow);
            margin-bottom: var(--space-lg);
            position: relative;
            overflow: hidden;
        }

        .btn-register::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.3) 0%, transparent 70%);
            opacity: 0;
            transition: opacity var(--transition-fast);
        }

        .btn-register:hover {
            transform: translateY(-4px) scale(1.02);
            box-shadow: 0 0 40px rgba(191, 113, 133, 0.5);
        }

        .btn-register:hover::before {
            opacity: 1;
        }

        .register-footer {
            text-align: center;
            padding-top: var(--space-xl);
            border-top: 1px solid var(--glass-border);
        }

        .register-footer p {
            color: var(--color-text-soft);
            font-size: 0.95rem;
        }

        .register-footer a {
            color: var(--color-puce);
            font-weight: 600;
        }

        .alert {
            padding: var(--space-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--space-lg);
            border-left: 4px solid;
            animation: slideInAlert 0.4s ease-out;
        }

        .alert-error {
            background: rgba(191, 113, 133, 0.2);
            border-left-color: var(--color-puce);
            color: var(--color-text-soft);
        }

        @keyframes slideInAlert {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }
    </style>
</head>
<body>
    <div class="register-page">
        <div class="register-container">
            <div class="register-card">
                <div class="register-header">
                    <h1>✨ EmoVault</h1>
                    <p class="tagline">Join Your Emotional Wellness Community</p>
                </div>

                <h2 class="register-title">Create Account</h2>
                <p class="register-subtitle">Start your journey of self-discovery and emotional intelligence.</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="dashboard_complete.jsp" method="post" class="register-form">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-input" name="fullname" placeholder="John Doe" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" class="form-input" name="email" placeholder="your@email.com" required autocomplete="email">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-input" name="password" placeholder="••••••••" required id="password">
                        <div class="form-help">Minimum 8 characters with uppercase, lowercase, and numbers</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Confirm Password</label>
                        <input type="password" class="form-input" name="confirm_password" placeholder="••••••••" required id="confirm_password">
                    </div>

                    <button type="submit" class="btn-register">Create Account</button>
                </form>

                <div class="register-footer">
                    <p>Already have an account? <a href="login_new.jsp">Sign in</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
