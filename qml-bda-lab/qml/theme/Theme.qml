pragma Singleton
import QtQuick 2.15

QtObject {
    // Primary colors - Deep Red and Gold theme
    readonly property color primary: "#D71920"       // Deep red
    readonly property color secondary: "#CBB46A"     // Gold
    readonly property color onPrimary: "#FFFFFF"     // White text on primary
    readonly property color onSecondary: "#000000"   // Black text on secondary
    
    // Surface colors
    readonly property color surface: "#FFFFFF"       // Light surface
    readonly property color surfaceDark: "#1E1E1E"   // Dark surface
    readonly property color onSurface: "#000000"     // Text on light surface
    readonly property color onSurfaceDark: "#FFFFFF" // Text on dark surface
    
    // Background colors
    readonly property color background: "#F5F5F5"    // Light background
    readonly property color backgroundDark: "#121212" // Dark background
    readonly property color onBackground: "#000000"  // Text on light background
    readonly property color onBackgroundDark: "#FFFFFF" // Text on dark background
    
    // Error and warning colors
    readonly property color error: "#B00020"
    readonly property color onError: "#FFFFFF"
    readonly property color warning: "#FF8F00"
    readonly property color onWarning: "#000000"
    
    // Outline and divider colors
    readonly property color outline: "#79747E"
    readonly property color outlineVariant: "#CAC4D0"
    
    // Typography settings
    readonly property string fontFamily: "Source Sans 3" // Default to open-source font
    
    // Font sizes (in sp/pt)
    readonly property int fontSizeDisplay: 57
    readonly property int fontSizeHeadlineLarge: 32
    readonly property int fontSizeHeadlineMedium: 28
    readonly property int fontSizeHeadlineSmall: 24
    readonly property int fontSizeTitleLarge: 22
    readonly property int fontSizeTitleMedium: 16
    readonly property int fontSizeTitleSmall: 14
    readonly property int fontSizeLabelLarge: 14
    readonly property int fontSizeLabelMedium: 12
    readonly property int fontSizeLabelSmall: 11
    readonly property int fontSizeBodyLarge: 16
    readonly property int fontSizeBodyMedium: 14
    readonly property int fontSizeBodySmall: 12
    
    // Font weights
    readonly property int fontWeightLight: Font.Light
    readonly property int fontWeightNormal: Font.Normal
    readonly property int fontWeightMedium: Font.Medium
    readonly property int fontWeightBold: Font.Bold
    
    // Spacing tokens
    readonly property int spacingXs: 4
    readonly property int spacingS: 8
    readonly property int spacingM: 16
    readonly property int spacingL: 24
    readonly property int spacingXl: 32
    readonly property int spacingXxl: 48
    
    // Elevation (for cards, dialogs, etc.)
    readonly property real elevation1: 1
    readonly property real elevation2: 3
    readonly property real elevation3: 6
    readonly property real elevation4: 8
    readonly property real elevation5: 12
    
    // Corner radius
    readonly property int cornerRadiusS: 4
    readonly property int cornerRadiusM: 8
    readonly property int cornerRadiusL: 12
    readonly property int cornerRadiusXl: 16
    
    // Component specific colors
    readonly property color cardBackground: surface
    readonly property color cardBackgroundDark: surfaceDark
    readonly property color buttonPrimary: primary
    readonly property color buttonSecondary: secondary
    readonly property color inputBackground: "#F7F7F7"
    readonly property color inputBackgroundDark: "#2C2C2C"
    readonly property color inputBorder: outline
    
    // HUD and overlay colors (for map displays)
    readonly property color hudBackground: Qt.rgba(0, 0, 0, 0.7)
    readonly property color hudText: onPrimary
    readonly property color hudAccent: secondary
    
    // Dynamic color selection based on theme mode
    property bool isDarkMode: false
    
    readonly property color currentSurface: isDarkMode ? surfaceDark : surface
    readonly property color currentOnSurface: isDarkMode ? onSurfaceDark : onSurface
    readonly property color currentBackground: isDarkMode ? backgroundDark : background
    readonly property color currentOnBackground: isDarkMode ? onBackgroundDark : onBackground
    readonly property color currentCardBackground: isDarkMode ? cardBackgroundDark : cardBackground
    readonly property color currentInputBackground: isDarkMode ? inputBackgroundDark : inputBackground
}