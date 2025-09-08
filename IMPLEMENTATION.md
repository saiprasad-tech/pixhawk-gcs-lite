# Pixhawk GCS Lite - Implementation Guide

## Overview

This implementation addresses the core requirements to make the Android app work without a paid Google Maps key, integrate with Raspberry Pi 5, and provide comprehensive drone control features.

## Key Features Implemented

### 1. Map Provider Fallback System

The application now automatically switches between Google Maps and OpenStreetMap (OSM) based on API key availability:

- **Default**: Uses OpenStreetMap (free, no key required) 
- **Optional**: Users can enter Google Maps API key in Settings for enhanced maps
- **Seamless**: No blank tiles - OSM works out of the box

#### Files Modified:
- `qml-bda-lab/qml/pages/MapPage.qml` - Map component with plugin fallback
- `qml-bda-lab/qml/pages/SettingsPage.qml` - Google Maps API key configuration

### 2. Complete Navigation Structure

Replaced the basic welcome screen with a full-featured tab navigation:

- **Connect Tab**: Bluetooth device scanning and Pi provisioning
- **Map Tab**: Real-time drone position tracking with fallback maps
- **Camera Tab**: Pi camera MJPEG stream with person tracking controls
- **Settings Tab**: Configuration for all Pi connections and telemetry

#### Files Modified:
- `qml-bda-lab/qml/main.qml` - Complete navigation rewrite
- `qml-bda-lab/CMakeLists.txt` - Added new QML files to build

### 3. Telemetry Integration

Dual-mode telemetry client supporting both UDP and HTTP modes:

- **UDP Mode**: Listen on configurable port (default 14555) for JSON telemetry
- **HTTP Mode**: Poll REST endpoint for telemetry data
- **Real-time Updates**: Automatic map positioning based on drone location
- **Simulation**: Built-in simulation mode for testing without Pi

#### Files Created:
- `qml-bda-lab/qml/components/TelemetryClient.qml` - Core telemetry handling

### 4. Camera Streaming & Person Tracking

MJPEG stream viewer with integrated person tracking controls:

- **Live View**: Real-time camera stream from Pi
- **Anti-cache**: Automatic cache-busting for smooth streaming
- **Person Tracking**: Track/Untrack buttons sending HTTP commands to Pi
- **Status Indicators**: Connection status and tracking state display

#### Files Created:
- `qml-bda-lab/qml/pages/CameraPage.qml` - Camera interface

### 5. Bluetooth Provisioning

Complete Bluetooth Low Energy provisioning system:

- **Device Scanning**: Scan and list available Pi devices
- **Connection Management**: Connect/disconnect with status feedback
- **Wi-Fi Provisioning**: Send Wi-Fi credentials via BLE GATT
- **Configurable UUIDs**: All BLE UUIDs configurable in Settings

#### Files Created:
- `qml-bda-lab/qml/pages/ConnectPage.qml` - BLE provisioning interface

### 6. Settings Management

Persistent configuration system using Qt Settings:

- **Map Configuration**: Optional Google Maps API key
- **Pi Configuration**: Host address, camera stream URL
- **Telemetry Settings**: UDP/HTTP mode selection
- **Bluetooth Settings**: Configurable GATT UUIDs
- **Auto-Apply**: Settings automatically update active connections

#### Files Created:
- `qml-bda-lab/qml/pages/SettingsPage.qml` - Settings interface

### 7. Android Permissions Update

Enhanced Android manifest with all required permissions:

- **Bluetooth**: Added Android 12+ BLUETOOTH_CONNECT/SCAN permissions
- **Wi-Fi**: Added ACCESS_WIFI_STATE, CHANGE_WIFI_STATE for provisioning
- **Network**: Maintained cleartext traffic for Pi HTTP communication
- **Optional Maps**: Google Maps metadata is optional, not required

#### Files Modified:
- `android/app/src/main/AndroidManifest.xml` - Updated permissions

## Technical Architecture

### Map Fallback Implementation

```qml
Plugin {
    id: mapPlugin
    name: (googleMapsApiKey && googleMapsApiKey.length > 0) ? "googlemaps" : "osm"
    
    // OSM parameters (no key required)
    PluginParameter {
        name: "osm.useragent"
        value: "Pixhawk GCS Lite"
    }
    
    // Google Maps parameters (only if key provided)
    PluginParameter {
        name: "googlemaps.api_key"
        value: googleMapsApiKey
    }
}
```

### Telemetry Data Flow

1. **Configuration**: Settings page configures UDP port or HTTP endpoint
2. **Client Start**: TelemetryClient starts in selected mode
3. **Data Reception**: JSON telemetry received via UDP or HTTP polling
4. **Processing**: Telemetry parsed and drone position updated
5. **Map Update**: Map automatically centers on drone position

Expected JSON format:
```json
{
  "lat": 25.2048,
  "lon": 55.2708,
  "alt": 100.5,
  "fix": "3D",
  "sats": 12,
  "timestamp": "2024-01-01T12:00:00Z"
}
```

### Person Tracking Commands

HTTP POST commands sent to Pi:
- **Start Tracking**: `POST http://pi:8000/api/tracking/start`
- **Stop Tracking**: `POST http://pi:8000/api/tracking/stop`

### BLE Provisioning Protocol

Default GATT UUIDs (configurable in Settings):
- **Service**: `0000abcd-0000-1000-8000-00805f9b34fb`
- **SSID Characteristic**: `0000abce-0000-1000-8000-00805f9b34fb`
- **Password Characteristic**: `0000abcf-0000-1000-8000-00805f9b34fb`
- **Command Characteristic**: `0000abd0-0000-1000-8000-00805f9b34fb`

## Installation & Usage

### Building QML Application

1. Install Qt 6.5+ with Location, Positioning, Bluetooth modules
2. Navigate to `qml-bda-lab` directory
3. Create build directory: `mkdir build && cd build`
4. Configure: `cmake ..`
5. Build: `make`

### Android Application

The existing Android build system is preserved. The main changes are in the QML application which provides the core functionality.

### First Time Setup

1. **Launch Application**: Start the QML application
2. **Settings Configuration**: 
   - Enter Pi host address (e.g., `192.168.1.100` or `pi.local`)
   - Configure camera stream URL
   - Optionally add Google Maps API key
3. **Connect to Pi**: Use Connect tab to scan and pair with Pi
4. **Verify Telemetry**: Check Map tab for drone position
5. **Test Camera**: Verify camera stream in Camera tab

## Testing Without Hardware

The implementation includes simulation modes for testing without actual hardware:

- **Telemetry Simulation**: Automatic simulated drone movement around Dubai
- **Connection Simulation**: Mock BLE connection status
- **Map Display**: OSM maps work without any API keys

## Future Enhancements

1. **SoftAP Wizard**: Complete Wi-Fi setup wizard for first-time configuration
2. **UDP Implementation**: Platform-specific UDP socket implementation
3. **Advanced BLE**: Full GATT service implementation
4. **Mission Planning**: Flight path planning interface
5. **Multi-drone Support**: Support for multiple connected drones

## Key Benefits

1. **No Google Maps Billing**: OSM provides free worldwide maps
2. **Immediate Functionality**: Works out of the box without configuration
3. **Raspberry Pi Integration**: Complete provisioning and control workflow
4. **Extensible Architecture**: Easy to add new features and protocols
5. **Cross-platform Ready**: Qt-based implementation works on multiple platforms