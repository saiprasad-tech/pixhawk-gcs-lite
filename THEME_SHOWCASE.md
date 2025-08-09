# Visual Theme Showcase

This document provides a visual representation of the consistent theming applied across both Android and QML projects.

## Color Palette

### Primary Colors
- **Primary (Deep Red)**: `#D71920` / `0xFFD71920`
  - Used for: Headers, primary buttons, brand elements
  - Text on Primary: White (`#FFFFFF`)

- **Secondary (Gold)**: `#CBB46A` / `0xFFCBB46A`
  - Used for: Accent elements, secondary buttons, highlights
  - Text on Secondary: Black (`#000000`)

### Surface Colors (Light Mode)
- **Surface**: `#FFFFFF` (White)
- **Background**: `#F5F5F5` (Light gray)
- **Card Background**: `#FFFFFF` (White)
- **Input Background**: `#F7F7F7` (Very light gray)

### Surface Colors (Dark Mode)
- **Surface**: `#1E1E1E` (Dark gray)
- **Background**: `#121212` (Very dark gray)
- **Card Background**: `#1E1E1E` (Dark gray)
- **Input Background**: `#2C2C2C` (Medium dark gray)

### Utility Colors
- **Error**: `#B00020` (Dark red)
- **Warning**: `#FF8F00` (Orange)
- **Outline**: `#79747E` (Medium gray)

## Typography

### Font Family
- **Default**: Source Sans 3 (open-source)
- **Custom**: Easily replaceable with licensed Emirates-like font

### Font Sizes (QML/Android)
- **Display**: 57sp
- **Headline Large**: 32sp
- **Headline Medium**: 28sp
- **Title Large**: 22sp
- **Title Medium**: 16sp
- **Body Large**: 16sp
- **Body Medium**: 14sp
- **Label Medium**: 12sp

## Component Examples

### Android Compose UI Structure
```
┌─────────────────────────────────────┐
│ App Bar (Primary #D71920)           │
│ "Pixhawk GCS Lite" (White text)    │
└─────────────────────────────────────┘
│                                     │
│ Welcome Card (White surface)        │
│ ┌─────────────────────────────────┐ │
│ │ "Welcome to Pixhawk GCS"       │ │
│ │ (Primary color text)            │ │
│ │                                 │ │
│ │ "Ground Control Station for     │ │
│ │  MAVLink vehicles"              │ │
│ │ (Regular text)                  │ │
│ │                                 │ │
│ │ "Theme: Red/Gold Emirates"      │ │
│ │ (Secondary color text)          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Feature List:                       │
│ • Bluetooth/MAVLink connectivity    │
│ • Google Maps integration           │
│ • Flight planning and control       │
│                                     │
└─────────────────────────────────────┘
```

### QML UI Structure
```
┌─────────────────────────────────────┐
│ Toolbar (Primary #D71920)           │
│ "BDA-Lab GCS" │  [Settings Button]  │
│ (White text)  │  (Gold #CBB46A)     │
└─────────────────────────────────────┘
│                                     │
│ Welcome Card (White surface)        │
│ ┌─────────────────────────────────┐ │
│ │      "Welcome to BDA-Lab"       │ │
│ │      (Primary color - Red)      │ │
│ │                                 │ │
│ │  "Ground Control Station for    │ │
│ │    MAVLink Vehicles"            │ │
│ │                                 │ │
│ │  "Theme: Emirates-inspired      │ │
│ │    Red/Gold"                    │ │
│ │  (Secondary color - Gold)       │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Feature Grid (2x2):                 │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │Flight       │ │Vehicle Status   │ │
│ │Planning     │ │                 │ │
│ └─────────────┘ └─────────────────┘ │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │Map Display  │ │MAVLink Comm     │ │
│ │             │ │                 │ │
│ └─────────────┘ └─────────────────┘ │
│                                     │
│ [Connect Vehicle] [Toggle Theme]    │
│ (Red button)     (Gold button)      │
│                                     │
└─────────────────────────────────────┘
```

## Dark Mode Support

Both applications support automatic dark mode switching:

- **QML**: Uses `Theme.isDarkMode` property with `Theme.current*` properties
- **Android**: Uses Material3 dynamic colors and system theme detection

### Dark Mode Changes
- Surfaces become dark gray instead of white
- Text inverts to white on dark surfaces
- Primary and secondary colors remain consistent
- Outline colors adjust for proper contrast

## Accessibility

- **Contrast Ratios**: All color combinations meet WCAG AA standards
- **Dynamic Type**: Both systems support system font size preferences
- **High Contrast**: Dark mode provides enhanced visibility options

## Brand Consistency

The theme maintains Emirates-inspired branding through:
- Consistent red/gold color palette across platforms
- Professional typography hierarchy
- Cohesive spacing and elevation system
- Unified component styling patterns