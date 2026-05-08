<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String currentPage = request.getParameter("currentPage");
    if (currentPage == null) {
        currentPage = "";
    }
%>

<!-- Toggle Button - Always Visible -->
<button class="sidebar-toggle" id="sidebarToggle" title="Toggle sidebar">
    ☰
</button>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h1 class="sidebar-brand">✨ EmoVault</h1>
    </div>
    
    <nav>
        <ul class="sidebar-nav">
            <li>
                <a href="${pageContext.request.contextPath}/dashboard" 
                   class="<%= currentPage.equals("dashboard") ? "active" : "" %>">
                    <span>🏠</span>
                    <span>Dashboard</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/emotion" 
                   class="<%= currentPage.equals("emotion") ? "active" : "" %>">
                    <span>💭</span>
                    <span>Emotion</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/diary" 
                   class="<%= currentPage.equals("diary") ? "active" : "" %>">
                    <span>📔</span>
                    <span>Diary</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/habit" 
                   class="<%= currentPage.equals("habit") ? "active" : "" %>">
                    <span>🌱</span>
                    <span>Habits</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/regret" 
                   class="<%= currentPage.equals("regret") ? "active" : "" %>">
                    <span>💭</span>
                    <span>Reflections</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/timecapsule" 
                   class="<%= currentPage.equals("timecapsule") ? "active" : "" %>">
                    <span>⏳</span>
                    <span>Time Capsule</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/alerts" 
                   class="<%= currentPage.equals("alerts") ? "active" : "" %>">
                    <span>🔔</span>
                    <span>Alerts</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/behavior_analyzer" 
                   class="<%= currentPage.equals("behavior_analyzer") ? "active" : "" %>">
                    <span>�</span>
                    <span>Behavior Analysis</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/decision" 
                   class="<%= currentPage.equals("decision") ? "active" : "" %>">
                    <span>🎯</span>
                    <span>Decision Assistant</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/analytics" 
                   class="<%= currentPage.equals("analytics") ? "active" : "" %>">
                    <span>📊</span>
                    <span>Analytics</span>
                </a>
            </li>
            <li class="sidebar-divider"></li>
            <li>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="sidebar-logout">
                    <span>🚪</span>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </nav>
</aside>

<script>
    window.toggleSidebar = function() {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.getElementById('sidebarToggle');
        const mainContent = document.querySelector('.main-content');
        
        if (!sidebar) {
            console.log('Sidebar not found');
            return;
        }
        
        // Check if currently collapsed (hidden)
        const isCurrentlyHidden = sidebar.style.display === 'none';
        
        if (isCurrentlyHidden) {
            // Expand - Show sidebar
            sidebar.style.display = 'flex';
            sidebar.style.width = '280px';
            sidebar.style.padding = 'var(--space-xl) var(--space-lg)';
            sidebar.style.flexDirection = 'column';
            if (mainContent) mainContent.style.marginLeft = '280px';
            if (toggleBtn) toggleBtn.textContent = '✕';
            if (toggleBtn) toggleBtn.style.left = 'auto';
            if (toggleBtn) toggleBtn.style.right = 'var(--space-lg)';
            localStorage.setItem('sidebarCollapsed', 'false');
        } else {
            // Collapse - Hide sidebar completely
            sidebar.style.display = 'none';
            sidebar.style.width = '0px';
            if (mainContent) mainContent.style.marginLeft = '0px';
            if (toggleBtn) toggleBtn.textContent = '☰';
            if (toggleBtn) toggleBtn.style.left = 'var(--space-lg)';
            if (toggleBtn) toggleBtn.style.right = 'auto';
            localStorage.setItem('sidebarCollapsed', 'true');
        }
    };
    
    // Initialize sidebar state on page load
    window.addEventListener('load', function() {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.getElementById('sidebarToggle');
        const mainContent = document.querySelector('.main-content');
        
        if (!sidebar || !toggleBtn) return;
        
        const savedState = localStorage.getItem('sidebarCollapsed') === 'true';
        
        if (savedState) {
            // Hidden state
            sidebar.style.display = 'none';
            sidebar.style.width = '0px';
            if (mainContent) mainContent.style.marginLeft = '0px';
            toggleBtn.textContent = '☰';
            toggleBtn.style.left = 'var(--space-lg)';
            toggleBtn.style.right = 'auto';
        } else {
            // Visible state
            sidebar.style.display = 'flex';
            sidebar.style.width = '280px';
            sidebar.style.padding = 'var(--space-xl) var(--space-lg)';
            sidebar.style.flexDirection = 'column';
            if (mainContent) mainContent.style.marginLeft = '280px';
            toggleBtn.textContent = '✕';
            toggleBtn.style.left = 'auto';
            toggleBtn.style.right = 'var(--space-lg)';
        }
    });
    
    // Attach click handler to toggle button
    document.addEventListener('DOMContentLoaded', function() {
        const toggleBtn = document.getElementById('sidebarToggle');
        if (toggleBtn) {
            toggleBtn.onclick = function(e) {
                e.preventDefault();
                e.stopPropagation();
                window.toggleSidebar();
            };
        }
    });
</script>
