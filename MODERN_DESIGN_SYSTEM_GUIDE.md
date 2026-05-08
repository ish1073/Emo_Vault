# EmoVault Modern Design System
## Emotional, Cinematic, Premium Interface

### Overview
A modern, emotionally intelligent design system featuring a soft, cinematic aesthetic with a carefully curated color palette that creates depth, mood, and premium feel while maintaining excellent usability and accessibility.

---

## Color Palette

### Core Emotional Colors

| Color | Hex | Purpose | Usage |
|-------|-----|---------|-------|
| **Van Dyke** | #3D2B27 | Primary base background, depth | Main background, dark sections |
| **English Violet** | #443C5E | Secondary background | Navbar, headers, overlays |
| **Puce** | #BF7185 | Primary accent | Buttons, highlights, important actions |
| **Pale Dogwood** | #E2C2BC | Card backgrounds | Content areas, card surfaces |
| **Rose Quartz** | #A99FBF | Borders and subtleties | Borders, hover states, secondary UI |

### CSS Variables
```css
--color-van-dyke: #3D2B27;
--color-english-violet: #443C5E;
--color-puce: #BF7185;
--color-pale-dogwood: #E2C2BC;
--color-rose-quartz: #A99FBF;
```

---

## Design Principles

### 1. **Emotional & Moody**
- Dark, sophisticated backgrounds create emotional depth
- Soft, warm accent colors evoke comfort and trust
- Layered gradients create cinematic quality

### 2. **Glassmorphism**
- Semi-transparent cards with backdrop blur
- Subtle gradient overlays for depth
- Creates floating, ethereal feel

### 3. **Soft Elegance**
- Smooth transitions and animations (0.3-0.5s)
- Layered shadows for depth without harshness
- Subtle glows for accent highlighting

### 4. **Premium Feel**
- Generous spacing and padding
- High-quality typography with serif accents
- Refined interactions with hover states
- Attention to micro-interactions

### 5. **Accessibility First**
- Sufficient color contrast
- Clear focus states on all interactive elements
- Readable font sizes and line heights
- Keyboard navigation support

---

## Typography

### Font Stack
- **Primary**: Inter (sans-serif)
  - Weights: 300, 400, 500, 600, 700
  - Clean, modern, excellent readability
  
- **Secondary**: Playfair Display (serif)
  - Weights: 600, 700
  - Used for headings, elegant accents

### Type Scale
```
--text-xs:   0.75rem    (12px)   – Labels, captions
--text-sm:   0.875rem   (14px)   – Secondary text
--text-base: 1rem       (16px)   – Body text
--text-lg:   1.125rem   (18px)   – Small headings
--text-xl:   1.25rem    (20px)   – Subheadings
--text-2xl:  1.5rem     (24px)   – Section titles
--text-3xl:  1.875rem   (30px)   – Page titles
--text-4xl:  2.25rem    (36px)   – Hero text
```

### Text Colors
- **Primary (Headings)**: #E2C2BC (Pale Dogwood)
- **Secondary (Body)**: #D4B5AD (Muted pinkish)
- **Muted**: #BFA7A0 (Subtle text)

---

## Component Styles

### Cards (Glassmorphism)
```html
<div class="card">
  <div class="card-header">
    <h3 class="card-title">Card Title</h3>
    <p class="card-subtitle">Subtitle</p>
  </div>
  <!-- Content -->
</div>
```

**Styling Features:**
- Background: `rgba(226, 194, 188, 0.45)` with 8px blur
- Border: 1px solid `rgba(169, 159, 191, 0.3)`
- Border radius: 16px
- Shadow: `0 6px 20px rgba(0, 0, 0, 0.18)`
- Hover: Lifts with enhanced shadow, puce border

### Buttons

#### Primary Button (.btn-primary)
```html
<button class="btn btn-primary">Sign In</button>
```
- Gradient: `#BF7185` → `#A99FBF` → `#BF7185`
- Shadow: `0 8px 24px rgba(191, 113, 133, 0.3)`
- Hover: Lifts 3px, enhanced shadow, inner radial glow
- All uppercase, letter-spacing: 0.6px

#### Secondary Button (.btn-secondary)
```html
<button class="btn btn-secondary">Learn More</button>
```
- Border: 2px solid `#BF7185`
- Transparent background
- Hover: Light puce background

#### Tertiary Button (.btn-tertiary)
```html
<button class="btn btn-tertiary">Cancel</button>
```
- Subtle border, text-based
- Hover: Colored background

### Form Elements

#### Input Fields
```html
<input type="email" class="form-input" placeholder="your@email.com">
```
- Background: `rgba(226, 194, 188, 0.2)` with backdrop blur
- Border: 1px solid `rgba(169, 159, 191, 0.3)`
- Focus: Puce border, glowing shadow, slight lift
- Transition: 0.3s ease-in-out

#### Labels
```html
<label class="form-label">Email Address</label>
```
- Color: `#E2C2BC` (Pale Dogwood)
- Uppercase, 0.6px letter-spacing
- Font-weight: 600

### Alerts

#### Error Alert
```html
<div class="alert alert-error">
  Error message here
</div>
```
- Background: `rgba(191, 113, 133, 0.15)`
- Left border: 4px solid `#BF7185`

#### Success Alert
```html
<div class="alert alert-success">
  Success message here
</div>
```
- Background: `rgba(191, 113, 133, 0.12)`
- Left border: 4px solid `#BF7185`

### Navbar
```html
<nav class="navbar">
  <div class="navbar-brand">EmoVault</div>
  <ul class="navbar-nav">
    <li><a href="#">Dashboard</a></li>
    <li><a href="#">Profile</a></li>
  </ul>
</nav>
```
- Background: `#443C5E` (English Violet) with blur
- Sticky positioning
- Underline animation on hover

---

## Animations & Transitions

### Transition Times
```css
--transition-fast: 0.2s ease;
--transition-base: 0.3s ease-in-out;
--transition-slow: 0.5s ease-in-out;
--transition-cubic: cubic-bezier(0.4, 0.0, 0.2, 1);
```

### Keyframe Animations

#### Fade In
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
```

#### Slide In Up
```css
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

#### Ambient Glow (Background)
```css
@keyframes ambientGlow {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 1.1; transform: scale(1.03); }
}
```

### Usage Classes
- `.animate-fade-in`
- `.animate-slide-in-up`
- `.animate-slide-in-down`
- `.animate-slide-in-left`
- `.animate-slide-in-right`
- `.animate-pulse`

---

## Shadows (Depth)

```css
--shadow-sm:   0 2px 8px rgba(0, 0, 0, 0.15);
--shadow-md:   0 6px 20px rgba(0, 0, 0, 0.18);
--shadow-lg:   0 12px 32px rgba(0, 0, 0, 0.2);
--shadow-xl:   0 20px 48px rgba(0, 0, 0, 0.25);
--shadow-glow: 0 0 30px rgba(191, 113, 133, 0.25);
```

---

## Spacing Scale

```css
--space-xs:  0.25rem   (4px)
--space-sm:  0.5rem    (8px)
--space-md:  1rem      (16px)
--space-lg:  1.5rem    (24px)
--space-xl:  2rem      (32px)
--space-2xl: 2.5rem    (40px)
--space-3xl: 3rem      (48px)
```

---

## Border Radius

```css
--radius-sm:   8px
--radius-md:   12px
--radius-lg:   16px
--radius-xl:   24px
--radius-2xl:  32px
```

---

## Gradients

### Primary Background
```css
linear-gradient(135deg, #3D2B27 0%, #443C5E 50%, #3D2B27 100%)
```

### Accent Gradient (Buttons)
```css
linear-gradient(135deg, #BF7185 0%, #A99FBF 50%, #BF7185 100%)
```

### Card Overlay
```css
linear-gradient(135deg, rgba(226, 194, 188, 0.15) 0%, rgba(169, 159, 191, 0.1) 100%)
```

---

## Implementation Examples

### Login Card
```html
<div class="card">
  <div class="card-header">
    <h1 style="text-align: center;">EmoVault</h1>
  </div>
  
  <form class="form-section">
    <div class="form-group">
      <label class="form-label">Email</label>
      <input class="form-input" type="email" placeholder="you@example.com">
    </div>
    
    <button class="btn btn-primary">Sign In</button>
  </form>
</div>
```

### Dashboard Section
```html
<section class="section section-dark">
  <div class="container">
    <h2>My Emotions Today</h2>
    <div class="card">
      <h3 class="card-title">Emotional Insights</h3>
      <p>Your emotional journey visualization here.</p>
    </div>
  </div>
</section>
```

---

## Responsive Design

### Breakpoints
- **Large**: 1200px and above (desktop)
- **Medium**: 768px to 1199px (tablet)
- **Small**: 480px to 767px (mobile)
- **Extra Small**: Below 480px

### Mobile Adjustments
- Padding reduced from 24px to 16px
- Card padding: 16px
- Typography scaled down appropriately
- Full-width buttons on mobile
- Navbar stacks vertically

---

## Accessibility Guidelines

### Color Contrast
- Text vs background meets WCAG AA standards
- All interactive elements have focus states
- Color not the only indicator of state

### Focus States
```css
a:focus {
  outline: 2px solid var(--color-puce);
  outline-offset: 2px;
  border-radius: 2px;
}
```

### Semantic HTML
- Use proper heading hierarchy (h1 → h6)
- Form inputs have associated labels
- Buttons have clear, descriptive text
- Alt text for images

### Keyboard Navigation
- All interactive elements tab-accessible
- Logical tab order
- Skip links for navigation (if needed)

---

## Browser Support

- Chrome/Edge: Latest 2 versions
- Firefox: Latest 2 versions
- Safari: Latest 2 versions
- Mobile browsers: Latest versions

### CSS Features Used
- CSS Variables (Custom Properties)
- Flexbox
- CSS Grid
- Backdrop Filter (modern browsers)
- Gradients
- Transitions & Animations

---

## File Structure

```
EmoVault/
├── modern-design-system.css    (Core design system)
├── login.jsp                    (Implemented example)
├── register.jsp                 (To be updated)
├── dashboard.jsp                (To be updated)
├── diary.jsp                    (To be updated)
├── emotion.jsp                  (To be updated)
└── MODERN_DESIGN_SYSTEM_GUIDE.md (This file)
```

---

## CSS Classes Quick Reference

### Layout
- `.container` – Max-width 1200px container
- `.container-sm` – Max-width 480px (forms)
- `.container-md` – Max-width 768px
- `.flex` – Display flex
- `.flex-col` – Flex column
- `.flex-center` – Centered flex
- `.gap-md`, `.gap-lg` – Gap utilities
- `.section` – Content section with padding
- `.section-dark` – Dark gradient background

### Text
- `.text-center`, `.text-right`, `.text-left` – Text alignment
- `h1`–`h6` – Heading styles (auto-colored with Pale Dogwood)
- `p` – Paragraph (auto-colored with secondary text)
- `a` – Links (auto-styled with puce accent)

### Cards & Components
- `.card` – Glassmorphic card
- `.card-header` – Card header with border
- `.card-title` – Card title styling
- `.card-subtitle` – Card subtitle styling

### Forms
- `.form-group` – Input wrapper
- `.form-label` – Label styling
- `.form-input` – Text input styling
- `.form-select` – Select input styling
- `.form-textarea` – Textarea styling
- `.form-checkbox` – Checkbox styling
- `.form-help` – Help text
- `.form-error` – Error text

### Buttons
- `.btn` – Base button
- `.btn-primary` – Primary gradient button
- `.btn-secondary` – Secondary bordered button
- `.btn-tertiary` – Tertiary subtle button
- `.btn-sm` – Small button
- `.btn-lg` – Large button

### Alerts
- `.alert` – Base alert
- `.alert-success` – Success state
- `.alert-error` – Error state
- `.alert-warning` – Warning state
- `.alert-info` – Info state

### Navigation
- `.navbar` – Navigation bar
- `.navbar-brand` – Brand/logo
- `.navbar-nav` – Navigation list

### Animations
- `.animate-fade-in` – Fade in animation
- `.animate-slide-in-up` – Slide up animation
- `.animate-slide-in-down` – Slide down animation
- `.animate-slide-in-left` – Slide left animation
- `.animate-slide-in-right` – Slide right animation
- `.animate-pulse` – Pulsing animation

### Utilities
- `.opacity-75` – 75% opacity
- `.opacity-50` – 50% opacity
- `.mt-md`, `.mt-lg` – Margin top
- `.mb-md`, `.mb-lg` – Margin bottom
- `.p-md`, `.p-lg` – Padding

---

## Color Usage Examples

### Where Each Color Appears

**#3D2B27 (Van Dyke)**
- Body background
- Dark overlay backgrounds
- Secondary content areas

**#443C5E (English Violet)**
- Navbar/header backgrounds
- Secondary section backgrounds
- Overlay elements

**#BF7185 (Puce)**
- Primary buttons
- Icon accents
- Link hovers
- Focus states

**#E2C2BC (Pale Dogwood)**
- Card backgrounds
- Heading text
- Primary content surfaces

**#A99FBF (Rose Quartz)**
- Borders
- Hover state backgrounds
- Secondary icon colors
- Focus outlines

---

## Next Steps

1. **Apply to Register Page** – Use card layout with form
2. **Apply to Dashboard** – Multiple cards in grid layout
3. **Apply to Diary** – Large card for entry editing
4. **Apply to Emotion Tracking** – Gradient cards for emotions
5. **Create Component Library** – Reusable JSP includes
6. **Add Dark Mode Toggle** – Additional theme variant (optional)
7. **Responsive Testing** – Ensure mobile optimizations work

---

## Maintenance Notes

- Keep all color variables in `:root`
- Consistent spacing: use `var(--space-*)` classes
- All animations should use `--transition-*` variables
- Maintain WCAG AA accessibility standards
- Test with keyboard navigation
- Regular accessibility audits

---

## Version
- **Design System v1.0**
- **Created**: April 16, 2026
- **Author**: EmoVault Design Team

For questions or updates, refer to the CSS file comments or create GitHub issues.
