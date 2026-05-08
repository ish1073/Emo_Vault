<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emovault.dao.DiaryDAO" %>
<%@ page import="com.emovault.model.DiaryEntry" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    DiaryDAO diaryDAO = new DiaryDAO();
    List<DiaryEntry> diaries = diaryDAO.getUserDiaries(userId);
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Diary - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        .diary-wrapper {
            min-height: 100vh;
            background: var(--gradient-bg-primary);
            padding: var(--space-lg) 0;
        }
        
        .diary-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 var(--space-lg);
        }
        
        .diary-header {
            text-align: center;
            margin-bottom: var(--space-2xl);
            animation: fade-in-up 0.6s ease-out;
        }
        
        .diary-header h1 {
            font-size: var(--font-size-3xl);
            background: var(--gradient-accent);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--space-md);
        }
        
        .diary-header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: var(--font-size-lg);
        }
        
        .diary-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: var(--space-lg);
        }
        
        .diary-form-section {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(15px);
            border-radius: var(--radius-xl);
            padding: var(--space-xl);
            box-shadow: 0 0 20px rgba(202, 169, 243, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: fade-in-up 0.6s ease-out 0.1s both;
        }
        
        .diary-form-title {
            font-size: var(--font-size-lg);
            color: var(--color-phlox);
            margin-bottom: var(--space-lg);
            font-weight: 700;
        }
        
        .form-group {
            margin-bottom: var(--space-lg);
        }
        
        .form-group label {
            display: block;
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-semibold);
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: var(--space-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: var(--radius-md);
            font-size: var(--font-size-base);
            background: rgba(255, 255, 255, 0.03);
            color: rgba(255, 255, 255, 0.95);
            font-family: var(--font-primary);
            transition: all var(--transition-base);
        }
        
        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: rgba(202, 169, 243, 0.4);
            background: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 20px rgba(202, 169, 243, 0.2);
            transform: translateY(-1px);
        }
        
        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }
        
        .diary-sidebar {
            display: flex;
            flex-direction: column;
            gap: var(--space-lg);
        }
        
        .sidebar-card {
            background: rgba(202, 169, 243, 0.08);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: 0 0 15px rgba(202, 169, 243, 0.1);
            border: 1px solid rgba(202, 169, 243, 0.2);
        }
        
        .sidebar-card h3 {
            color: var(--color-phlox);
            margin-bottom: var(--space-sm);
            font-size: var(--font-size-md);
        }
        
        .sidebar-card p {
            color: rgba(255, 255, 255, 0.8);
            font-size: var(--font-size-sm);
        }
        
        .diary-button {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            background: var(--gradient-btn);
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-size: var(--font-size-base);
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: all var(--transition-base);
            box-shadow: 0 0 20px rgba(202, 169, 243, 0.3);
        }
        
        .diary-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(202, 169, 243, 0.5);
        }
        
        .entries-section {
            grid-column: 1 / -1;
        }
        
        .entries-title {
            font-size: var(--font-size-2xl);
            color: var(--color-phlox);
            margin-bottom: var(--space-lg);
            font-weight: 700;
        }
        
        .entries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: var(--space-lg);
        }
        
        .entry-card {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: 0 0 15px rgba(202, 169, 243, 0.08);
            border: 1px solid rgba(202, 169, 243, 0.2);
            transition: all var(--transition-base);
        }
        
        .entry-card:hover {
            box-shadow: 0 0 25px rgba(202, 169, 243, 0.15);
            transform: translateY(-4px);
            background: rgba(255, 255, 255, 0.06);
        }
        
        .entry-title {
            font-size: var(--font-size-md);
            font-weight: 700;
            color: var(--color-phlox);
            margin-bottom: var(--space-sm);
        }
        
        .entry-meta {
            font-size: var(--font-size-xs);
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: var(--space-md);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .entry-content {
            color: rgba(255, 255, 255, 0.8);
            font-size: var(--font-size-base);
            line-height: 1.6;
            max-height: 80px;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: var(--space-md);
        }
        
        .no-entries {
            text-align: center;
            padding: var(--space-2xl);
            background: rgba(255, 255, 255, 0.04);
            border-radius: var(--radius-lg);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.6);
        }
        
        .mood-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: var(--radius-sm);
            font-size: var(--font-size-xs);
            font-weight: 600;
            background: rgba(202, 169, 243, 0.2);
            color: var(--color-phlox);
        }
        
        @media (max-width: 768px) {
            .diary-grid {
                grid-template-columns: 1fr;
            }
            
            .diary-sidebar {
                flex-direction: row;
            }
            
            .sidebar-card {
                flex: 1;
            }
            
            .entries-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="navbar-brand">💝 EmoVault</div>
        <div class="navbar-menu">
            <a href="${pageContext.request.contextPath}/emotion.jsp">Emotions</a>
            <a href="${pageContext.request.contextPath}/diary">Diary</a>
            <a href="${pageContext.request.contextPath}/regret">Regrets</a>
            <a href="${pageContext.request.contextPath}/habit">Habits</a>
            <a href="${pageContext.request.contextPath}/alert">Alerts</a>
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <span style="color: var(--color-text-dark); font-size: var(--font-size-sm);">
                Welcome, <strong><%= userName %></strong>
            </span>
            <a href="javascript:void(0)" onclick="logout()" style="color: var(--color-error);">Logout</a>
        </div>
    </div>
    
    <div class="diary-wrapper">
        <div class="diary-container">
            <div class="diary-header">
                <h1>📔 My Diary</h1>
                <p>Write freely, reflect deeply, grow continuously</p>
            </div>
            
            <div class="diary-grid">
                <!-- Form Section -->
                <div>
                    <!-- Error/Success Messages -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-error" style="margin-bottom: var(--spacing-lg);">
                            <span class="alert-icon">✗</span>
                            <div><%= request.getAttribute("error") %></div>
                        </div>
                    <% } %>
                    
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success" style="margin-bottom: var(--spacing-lg);">
                            <span class="alert-icon">✓</span>
                            <div><%= request.getAttribute("success") %></div>
                        </div>
                    <% } %>
                    
                    <!-- Form -->
                    <div class="diary-form-section">
                        <h2 class="diary-form-title">✍️ Write New Entry</h2>
                        
                        <form action="${pageContext.request.contextPath}/diary" method="post">
                            <div class="form-group">
                                <label for="title">Entry Title</label>
                                <input type="text" id="title" name="title" placeholder="Give your entry a title..." required>
                            </div>
                            
                            <div class="form-group">
                                <label for="content">Your Thoughts</label>
                                <textarea id="content" name="content" placeholder="Express yourself freely..." required></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="moodTag">How are you feeling? (Optional)</label>
                                <select id="moodTag" name="moodTag">
                                    <option value="">-- No mood tag --</option>
                                    <option value="Happy">😊 Happy</option>
                                    <option value="Sad">😢 Sad</option>
                                    <option value="Angry">😠 Angry</option>
                                    <option value="Anxious">😰 Anxious</option>
                                    <option value="Calm">🧘 Calm</option>
                                    <option value="Confused">😕 Confused</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="diary-button">💾 Save Entry</button>
                        </form>
                    </div>
                </div>
                
                <!-- Sidebar -->
                <div class="diary-sidebar">
                    <div class="sidebar-card">
                        <h3>💡 Tip</h3>
                        <p>Write regularly to track your growth and understand your patterns better.</p>
                    </div>
                    
                    <div class="sidebar-card" style="background-color: var(--color-avocado);">
                        <h3 style="color: var(--color-sage);">📊 Stats</h3>
                        <p style="color: var(--color-sage); font-weight: 700;">
                            <% if (diaries != null) { %>
                                <%= diaries.size() %>
                            <% } else { %>
                                0
                            <% } %>
                            <br><small>Total Entries</small>
                        </p>
                    </div>
                    
                    <div class="sidebar-card">
                        <h3>🎯 Navigation</h3>
                        <p style="margin: 0;"><a href="${pageContext.request.contextPath}/emotion.jsp" style="color: var(--color-sage);">Log Emotions →</a></p>
                        <p style="margin: 0;"><a href="${pageContext.request.contextPath}/dashboard" style="color: var(--color-sage);">View Dashboard →</a></p>
                    </div>
                </div>
                
                <!-- Entries Section -->
                <div class="entries-section">
                    <h2 class="entries-title">📚 Your Entries</h2>
                    
                    <% if (diaries != null && !diaries.isEmpty()) { %>
                        <div class="entries-grid">
                            <% for (DiaryEntry entry : diaries) { %>
                                <div class="entry-card <% if (entry.getMoodTag() != null) { %>mood-<%= entry.getMoodTag().toLowerCase() %><% } %>">
                                    <div class="entry-title"><%= entry.getTitle() %></div>
                                    <div class="entry-meta">
                                        <span><%= dateFormat.format(entry.getCreatedAt()) %></span>
                                        <% if (entry.getMoodTag() != null && !entry.getMoodTag().isEmpty()) { %>
                                            <span class="mood-badge badge-secondary"><%= entry.getMoodTag() %></span>
                                        <% } %>
                                    </div>
                                    <div class="entry-content"><%= entry.getContent() %></div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="no-entries">
                            <p>📝 No entries yet. Start writing your first diary entry above!</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logout.jsp';
            }
        }
    </script>
</body>
</html>
