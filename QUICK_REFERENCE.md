# EmoVault UI - Quick Reference Guide

## 📌 Frequently Used Component Classes

### Page Structure
```html
<div class="navbar">Navigation here</div>
<div class="container">Page content</div>
```

### Cards (Most Flexible Component)
```html
<!-- Standard card -->
<div class="card">Content</div>

<!-- Light card with border -->
<div class="card card-light">Content</div>

<!-- Accent card (peach) -->
<div class="card card-accent">Content</div>

<!-- Card sections -->
<div class="card">
    <div class="card-header"><h3>Header</h3></div>
    <div class="card-body">Body content</div>
    <div class="card-footer">Footer</div>
</div>
```

### Buttons
```html
<button class="btn btn-primary">Primary Action</button>
<button class="btn btn-secondary">Secondary Action</button>
<button class="btn btn-accent">Attention Action</button>
<button class="btn btn-outline">Outline</button>
<button class="btn btn-light">Light</button>

<!-- Sizes -->
<button class="btn btn-primary btn-sm">Small</button>
<button class="btn btn-primary btn-lg">Large</button>
<button class="btn btn-primary btn-block">Full Width</button>
```

### Forms
```html
<input type="text" class="input-field" placeholder="Text input">
<textarea class="textarea-field">Text area</textarea>
<textarea class="textarea-field large">Large text area</textarea>
<select class="select-field">
    <option>Option 1</option>
</select>
```

### Alerts
```html
<div class="alert alert-success">
    <span class="alert-icon">✓</span>
    <div>Success message</div>
</div>

<div class="alert alert-error">
    <span class="alert-icon">✗</span>
    <div>Error message</div>
</div>
```

### Badges
```html
<span class="badge badge-primary">Primary</span>
<span class="badge badge-secondary">Secondary</span>
<span class="badge badge-accent">Accent</span>
<span class="badge badge-success">Success</span>
```

### Spacing
```html
<div class="mt-lg mb-lg p-xl">Spaced content</div>
```

### Text Utilities
```html
<p class="text-center">Centered text</p>
<p class="text-muted">Muted text</p>
<p class="text-small">Small text</p>
<strong class="font-bold">Bold</strong>
```

### Layout
```html
<!-- Grid -->
<div class="grid grid-2">Two columns</div>
<div class="grid grid-3">Three columns</div>

<!-- Flex -->
<div class="flex">Flex with gap</div>
<div class="flex-between">Space between</div>
<div class="flex-center">Centered</div>
<div class="flex-col">Column direction</div>
```

---

## 🎨 Color Usage in Custom Styles

```css
/* Use CSS variables in your custom styles */
background-color: var(--color-sage);        /* Primary green */
background-color: var(--color-avocado);    /* Soft green */
background-color: var(--color-honey);      /* Soft background */
background-color: var(--color-coconut);    /* Light background */
color: var(--color-text-dark);             /* Dark text */
color: var(--color-text-light);            /* Light text */
color: var(--color-text-muted);            /* Muted text */
```

---

## ️️🚀 Creating a New Page

### Basic Template
```html
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check authentication
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title - EmoVault</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        /* Page-specific styles here */
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
            <span>Welcome, <strong><%= userName %></strong></span>
            <a href="javascript:logout()">Logout</a>
        </div>
    </div>
    
    <!-- Page Content -->
    <div class="container">
        <h1>Page Title</h1>
        <!-- Content here -->
    </div>
    
    <script>
        function logout() {
            if (confirm('Logout?')) {
                window.location.href = '${pageContext.request.contextPath}/login?action=logout';
            }
        }
    </script>
</body>
</html>
```

---

## 📐 Responsive Best Practices

### Mobile-First Approach
```css
/* Mobile first */
.container {
    padding: var(--spacing-md);
}

.grid {
    grid-template-columns: 1fr;
}

/* Tablet and up */
@media (min-width: 768px) {
    .grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

/* Desktop and up */
@media (min-width: 1024px) {
    .grid {
        grid-template-columns: repeat(3, 1fr);
    }
}
```

---

## 🎯 Common Patterns

### Form Section
```html
<div class="card">
    <div class="form-group">
        <label for="field">Label</label>
        <input type="text" id="field" class="input-field" placeholder="...">
    </div>
    <button type="submit" class="btn btn-primary">Submit</button>
</div>
```

### Info Box
```html
<div class="card card-accent">
    <h3>💡 Helpful Tip</h3>
    <p>Helpful information goes here</p>
</div>
```

### Entry Card
```html
<div class="entry-card">
    <div class="entry-title">Title</div>
    <div class="entry-meta">
        <span>Date</span>
        <span class="badge badge-secondary">Mood</span>
    </div>
    <div class="entry-content">Content preview...</div>
</div>
```

### Stat Box
```html
<div class="stat-card">
    <div class="stat-value">42</div>
    <div class="stat-label">Label</div>
</div>
```

### Success Message
```html
<div class="alert alert-success" style="margin-bottom: var(--spacing-lg);">
    <span class="alert-icon">✓</span>
    <div>Success message here</div>
</div>
```

---

## 🔧 CSS Variables Reference

### Colors
```css
--color-sage: #818263
--color-avocado: #C2C395
--color-blush: #DDBAAE
--color-peach: #EFD7CF
--color-oat: #DCD4C1
--color-honey: #F6EAD4
--color-coconut: #FFFAF2
--color-success: #7ba89a
--color-error: #c4876c
--color-warning: #d4a574
--color-info: #8b9db8
--color-text-dark: #3a3a3a
--color-text-light: #6b6b6b
--color-text-muted: #9a9a9a
```

### Spacing
```css
--spacing-xs: 4px
--spacing-sm: 8px
--spacing-md: 16px
--spacing-lg: 24px
--spacing-xl: 32px
--spacing-2xl: 48px
```

### Sizing
```css
--radius-sm: 8px
--radius-md: 12px
--radius-lg: 16px
--radius-xl: 20px
```

### Effects
```css
--shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.08)
--shadow-md: 0 4px 12px rgba(0, 0, 0, 0.1)
--shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.12)
--transition-fast: 150ms ease-in-out
--transition-normal: 300ms ease-in-out
--transition-slow: 500ms ease-in-out
```

---

## 📋 File Locations

### Source Files
```
d:\itsme\Workk\EmoVault\
├── login.jsp
├── register.jsp
├── emotion.jsp
├── diary.jsp
├── dashboard.jsp
└── UI_REDESIGN_DOCUMENTATION.md
```

### Deployed Files
```
C:\xampp\tomcat\webapps\EmoVault\
├── login.jsp
├── register.jsp
├── emotion.jsp
├── diary.jsp
├── dashboard.jsp
└── assets/css/
    ├── theme.css (Main stylesheet)
    └── style.css (Linked to theme.css)
```

---

## ✅ Checklist for New Pages

- [ ] Include `theme.css` link in `<head>`
- [ ] Add navbar at top
- [ ] Use `.container` or `.container-sm` wrapper
- [ ] Use `.card` for content sections
- [ ] Use `.btn-primary` for main action
- [ ] Use `.alert-success` / `.alert-error` for messages
- [ ] Test on mobile (use browser dev tools)
- [ ] Check keyboard navigation
- [ ] Verify form labels match inputs
- [ ] Add logout function to navbar

---

## 🎨 Styling New Components

### Step 1: Choose a Component Type
- Card-based? Use `.card`
- Action button? Use `.btn`
- Information? Use `.alert`
- Data display? Use `.stat-card`

### Step 2: Add to Existing Classes
```html
<div class="card card-accent">Custom card</div>
```

### Step 3: Add Page-Specific Styles (if needed)
```html
<style>
    .my-custom-section {
        background-color: var(--color-peach);
        padding: var(--spacing-lg);
        border-radius: var(--radius-lg);
    }
</style>
```

### Step 4: Test Responsive
- Mobile (375px)
- Tablet (768px)
- Desktop (1024px+)

---

## 🚨 Common Mistakes to Avoid

❌ **Don't** use hardcoded colors → **Do** use `var(--color-*)`  
❌ **Don't** hardcode spacing → **Do** use `var(--spacing-*)`  
❌ **Don't** create shadow values → **Do** use `var(--shadow-*)`  
❌ **Don't** use Bootstrap classes → **Do** use theme classes  
❌ **Don't** add extra margins → **Do** use margin utilities  
❌ **Don't** forget responsive design → **Do** test on all sizes  

---

## 💡 Tips & Tricks

**Tip 1:** Use `.text-center` instead of adding `text-align`  
**Tip 2:** Use `.flex-between` instead of `justify-content: space-between`  
**Tip 3:** Use `.mt-lg` instead of `margin-top` (more consistent)  
**Tip 4:** Combine classes: `<div class="card card-accent p-lg">`  
**Tip 5:** Use `.grid-2` on desktop and it stacks on mobile automatically  

---

**Last Updated:** April 2026  
**Theme Version:** v1.0  
**Status:** ✅ Production Ready
