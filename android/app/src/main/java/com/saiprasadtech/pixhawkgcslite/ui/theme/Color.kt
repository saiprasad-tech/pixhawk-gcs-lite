package com.saiprasadtech.pixhawkgcslite.ui.theme

import androidx.compose.ui.graphics.Color

// Primary colors - Deep Red and Gold theme (matching QML)
val Primary = Color(0xFFD71920)      // Deep red
val OnPrimary = Color(0xFFFFFFFF)    // White text on primary
val Secondary = Color(0xFFCBB46A)    // Gold
val OnSecondary = Color(0xFF000000)  // Black text on secondary

// Surface and background colors - Light theme
val Surface = Color(0xFFFFFFFF)      // Light surface
val OnSurface = Color(0xFF000000)    // Text on light surface
val Background = Color(0xFFF5F5F5)   // Light background
val OnBackground = Color(0xFF000000) // Text on light background

// Surface and background colors - Dark theme
val SurfaceDark = Color(0xFF1E1E1E)      // Dark surface
val OnSurfaceDark = Color(0xFFFFFFFF)    // Text on dark surface
val BackgroundDark = Color(0xFF121212)   // Dark background
val OnBackgroundDark = Color(0xFFFFFFFF) // Text on dark background

// Error colors
val Error = Color(0xFFB00020)
val OnError = Color(0xFFFFFFFF)

// Warning colors
val Warning = Color(0xFFFF8F00)
val OnWarning = Color(0xFF000000)

// Outline colors
val Outline = Color(0xFF79747E)
val OutlineVariant = Color(0xFFCAC4D0)

// Component specific colors
val CardBackground = Surface
val CardBackgroundDark = SurfaceDark
val InputBackground = Color(0xFFF7F7F7)
val InputBackgroundDark = Color(0xFF2C2C2C)

// HUD and overlay colors (for map displays)
val HudBackground = Color(0xB3000000)  // 70% black opacity
val HudText = OnPrimary
val HudAccent = Secondary