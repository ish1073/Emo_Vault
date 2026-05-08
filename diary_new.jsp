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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .diary-wrapper {
            min-height: 100vh;
            background-color: var(--color-coconut);
            padding: var(--spacing-lg) 0;
        }
        
        .diary-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 var(--spacing-lg);
        }
        
        .diary-header {
            text-align: center;
            margin-bottom: var(--spacing-2xl);
        }
        
        .diary-header h1 {
            font-size: var(--font-size-3xl);
            color: var(--color-sage);
            margin-bottom: var(--spacing-sm);
        }
        
        .diary-header p {
            color: var(--color-text-light);
            font-size: var(--font-size-md);
        }
        
        .diary-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: var(--spacing-lg);
        }
        
        .diary-form-section {
            background-color: var(--color-honey);
            border-radius: var(--radius-lg);
            padding: var(--spacing-xl);
            box-shadow: var(--shadow-md);
            border: 1px solid rgba(129, 130, 99, 0.1);
        }
        
        .diary-form-title {
            font-size: var(--font-size-lg);
            color: var(--color-sage);
            margin-bottom: var(--spacing-lg);
            font-weight: 700;
        }
        
        .form-group {
            margin-bottom: var(--spacing-lg);
        }
        
        .form-group label {
            display: block;
            font-size: var(--font-size-sm);
            font-weight: 600;
            color: var(--color-text-dark);
            margin-bottom: var(--spacing-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: var(--spacing-md);
            border: 1px solid var(--color-oat);
            border-radius: var(--radius-md);
            font-size: var(--font-size-base);
            background-color: var(--color-coconut);
            color: var(--color-text-dark);
            font-family: var(--font-primary);
            transition: all var(--transition-fast);
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--color-sage);
            box-shadow: 0 0 0 3px rgba(129, 130, 99, 0.1);
            background-color: var(--color-honey);
        }
        
        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }
        
        .diary-sidebar {
            display: flex;
            flex-direction: column;
            gap: var(--spacing-lg);
        }
        
        .sidebar-card {
            background-color: var(--color-peach);
            border-radius: var(--radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-sm);
            border-left: 4px solid var(--color-blush);
        }
        
        .sidebar-card h3 {
            color: var(--color-sage);
            margin-bottom: var(--spacing-sm);
            font-size: var(--font-size-md);
        }
        
        .sidebar-card p {
            color: var(--color-text-dark);
            font-size: var(--font-size-sm);
        }
        
        .diary-button {
            width: 100%;
            padding: var(--spacing-md) var(--spacing-lg);
            background-color: var(--color-sage);
            color: white;
            border: none;
            border-radius: var(--radius-md);
            font-size: var(--font-size-base);
            font-weight: 700;
            cursor: pointer;
            transition: all var(--transition-normal);
        }
        
        .diary-button:hover {
            background-color: #6d6e54;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .entries-section {
            grid-column: 1 / -1;
        }
        
        .entries-title {
            font-size: var(--font-size-2xl);
            color: var(--color-sage);
            margin-bottom: var(--spacing-lg);
            font-weight: 700;
        }
        
        .entries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: var(--spacing-lg);
        }
        
        .entry-card {
            background-color: var(--color-honey);
            border-radius: var(--radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-sm);
            border-left: 4px solid var(--color-sage);
            transition: all var(--transition-normal);
        }
        
        .entry-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
            border-left-color: var(--color-avocado);
        }
        
        .entry-title {
            font-size: var(--font-size-md);
            font-weight: 700;
            color: var(--color-sage);
             margin-bottom: var(--spacing-sm);
        }
        
        .entry-meta {
            font-size: var(--font-size-xs);
            color: var(--color-text-muted);
            margin-bottom: var(--spacing-md);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .entry-content {
            color: var(--color-text-light);
            font-size: var(--font-size-base);
            line-height: 1.6;
            max-height: 80px;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: var(--spacing-md);
        }
        
        .no-entries {
            text-align: center;
            padding: var(--spacing-2xl);
            background-color: var(--color-honey);
            border-radius: var(--radius-lg);
            color: var(--color-text-muted);
        }
        
        .mood-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: var(--radius-sm);
            font-size: var(--font-size-xs);
            font-weight: 600;
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
