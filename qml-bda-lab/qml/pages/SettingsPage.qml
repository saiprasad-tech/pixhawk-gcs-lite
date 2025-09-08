import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0
import "../theme"

Page {
    id: settingsPage
    
    title: qsTr("Settings")
    
    // Settings storage
    Settings {
        id: settings
        property string googleMapsApiKey: ""
        property string piHostAddress: "192.168.1.100"
        property int telemetryPort: 14555
        property string telemetryEndpoint: "http://pi.local:8000/api/telemetry"
        property string cameraStreamUrl: "http://pi.local:8080/stream.mjpeg"
        property bool useTelemetryUdp: true
        property string bleServiceUuid: "0000abcd-0000-1000-8000-00805f9b34fb"
        property string bleSsidCharUuid: "0000abce-0000-1000-8000-00805f9b34fb"
        property string blePassCharUuid: "0000abcf-0000-1000-8000-00805f9b34fb"
        property string bleCommandCharUuid: "0000abd0-0000-1000-8000-00805f9b34fb"
    }
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: Theme.spacingM
        
        ColumnLayout {
            width: parent.width
            spacing: Theme.spacingL
            
            // Maps Configuration
            GroupBox {
                title: qsTr("Maps Configuration")
                Layout.fillWidth: true
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacingM
                    
                    Label {
                        text: qsTr("Google Maps API Key (Optional)")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTitleSmall
                        color: Theme.currentOnSurface
                    }
                    
                    TextField {
                        id: apiKeyField
                        Layout.fillWidth: true
                        placeholderText: qsTr("Enter Google Maps API key for enhanced maps...")
                        text: settings.googleMapsApiKey
                        font.family: Theme.fontFamily
                        echoMode: TextInput.Password
                        
                        onTextChanged: {
                            settings.googleMapsApiKey = text
                        }
                    }
                    
                    Label {
                        text: qsTr("Leave empty to use OpenStreetMap (free, no key required)")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodySmall
                        color: Theme.secondary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
            
            // Raspberry Pi Configuration
            GroupBox {
                title: qsTr("Raspberry Pi Configuration")
                Layout.fillWidth: true
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacingM
                    
                    Label {
                        text: qsTr("Pi Host Address/IP")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTitleSmall
                        color: Theme.currentOnSurface
                    }
                    
                    TextField {
                        Layout.fillWidth: true
                        placeholderText: qsTr("e.g., 192.168.1.100 or pi.local")
                        text: settings.piHostAddress
                        font.family: Theme.fontFamily
                        
                        onTextChanged: {
                            settings.piHostAddress = text
                        }
                    }
                    
                    Label {
                        text: qsTr("Camera Stream URL")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTitleSmall
                        color: Theme.currentOnSurface
                    }
                    
                    TextField {
                        Layout.fillWidth: true
                        placeholderText: qsTr("http://pi.local:8080/stream.mjpeg")
                        text: settings.cameraStreamUrl
                        font.family: Theme.fontFamily
                        
                        onTextChanged: {
                            settings.cameraStreamUrl = text
                        }
                    }
                }
            }
            
            // Telemetry Configuration
            GroupBox {
                title: qsTr("Telemetry Configuration")
                Layout.fillWidth: true
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacingM
                    
                    RadioButton {
                        text: qsTr("UDP JSON Mode")
                        checked: settings.useTelemetryUdp
                        font.family: Theme.fontFamily
                        
                        onCheckedChanged: {
                            if (checked) {
                                settings.useTelemetryUdp = true
                            }
                        }
                    }
                    
                    SpinBox {
                        Layout.fillWidth: true
                        from: 1024
                        to: 65535
                        value: settings.telemetryPort
                        prefix: qsTr("Port: ")
                        enabled: settings.useTelemetryUdp
                        
                        onValueChanged: {
                            settings.telemetryPort = value
                        }
                    }
                    
                    RadioButton {
                        text: qsTr("HTTP Poll Mode")
                        checked: !settings.useTelemetryUdp
                        font.family: Theme.fontFamily
                        
                        onCheckedChanged: {
                            if (checked) {
                                settings.useTelemetryUdp = false
                            }
                        }
                    }
                    
                    TextField {
                        Layout.fillWidth: true
                        placeholderText: qsTr("http://pi.local:8000/api/telemetry")
                        text: settings.telemetryEndpoint
                        font.family: Theme.fontFamily
                        enabled: !settings.useTelemetryUdp
                        
                        onTextChanged: {
                            settings.telemetryEndpoint = text
                        }
                    }
                }
            }
            
            // Bluetooth Configuration
            GroupBox {
                title: qsTr("Bluetooth Configuration")
                Layout.fillWidth: true
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacingM
                    
                    Label {
                        text: qsTr("Service UUID")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTitleSmall
                        color: Theme.currentOnSurface
                    }
                    
                    TextField {
                        Layout.fillWidth: true
                        text: settings.bleServiceUuid
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodySmall
                        
                        onTextChanged: {
                            settings.bleServiceUuid = text
                        }
                    }
                    
                    // Collapsible section for advanced UUIDs
                    Button {
                        text: qsTr("Show Advanced Bluetooth Settings")
                        checkable: true
                        font.family: Theme.fontFamily
                        
                        background: Rectangle {
                            color: parent.checked ? Theme.secondary : Theme.currentCardBackground
                            radius: Theme.cornerRadiusS
                            border.color: Theme.outline
                        }
                    }
                }
            }
        }
    }
    
    // Expose settings for other components
    property alias googleMapsApiKey: settings.googleMapsApiKey
    property alias piHostAddress: settings.piHostAddress
    property alias telemetryPort: settings.telemetryPort
    property alias telemetryEndpoint: settings.telemetryEndpoint
    property alias cameraStreamUrl: settings.cameraStreamUrl
    property alias useTelemetryUdp: settings.useTelemetryUdp
}