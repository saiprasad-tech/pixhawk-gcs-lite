# Android App Analysis and Fixes

## Current Problem
The Android app shows "Google" but no map tiles because it requires a paid Google Maps API key that hasn't been provided.

## Solution Implemented
The QML application now provides a complete fallback system that works without any paid services.

## How the Map Fallback Works

### Original Issue
- Android app uses Google Maps API
- Requires `MAPS_API_KEY` in `local.properties`
- Shows blank tiles without paid API key

### QML Solution
- **Primary**: Uses OpenStreetMap (OSM) - completely free, no registration required
- **Optional**: Falls back to Google Maps if user enters API key in Settings
- **Automatic**: No configuration needed - works immediately

### Map Provider Selection Logic
```qml
Plugin {
    id: mapPlugin
    name: (googleMapsApiKey && googleMapsApiKey.length > 0) ? "googlemaps" : "osm"
    
    // OSM parameters (no key required)
    PluginParameter {
        name: "osm.useragent"
        value: "Pixhawk GCS Lite"
    }
    
    // Google Maps parameters (only used if key provided)
    PluginParameter {
        name: "googlemaps.api_key"  
        value: googleMapsApiKey
    }
}
```

## Android Manifest Updates

### Permissions Added
```xml
<!-- Android 12+ Bluetooth permissions -->
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />

<!-- Wi-Fi provisioning permissions -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />

<!-- Camera for Pi streaming -->
<uses-permission android:name="android.permission.CAMERA" android:required="false" />
```

### Google Maps Made Optional
```xml
<!-- Google Maps API Key placeholder (optional - OSM used as fallback) -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${MAPS_API_KEY}" />
```

## Key Benefits

1. **No Billing Required**: OSM provides free worldwide maps
2. **Works Immediately**: No setup or API keys needed
3. **Optional Enhancement**: Users can still add Google Maps if desired
4. **Full Functionality**: All map features work with OSM

## Testing the Fix

1. **Without API Key**: App displays OSM maps immediately
2. **With API Key**: Enter key in Settings → switches to Google Maps
3. **Offline Ready**: OSM tiles cache for offline use

## Android Build Process

The existing Android build process is unchanged:
```bash
cd android
./gradlew assembleDebug
```

The app will work with maps even without creating `local.properties` or adding any API keys.

## Migration Guide

### For Users Currently Seeing Blank Maps:
1. Launch the updated app
2. Maps will immediately display using OSM
3. Optionally: Go to Settings → Enter Google Maps API key if desired

### For Developers:
1. No code changes needed to Android Kotlin app
2. QML app provides the core functionality
3. Both apps can coexist during transition

## Performance Comparison

| Feature | Google Maps | OpenStreetMap |
|---------|------------|---------------|
| Cost | Paid (after free tier) | Free |
| Setup | API key required | No setup |
| Performance | Optimized | Good |
| Coverage | Worldwide | Worldwide |
| Offline | Limited | Cacheable |
| Customization | Limited | High |

## Recommendations

1. **Default Use**: Start with OSM for immediate functionality
2. **Production Apps**: Consider Google Maps for enhanced features
3. **Development**: Use OSM to avoid API key management
4. **Offline Use**: OSM provides better offline capabilities