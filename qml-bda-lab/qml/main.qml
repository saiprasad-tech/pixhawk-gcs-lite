import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "theme"
import "pages"
import "components"

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: qsTr("Pixhawk GCS Lite")
    
    // Set application colors based on theme
    color: Theme.currentBackground
    
    // Global settings access
    property alias settings: settingsPage.settings
    
    // Telemetry client
    TelemetryClient {
        id: telemetryClient
        
        onTelemetryUpdated: {
            // Update map page with new drone position
            if (hasValidPosition) {
                mapPage.updateDronePosition(latitude, longitude, altitude, fixType, satellites)
            }
        }
        
        Component.onCompleted: {
            // Configure from settings when available
            if (settingsPage.useTelemetryUdp) {
                setUdpMode(settingsPage.telemetryPort)
            } else {
                setHttpMode(settingsPage.telemetryEndpoint)
            }
            start()
        }
    }
    
    header: ToolBar {
        background: Rectangle {
            color: Theme.primary
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacingM
            anchors.rightMargin: Theme.spacingM
            
            Text {
                text: qsTr("Pixhawk GCS Lite")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTitleLarge
                font.weight: Theme.fontWeightMedium
                color: Theme.onPrimary
                Layout.fillWidth: true
            }
            
            // Connection status indicator
            RowLayout {
                spacing: Theme.spacingS
                
                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: telemetryClient.isConnected ? "#4CAF50" : "#F44336"
                    
                    SequentialAnimation on opacity {
                        running: telemetryClient.isConnected
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 0.3; duration: 1000 }
                        NumberAnimation { from: 0.3; to: 1.0; duration: 1000 }
                    }
                }
                
                Text {
                    text: telemetryClient.isConnected ? qsTr("Connected") : qsTr("Offline")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBodySmall
                    color: Theme.onPrimary
                }
            }
            
            Button {
                text: qsTr("🌙")
                width: 40
                height: 40
                font.pixelSize: 16
                
                background: Rectangle {
                    color: Theme.secondary
                    radius: Theme.cornerRadiusS
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: Theme.onSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    Theme.isDarkMode = !Theme.isDarkMode
                }
            }
        }
    }
    
    // Main content with tab navigation
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Tab bar
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            background: Rectangle {
                color: Theme.currentCardBackground
                Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: Theme.outline
                }
            }
            
            TabButton {
                text: qsTr("Connect")
                font.family: Theme.fontFamily
                
                background: Rectangle {
                    color: parent.checked ? Theme.primary : "transparent"
                    radius: Theme.cornerRadiusS
                    opacity: parent.checked ? 1.0 : 0.1
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.checked ? Theme.onPrimary : Theme.currentOnSurface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            TabButton {
                text: qsTr("Map")
                font.family: Theme.fontFamily
                
                background: Rectangle {
                    color: parent.checked ? Theme.primary : "transparent"
                    radius: Theme.cornerRadiusS
                    opacity: parent.checked ? 1.0 : 0.1
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.checked ? Theme.onPrimary : Theme.currentOnSurface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            TabButton {
                text: qsTr("Camera")
                font.family: Theme.fontFamily
                
                background: Rectangle {
                    color: parent.checked ? Theme.primary : "transparent"
                    radius: Theme.cornerRadiusS
                    opacity: parent.checked ? 1.0 : 0.1
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.checked ? Theme.onPrimary : Theme.currentOnSurface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            TabButton {
                text: qsTr("Settings")
                font.family: Theme.fontFamily
                
                background: Rectangle {
                    color: parent.checked ? Theme.primary : "transparent"
                    radius: Theme.cornerRadiusS
                    opacity: parent.checked ? 1.0 : 0.1
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.checked ? Theme.onPrimary : Theme.currentOnSurface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        // Page content
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex
            
            // Connect Page
            ConnectPage {
                id: connectPage
            }
            
            // Map Page
            MapPage {
                id: mapPage
                googleMapsApiKey: settingsPage.googleMapsApiKey
            }
            
            // Camera Page
            CameraPage {
                id: cameraPage
                streamUrl: settingsPage.cameraStreamUrl
            }
            
            // Settings Page
            SettingsPage {
                id: settingsPage
                
                // When settings change, update telemetry client
                onUseTelemetryUdpChanged: {
                    telemetryClient.stop()
                    if (useTelemetryUdp) {
                        telemetryClient.setUdpMode(telemetryPort)
                    } else {
                        telemetryClient.setHttpMode(telemetryEndpoint)
                    }
                    telemetryClient.start()
                }
                
                onTelemetryPortChanged: {
                    if (useTelemetryUdp && telemetryClient.isConnected) {
                        telemetryClient.stop()
                        telemetryClient.setUdpMode(telemetryPort)
                        telemetryClient.start()
                    }
                }
                
                onTelemetryEndpointChanged: {
                    if (!useTelemetryUdp && telemetryClient.isConnected) {
                        telemetryClient.stop()
                        telemetryClient.setHttpMode(telemetryEndpoint)
                        telemetryClient.start()
                    }
                }
            }
        }
    }
}