<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EmoVault - Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="modern-design-system.css">
    <style>
        .register-page {
            position: relative;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: var(--space-lg);
            overflow: hidden;
        }

        .register-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 520px;
        }

        .register-card {
            background: var(--bg-card);
            backdrop-filter: var(--blur-light);
            border: 1px solid var(--color-border-light);
            border-radius: var(--radius-2xl);
            padding: var(--space-3xl);
            animation: slideInCard 0.8s ease-out 0.2s both;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }

        .register-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gradient-accent);
            border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
        }

        .register-card::after {
            content: '';
            position: absolute;
            inset: 0;
            background: var(--gradient-card-overlay);
            pointer-events: none;
            border-radius: var(--radius-2xl);
        }

        @keyframes slideInCard {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .register-card > * {
            position: relative;
            z-index: 2;
        }

        .register-header {
            text-align: center;
            margin-bottom: var(--space-xl);
        }

        .register-header h1 {
            font-size: var(--text-3xl);
            font-family: var(--font-secondary);
            color: var(--color-text-primary);
            margin-bottom: var(--space-sm);
            font-weight: var(--fw-bold);
            letter-spacing: -0.5px;
        }

        .register-header .tagline {
            font-size: var(--text-sm);
            color: var(--color-rose-quartz);
            letter-spacing: 1px;
            font-weight: var(--fw-medium);
            text-transform: uppercase;
        }

        .register-title {
            text-align: center;
            color: var(--color-text-primary);
            font-size: var(--text-2xl);
            margin-bottom: var(--space-md);
            font-weight: var(--fw-bold);
            font-family: var(--font-secondary);
        }

        .register-subtitle {
            text-align: center;
            color: var(--color-text-secondary);
            font-size: var(--text-sm);
            margin-bottom: var(--space-2xl);
            line-height: 1.6;
            font-weight: var(--fw-regular);
            opacity: 0.85;
        }

        .form-section {
            margin-bottom: var(--space-lg);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-group label {
            display: block;
            font-size: var(--text-xs);
            font-weight: var(--fw-semibold);
            color: var(--color-text-primary);
            margin-bottom: var(--space-sm);
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .form-group input {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            font-family: var(--font-primary);
            font-size: var(--text-base);
            background: rgba(226, 194, 188, 0.2);
            border: 1px solid var(--color-border-light);
            border-radius: var(--radius-md);
            color: var(--color-text-secondary);
            transition: all var(--transition-base);
            backdrop-filter: var(--blur-light);
        }

        .form-group input::placeholder {
            color: var(--color-text-muted);
            opacity: 0.7;
        }

        .form-group input:focus {
            outline: none;
            background: rgba(226, 194, 188, 0.3);
            border-color: var(--color-puce);
            box-shadow: 0 0 0 3px rgba(191, 113, 133, 0.15);
            transform: translateY(-2px);
        }

        .form-help {
            font-size: var(--text-xs);
            color: var(--color-text-muted);
            margin-top: var(--space-sm);
            line-height: 1.4;
        }

        .password-status {
            font-size: var(--text-xs);
            margin-top: var(--space-sm);
            color: var(--color-text-muted);
            transition: color var(--transition-base);
        }

        .password-status.match {
            color: var(--color-success);
        }

        .password-status.mismatch {
            color: var(--color-danger);
        }

        .register-button {
            width: 100%;
            padding: var(--space-lg) var(--space-xl);
            background: var(--gradient-button);
            color: #FFFFFF;
            border: none;
            border-radius: var(--radius-md);
            font-family: var(--font-primary);
            font-size: var(--text-base);
            font-weight: var(--fw-semibold);
            cursor: pointer;
            transition: all var(--transition-base);
            letter-spacing: 0.6px;
            text-transform: uppercase;
            margin-bottom: var(--space-xl);
            box-shadow: 0 8px 24px rgba(191, 113, 133, 0.3);
            position: relative;
            overflow: hidden;
        }

        .register-button::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
            opacity: 0;
            transition: opacity var(--transition-base);
        }

        .register-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 32px rgba(191, 113, 133, 0.4);
        }

        .register-button:hover::before {
            opacity: 1;
        }

        .register-button:active {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(191, 113, 133, 0.3);
        }

        .register-button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .register-footer {
            text-align: center;
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-border-light);
        }

        .register-footer p {
            color: var(--color-text-secondary);
            font-size: var(--text-sm);
            margin-bottom: var(--space-sm);
            line-height: 1.6;
            opacity: 0.85;
        }

        .register-footer a {
            color: var(--color-puce);
            text-decoration: none;
            font-weight: var(--fw-semibold);
            transition: all var(--transition-base);
            position: relative;
        }

        .register-footer a:hover {
            color: var(--color-text-primary);
            text-decoration: underline;
        }

        .register-footer a:focus {
            outline: 2px solid var(--color-puce);
            outline-offset: 2px;
        }

        .alert {
            padding: var(--space-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--space-xl);
            border-left: 4px solid;
            animation: slideInAlert 0.4s var(--transition-cubic);
            display: flex;
            gap: var(--space-md);
            align-items: flex-start;
        }

        @keyframes slideInAlert {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert-error {
            background: rgba(191, 113, 133, 0.15);
            border-left-color: var(--color-danger);
            color: var(--color-text-secondary);
        }

        .alert-success {
            background: rgba(191, 113, 133, 0.12);
            border-left-color: var(--color-success);
            color: var(--color-text-secondary);
        }

        @media (max-width: 640px) {
            .register-card {
                padding: var(--space-xl) var(--space-lg);
                border-radius: var(--radius-xl);
            }

            .register-title {
                font-size: var(--text-xl);
            }

            .register-header h1 {
                font-size: var(--text-2xl);
            }

            .register-page {
                padding: var(--space-lg);
            }

            .form-group input {
                padding: var(--space-md) var(--space-lg);
                font-size: var(--text-sm);
            }

            .register-button {
                padding: var(--space-md) var(--space-lg);
            }
        }

            }
        }
    </style>
</head>
<body>
    <div class="register-page">
        <div class="register-container">
            <div class="register-card">
                <!-- Header -->
                <div class="register-header">
                    <h1>✨ Join EmoVault</h1>
                    <p class="tagline">Begin your journey of emotional wellness and personal growth</p>
                </div>

                <h2 class="register-title">Create Your Account</h2>
                <p class="register-subtitle">Start documenting your emotional journey today</p>

                    <!-- Error Message -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-error">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <!-- Success Message -->
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success">
                            <%= request.getAttribute("success") %>
                        </div>
                    <% } %>

                    <!-- Registration Form -->
                    <form action="${pageContext.request.contextPath}/register" method="post" class="form-section">
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
                                placeholder="your@email.com" 
                                required
                                autocomplete="email">
                        </div>

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
                            <div class="form-help">✓ Minimum 6 characters for your safety</div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input 
                                type="password" 
                                id="confirmPassword" 
                                name="confirmPassword" 
                                placeholder="••••••••" 
                                required
                                autocomplete="new-password">
                            <div class="password-status" id="passwordStatus"></div>
                        </div>

                        <button type="submit" class="register-button">Create My Account</button>
                    </form>

                    <!-- Footer -->
                    <div class="register-footer">
                        <p>Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Sign in</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const form = document.querySelector('form');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordStatus = document.getElementById('passwordStatus');

        // Real-time password match validation
        confirmPasswordInput.addEventListener('input', function() {
            if (this.value) {
                if (passwordInput.value === this.value) {
                    passwordStatus.textContent = '✓ Passwords match';
                    passwordStatus.className = 'password-status match';
                } else {
                    passwordStatus.textContent = '✗ Passwords do not match';
                    passwordStatus.className = 'password-status mismatch';
                }
            } else {
                passwordStatus.textContent = '';
                passwordStatus.className = 'password-status';
            }
        });

        // Form submission validation
        form.addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (!name || !email || !password || !confirmPassword) {
                e.preventDefault();
                alert('Please fill in all fields');
                return;
            }

            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long');
                return;
            }

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match. Please try again.');
                return;
            }
        });
    </script>
</body>
</html>
