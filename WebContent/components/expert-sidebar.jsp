<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) {
        currentPage = request.getParameter("currentPage");
    }
    if (currentPage == null) {
        currentPage = "";
    }
%>

<!-- Toggle Button - Always Visible -->
<button class="sidebar-toggle" id="sidebarToggle" title="Toggle sidebar">
    ☰
</button>

<aside class="sidebar expert-sidebar" id="sidebar">
    <div class="sidebar-header">
        <h1 class="sidebar-brand">🧠 EmoVault Expert</h1>
    </div>
    
    <nav>
        <ul class="sidebar-nav">
            <li>
                <a href="${pageContext.request.contextPath}/expert_dashboard" 
                   class="<%= currentPage.equals("expert_dashboard") || currentPage.equals("") ? "active" : "" %>">
                    <span>🏠</span>
                    <span>Expert Dashboard</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/users" 
                   class="<%= currentPage.equals("users") ? "active" : "" %>">
                    <span>👥</span>
                    <span>User Monitoring</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/insights" 
                   class="<%= currentPage.equals("insights") ? "active" : "" %>">
                    <span>🧠</span>
                    <span>Behavior Insights</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/alerts" 
                   class="<%= currentPage.equals("alerts") ? "active" : "" %>">
                    <span>⚠️</span>
                    <span>Emotional Risk Alerts</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/analytics" 
                   class="<%= currentPage.equals("analytics") ? "active" : "" %>">
                    <span>📈</span>
                    <span>Analytics & Trends</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/recommendations" 
                   class="<%= currentPage.equals("recommendations") ? "active" : "" %>">
                    <span>📝</span>
                    <span>Recommendations</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/rules" 
                   class="<%= currentPage.equals("rules") ? "active" : "" %>">
                    <span>🎯</span>
                    <span>Guidance Rules</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/reports" 
                   class="<%= currentPage.equals("reports") ? "active" : "" %>">
                    <span>📬</span>
                    <span>User Reports</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/expert/notifications" 
                   class="<%= currentPage.equals("notifications") ? "active" : "" %>">
                    <span>🔔</span>
                    <span>Notifications</span>
                </a>
            </li>
            <li class="sidebar-divider"></li>
            <li>
                <a href="${pageContext.request.contextPath}/expert?action=logout" class="sidebar-logout">
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
            localStorage.setItem('expertSidebarCollapsed', 'false');
        } else {
            // Collapse - Hide sidebar completely
            sidebar.style.display = 'none';
            sidebar.style.width = '0px';
            if (mainContent) mainContent.style.marginLeft = '0px';
            if (toggleBtn) toggleBtn.textContent = '☰';
            if (toggleBtn) toggleBtn.style.left = 'var(--space-lg)';
            if (toggleBtn) toggleBtn.style.right = 'auto';
            localStorage.setItem('expertSidebarCollapsed', 'true');
        }
    };
    
    // Initialize sidebar state on page load
    window.addEventListener('load', function() {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.getElementById('sidebarToggle');
        const mainContent = document.querySelector('.main-content');
        
        if (!sidebar || !toggleBtn) return;
        
        const savedState = localStorage.getItem('expertSidebarCollapsed') === 'true';
        
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

<style>
    /* Expert-specific sidebar styling */
    .expert-sidebar .sidebar-brand {
        font-size: var(--font-size-xl);
        background: linear-gradient(135deg, var(--color-viridian), var(--color-candy));
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    
    .expert-sidebar .sidebar-nav li a {
        position: relative;
        overflow: hidden;
    }
    
    .expert-sidebar .sidebar-nav li a::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        height: 100%;
        width: 3px;
        background: var(--color-candy);
        transform: scaleY(0);
        transition: transform 0.3s ease;
    }
    
    .expert-sidebar .sidebar-nav li a.active::before {
        transform: scaleY(1);
    }
    
    .expert-sidebar .sidebar-nav li a:hover::before {
        transform: scaleY(1);
    }
</style>