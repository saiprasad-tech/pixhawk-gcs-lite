# Pixhawk GCS Lite - Multi-Platform Ground Control Station

This repository contains both Android (Compose) and Qt/QML implementations of the Pixhawk Ground Control Station, designed for MAVLink-compatible drones and UAVs.

## Project Structure

```
pixhawk-gcs-lite/
├── android/                 # Android Compose application
│   ├── app/
│   │   ├── src/main/java/   # Kotlin source code
│   │   ├── src/main/res/    # Android resources
│   │   └── build.gradle     # App-level build configuration
│   ├── build.gradle         # Project-level build configuration
│   └── settings.gradle      # Project settings
│
├── qml-bda-lab/            # Qt/QML application (from BDA-Lab)
│   ├── qml/theme/          # Centralized theme system
│   ├── src/                # C++ source code
│   ├── resources/          # QML resources and assets
│   ├── CMakeLists.txt      # CMake build configuration
│   └── THEME.md            # Theme customization guide
│
├── README.md               # This file
└── .gitignore             # Git ignore rules
```

## Theme Design

Both applications use a consistent **Red/White/Gold Emirates-inspired theme**:

- **Primary**: `#D71920` (Deep Red)  
- **Secondary**: `#CBB46A` (Gold)
- **Typography**: Source Sans 3 (open-source, easily replaceable)
- **Support**: Light and dark modes

## Build Instructions

### Android Application

#### Prerequisites
- Android Studio Arctic Fox (2020.3.1) or newer
- JDK 8 or higher
- Android SDK API Level 24+ (Android 7.0+)

#### Setup
1. Open Android Studio
2. Select "Open an Existing Project"  
3. Navigate to the `android/` directory in this repository
4. Wait for Gradle sync to complete

#### Google Maps API Key Configuration
1. Get a Google Maps API key from the [Google Cloud Console](https://console.cloud.google.com/)
2. Create `android/local.properties` file (if it doesn't exist)
3. Add your API key:
   ```properties
   MAPS_API_KEY=your_actual_api_key_here
   ```
   > ⚠️ **Never commit the local.properties file or put API keys in version control**

#### Building
- **Debug APK**: `./gradlew assembleDebug`
- **Release APK**: `./gradlew assembleRelease`
- **Install on device**: `./gradlew installDebug`

### Qt/QML Application

#### Prerequisites
- Qt 6.5 or newer
- Qt Creator IDE (recommended)
- CMake 3.25 or higher

#### For Android builds additionally:
- Android SDK (API Level 24+)
- Android NDK r25 or newer
- JDK 8 or higher
- Qt for Android components

#### Setup
1. Open Qt Creator
2. File → Open File or Project
3. Select `qml-bda-lab/CMakeLists.txt`
4. Configure the project with your preferred Qt kit

#### Building for Desktop
1. Select a Desktop Qt kit (Linux, macOS, or Windows)
2. Build → Build Project
3. Run → Run to test the application

#### Building for Android
1. Configure an Android Qt kit in Qt Creator:
   - Tools → Options → Devices → Android
   - Set Android SDK and NDK paths
2. Select the Android Qt kit
3. Build → Build Project
4. Deploy to connected Android device

#### APK Location
Built APKs will be in the build directory, typically:
- Debug: `build-qml-bda-lab-Android_Qt_*-Debug/android-build/build/outputs/apk/debug/`

## Features

### Android App
- Material Design 3 with custom red/gold theme
- Bluetooth connectivity for MAVLink devices
- Google Maps integration for flight tracking
- Compose-based modern UI

### QML App  
- Cross-platform Qt Quick interface
- Centralized theme system
- Advanced flight planning capabilities
- Instrument displays and HUD overlays

## Privacy & Data Access

**Important**: This application does **NOT** have access to your repositories, personal files, or other applications. 

### What the application accesses:
- **Device sensors** (GPS, compass) for flight control
- **Bluetooth/Serial** for connecting to flight controllers
- **Internet** for map downloads (Google Maps integration)
- **Local storage** for configuration and flight logs

### What it does NOT access:
- Git repositories or version control systems
- Personal files, documents, or photos
- Other applications on your device
- Cloud storage services (except map caching)

For complete details, see [PRIVACY.md](PRIVACY.md).

## Font Customization

Both applications default to **Source Sans 3** (open-source). To use a licensed Emirates-like font:

### Android
1. Add font files to `android/app/src/main/res/font/`
2. Update `FontFamily` in `ui/theme/Type.kt`

### QML
1. Add font files to `qml-bda-lab/resources/fonts/`  
2. Update `fontFamily` in `qml/theme/Theme.qml`
3. See `qml-bda-lab/THEME.md` for detailed instructions

## Development Guidelines

### Security
- Never commit API keys, passwords, or secrets
- Use manifest placeholders for Android API keys
- Store sensitive configuration in local.properties (Android) or environment variables
- **Data Privacy**: This application operates locally and does not access user repositories or personal files
- All data is stored locally on the user's device
- Internet access is limited to map services and MAVLink connections

### Theme Consistency
- Use centralized theme colors and typography
- Test both light and dark modes
- Maintain color contrast ratios for accessibility

### Code Style
- Follow platform conventions (Kotlin for Android, C++/QML for Qt)
- Use meaningful variable and function names
- Document complex logic and API integrations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes while maintaining theme consistency
4. Test on both platforms if applicable
5. Submit a pull request

## License

This project is licensed under [appropriate license]. See individual components for specific licensing requirements.

## Support

For issues and questions:
- Check the documentation in each platform directory
- Review the THEME.md for styling questions
- See [PRIVACY.md](PRIVACY.md) for data access and privacy questions
- Open GitHub issues for bugs or feature requests

## Roadmap

- [ ] MAVLink protocol integration
- [ ] Real-time telemetry display
- [ ] Mission planning interface
- [ ] Multi-vehicle support
- [ ] Offline map capabilities
- [ ] Custom widget system