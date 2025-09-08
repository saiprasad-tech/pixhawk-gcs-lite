import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15
import "../theme"

Page {
    id: mapPage
    
    title: qsTr("Map Display")
    
    property string googleMapsApiKey: ""
    property var dronePosition: QtPositioning.coordinate(0, 0)
    property bool dronePositionValid: false
    property string droneFixType: "No Fix"
    property int droneSatellites: 0
    property real droneAltitude: 0.0
    property date lastTelemetryUpdate: new Date()
    
    // Plugin selection based on API key availability
    Plugin {
        id: mapPlugin
        name: (googleMapsApiKey && googleMapsApiKey.length > 0) ? "googlemaps" : "osm"
        
        // OSM plugin parameters (no key required)
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
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Status bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Theme.currentCardBackground
            border.color: Theme.outline
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingM
                spacing: Theme.spacingL
                
                // Map provider indicator
                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 30
                    color: mapPlugin.name === "googlemaps" ? Theme.secondary : Theme.primary
                    radius: Theme.cornerRadiusS
                    
                    Text {
                        anchors.centerIn: parent
                        text: mapPlugin.name === "googlemaps" ? qsTr("Google Maps") : qsTr("OpenStreetMap")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodySmall
                        color: mapPlugin.name === "googlemaps" ? Theme.onSecondary : Theme.onPrimary
                    }
                }
                
                // Drone status
                ColumnLayout {
                    spacing: 2
                    
                    Text {
                        text: qsTr("Drone Position")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLabelMedium
                        color: Theme.currentOnSurface
                    }
                    
                    Text {
                        text: dronePositionValid ? 
                              qsTr("Lat: %1, Lon: %2").arg(dronePosition.latitude.toFixed(6)).arg(dronePosition.longitude.toFixed(6)) :
                              qsTr("No position data")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodySmall
                        color: dronePositionValid ? Theme.currentOnSurface : Theme.error
                    }
                }
                
                Item { Layout.fillWidth: true } // Spacer
                
                // Telemetry info
                ColumnLayout {
                    spacing: 2
                    
                    Text {
                        text: qsTr("Fix: %1 | Sats: %2").arg(droneFixType).arg(droneSatellites)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodySmall
                        color: Theme.currentOnSurface
                    }
                    
                    Text {
                        text: qsTr("Alt: %1m").arg(droneAltitude.toFixed(1))
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodySmall
                        color: Theme.currentOnSurface
                    }
                }
            }
        }
        
        // Map view
        Map {
            id: map
            Layout.fillWidth: true
            Layout.fillHeight: true
            plugin: mapPlugin
            center: dronePositionValid ? dronePosition : QtPositioning.coordinate(25.2048, 55.2708) // Default to Dubai
            zoomLevel: dronePositionValid ? 16 : 10
            
            // Map gesture handling
            gesture.enabled: true
            gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
            
            // Drone marker
            MapQuickItem {
                id: droneMarker
                visible: dronePositionValid
                coordinate: dronePosition
                anchorPoint.x: droneIcon.width / 2
                anchorPoint.y: droneIcon.height / 2
                
                sourceItem: Rectangle {
                    id: droneIcon
                    width: 40
                    height: 40
                    radius: 20
                    color: Theme.primary
                    border.color: Theme.onPrimary
                    border.width: 2
                    
                    // Drone symbol
                    Text {
                        anchors.centerIn: parent
                        text: "✈"
                        font.family: Theme.fontFamily
                        font.pixelSize: 18
                        color: Theme.onPrimary
                    }
                    
                    // Pulsing animation for active tracking
                    SequentialAnimation on scale {
                        running: dronePositionValid
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.2; duration: 1000; easing.type: Easing.InOutQuad }
                        NumberAnimation { from: 1.2; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                    }
                }
            }
            
            // Info popup when marker is clicked
            MapQuickItem {
                id: droneInfoPopup
                visible: false
                coordinate: dronePosition
                anchorPoint.x: droneInfoCard.width / 2
                anchorPoint.y: droneInfoCard.height + 10
                
                sourceItem: Rectangle {
                    id: droneInfoCard
                    width: 200
                    height: infoColumn.height + 20
                    color: Theme.currentCardBackground
                    radius: Theme.cornerRadiusM
                    border.color: Theme.outline
                    border.width: 1
                    
                    ColumnLayout {
                        id: infoColumn
                        anchors.centerIn: parent
                        width: parent.width - 20
                        spacing: 5
                        
                        Text {
                            text: qsTr("Drone Information")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTitleSmall
                            font.weight: Theme.fontWeightMedium
                            color: Theme.primary
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: qsTr("Position: %1, %2").arg(dronePosition.latitude.toFixed(6)).arg(dronePosition.longitude.toFixed(6))
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: qsTr("Altitude: %1m").arg(droneAltitude.toFixed(1))
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                        }
                        
                        Text {
                            text: qsTr("GPS Fix: %1").arg(droneFixType)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                        }
                        
                        Text {
                            text: qsTr("Satellites: %1").arg(droneSatellites)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                        }
                        
                        Text {
                            text: qsTr("Last Update: %1").arg(Qt.formatTime(lastTelemetryUpdate, "hh:mm:ss"))
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.secondary
                        }
                    }
                }
            }
            
            // Tap handler for drone marker
            TapHandler {
                target: droneMarker.sourceItem
                onTapped: {
                    droneInfoPopup.visible = !droneInfoPopup.visible
                }
            }
            
            // Hide popup when map is panned/zoomed
            onCenterChanged: {
                droneInfoPopup.visible = false
            }
        }
        
        // Map controls overlay
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Center on drone button
            Button {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: Theme.spacingM
                anchors.bottomMargin: Theme.spacingM
                width: 50
                height: 50
                enabled: dronePositionValid
                
                background: Rectangle {
                    color: enabled ? Theme.primary : Theme.outline
                    radius: 25
                    opacity: 0.9
                }
                
                contentItem: Text {
                    text: "🎯"
                    font.pixelSize: 20
                    color: Theme.onPrimary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    if (dronePositionValid) {
                        map.center = dronePosition
                        map.zoomLevel = 16
                    }
                }
            }
        }
    }
    
    // Functions to update drone data (called from telemetry client)
    function updateDronePosition(lat, lon, alt, fix, sats) {
        dronePosition = QtPositioning.coordinate(lat, lon)
        dronePositionValid = true
        droneAltitude = alt
        droneFixType = fix
        droneSatellites = sats
        lastTelemetryUpdate = new Date()
    }
    
    function clearDronePosition() {
        dronePositionValid = false
        droneFixType = "No Fix"
        droneSatellites = 0
        droneAltitude = 0.0
    }
}