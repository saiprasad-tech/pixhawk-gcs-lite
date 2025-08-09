# Theme Configuration for QML BDA-Lab Project

This document describes how to customize the theme and fonts in the QML BDA-Lab project.

## Current Theme

The project uses a red/white/gold theme inspired by Emirates branding:

- **Primary Color**: `#D71920` (Deep Red)
- **Secondary Color**: `#CBB46A` (Gold)
- **Text on Primary**: `#FFFFFF` (White)
- **Surface Colors**: Light/Dark variants for different modes

## Typography

### Default Font
The project is currently configured to use **Source Sans 3**, which is an open-source font that provides good readability and professional appearance.

### Replacing with Licensed Font

To replace the default font with a licensed corporate font (such as an Emirates-like font):

#### Step 1: Add Font Files
1. Create a `fonts/` directory in the `qml-bda-lab/resources/` folder
2. Copy your licensed font files (TTF or OTF format) into this directory
3. Common font weights to include:
   - `YourFont-Regular.ttf`
   - `YourFont-Medium.ttf`
   - `YourFont-Bold.ttf`
   - `YourFont-Light.ttf` (optional)

#### Step 2: Update Resource File
Add the fonts to your QRC resource file (`qgcresources.qrc`):

```xml
<qresource prefix="/fonts">
    <file alias="custom-regular">resources/fonts/YourFont-Regular.ttf</file>
    <file alias="custom-medium">resources/fonts/YourFont-Medium.ttf</file>
    <file alias="custom-bold">resources/fonts/YourFont-Bold.ttf</file>
</qresource>
```

#### Step 3: Update Theme.qml
Modify the `fontFamily` property in `qml/theme/Theme.qml`:

```qml
// Change this line:
readonly property string fontFamily: "Source Sans 3"

// To:
readonly property string fontFamily: "YourCustomFont"
```

#### Step 4: Load Fonts in Main Application
In your main QML file or application startup, add:

```qml
FontLoader {
    id: customRegular
    source: "qrc:/fonts/custom-regular"
}

FontLoader {
    id: customMedium
    source: "qrc:/fonts/custom-medium"
}

FontLoader {
    id: customBold
    source: "qrc:/fonts/custom-bold"
}
```

## Color Customization

### Modifying Colors
To change theme colors, edit the values in `qml/theme/Theme.qml`:

```qml
// Example: Change primary color to a different red
readonly property color primary: "#CC0000"  // Change from #D71920

// Example: Change secondary/accent color
readonly property color secondary: "#FFD700"  // Change from #CBB46A
```

### Dark Mode Support
The theme includes built-in dark mode support. Colors automatically switch based on the `isDarkMode` property:

```qml
// In your QML components, use:
color: Theme.currentSurface      // Automatically switches light/dark
color: Theme.currentOnSurface    // Text color that adapts
```

## Using the Theme in Components

### Text Components
```qml
Text {
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeBodyLarge
    font.weight: Theme.fontWeightNormal
    color: Theme.currentOnSurface
}
```

### Buttons
```qml
Button {
    font.family: Theme.fontFamily
    background.color: Theme.primary
    contentItem.color: Theme.onPrimary
}
```

### Cards and Surfaces
```qml
Rectangle {
    color: Theme.currentCardBackground
    border.color: Theme.outline
    radius: Theme.cornerRadiusM
}
```

## Best Practices

1. **Always use theme colors**: Avoid hardcoded colors in components
2. **Consistent spacing**: Use theme spacing tokens (`Theme.spacingM`, etc.)
3. **Font consistency**: Always reference `Theme.fontFamily`
4. **Test both modes**: Verify appearance in both light and dark themes
5. **Accessibility**: Ensure sufficient contrast ratios

## Legal Considerations

When using licensed fonts:
- Ensure you have proper licensing for your use case
- Include appropriate font licenses in your application
- Do not commit licensed font files to public repositories
- Consider font fallbacks for systems without the licensed font

## Future Enhancements

Consider creating shared design tokens between the Android and QML projects to maintain consistency across platforms.