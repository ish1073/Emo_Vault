<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    
    @SuppressWarnings("unchecked")
    List<DiaryEntry> diaries = (List<DiaryEntry>) request.getAttribute("diaries");
    if (diaries == null) diaries = new java.util.ArrayList<>();
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diary - EmoVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lora:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        body {
            background: var(--gradient-bg-primary);
            margin: 0;
            padding: 0;
        }

        .diary-layout {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--space-2xl);
            display: flex;
            flex-direction: column;
            transition: margin-left 0.3s ease-in-out, width 0.3s ease-in-out;
        }

        .diary-write-section {
            margin-bottom: var(--space-3xl);
            animation: fade-in-up 0.6s ease-out;
        }

        .section-header {
            margin-bottom: var(--space-xl);
        }

        .section-title {
            font-size: var(--font-size-3xl);
            color: var(--color-heather);
            margin-bottom: var(--space-sm);
            font-family: var(--font-secondary);
        }

        .section-subtitle {
            font-size: var(--font-size-base);
            color: var(--color-warm-gray);
        }

        .diary-card {
            background: var(--color-white);
            border-radius: var(--radius-2xl);
            padding: var(--space-2xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(230, 212, 191, 0.3);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-label {
            display: block;
            font-weight: var(--font-weight-medium);
            color: var(--color-heather);
            margin-bottom: var(--space-md);
            font-size: var(--font-size-base);
        }

        .form-control {
            width: 100%;
            padding: var(--space-md) var(--space-lg);
            font-family: var(--font-primary);
            font-size: var(--font-size-base);
            background: var(--color-cream);
            border: 2px solid var(--color-warm-gray);
            border-radius: var(--radius-md);
            color: var(--color-azur);
            transition: all var(--transition-base);
        }

        .form-control::placeholder {
            color: var(--color-warm-gray);
        }

        .form-control:focus {
            outline: none;
            background: var(--color-white);
            border-color: var(--color-viridian);
            box-shadow: 0 0 0 3px rgba(103, 159, 159, 0.1);
        }

        .diary-textarea {
            min-height: 400px;
            resize: vertical;
            font-family: 'Lora', 'Georgia', serif;
            line-height: var(--line-height-loose);
        }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: var(--space-lg);
            margin-top: var(--space-xl);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--color-warm-gray);
        }

        .word-count {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
        }

        .form-actions {
            display: flex;
            gap: var(--space-md);
        }

        .btn {
            padding: var(--space-sm) var(--space-lg);
            border: none;
            border-radius: var(--radius-lg);
            font-weight: var(--font-weight-medium);
            cursor: pointer;
            transition: all var(--transition-base);
            font-family: var(--font-primary);
        }

        .btn-primary {
            background: var(--color-viridian);
            color: white;
            box-shadow: var(--shadow-md);
        }

        .btn-primary:hover {
            background: #5F8A8A;
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn-secondary {
            background: var(--color-cream);
            color: var(--color-heather);
            border: 2px solid var(--color-heather);
        }

        .btn-secondary:hover {
            background: var(--color-sandstone);
        }

        .entries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: var(--space-lg);
        }

        .entry-card {
            background: var(--color-white);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            box-shadow: var(--shadow-md);
            border-left: 4px solid var(--color-candy);
            transition: all var(--transition-base);
        }

        .entry-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .entry-date {
            font-size: var(--font-size-sm);
            color: var(--color-warm-gray);
            margin-bottom: var(--space-sm);
        }

        .entry-preview {
            color: var(--color-azur);
            font-size: var(--font-size-base);
            line-height: var(--line-height-normal);
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .no-entries {
            text-align: center;
            padding: var(--space-2xl);
            color: var(--color-warm-gray);
        }

        .success-message {
            background: #E8F5E9;
            border-left: 4px solid var(--color-viridian);
            color: #1B5E20;
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-lg);
            animation: fade-in-up 0.4s ease-out;
        }

        .error-message {
            background: #FCE4E9;
            border-left: 4px solid var(--color-candy);
            color: #C91D5F;
            padding: var(--space-lg);
            border-radius: var(--radius-lg);
            margin-bottom: var(--space-lg);
            animation: fade-in-up 0.4s ease-out;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: var(--space-lg);
            }

            .diary-card {
                padding: var(--space-lg);
            }

            .form-footer {
                flex-direction: column;
                align-items: flex-start;
            }

            .form-actions {
                width: 100%;
                flex-direction: column;
            }

            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="diary-layout">
        <!-- Sidebar -->
        <jsp:include page="components/sidebar.jsp">
            <jsp:param name="currentPage" value="diary" />
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
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

            <!-- Write Section -->
            <div class="diary-write-section">
                <div class="section-header">
                    <h1 class="section-title">📔 Write</h1>
                    <p class="section-subtitle">Your safe space for thoughts and feelings</p>
                </div>

                <div class="diary-card">
                    <form action="${pageContext.request.contextPath}/diary" method="post">
                        <div class="form-group">
                            <label class="form-label" for="title">Entry Title</label>
                            <input type="text" id="title" name="title" class="form-control" placeholder="Give your entry a title..." required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="content">Your Thoughts</label>
                            <textarea id="content" name="content" class="form-control diary-textarea" placeholder="Write freely. This is your private space..."></textarea>
                        </div>

                        <div class="form-footer">
                            <div class="word-count">
                                <span id="word-count">0</span> words
                            </div>
                            <div class="form-actions">
                                <button type="reset" class="btn btn-secondary">Clear</button>
                                <button type="submit" class="btn btn-primary">✓ Save Entry</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Previous Entries Section -->
            <div class="diary-entries-section">
                <div class="section-header">
                    <h2 class="section-title">📚 Your Entries</h2>
                </div>

                <% if (diaries != null && !diaries.isEmpty()) { %>
                    <div class="entries-grid">
                        <% for (DiaryEntry entry : diaries) { %>
                            <div class="entry-card">
                                <div class="entry-date"><%= dateFormat.format(entry.getCreatedAt()) %></div>
                                <% if (entry.getTitle() != null && !entry.getTitle().isEmpty()) { %>
                                    <h3 style="margin: var(--space-sm) 0; color: var(--color-heather); font-size: var(--font-size-lg);">
                                        <%= entry.getTitle() %>
                                    </h3>
                                <% } %>
                                <div class="entry-preview"><%= entry.getContent() %></div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="no-entries">
                        <p>📝 No entries yet. Start writing your first entry above!</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        const textarea = document.getElementById('content');
        const wordCount = document.getElementById('word-count');

        textarea.addEventListener('input', function() {
            const words = this.value.trim().split(/\s+/).filter(w => w.length > 0).length;
            wordCount.textContent = words;
        });
    </script>
</body>
</html>
