import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtBluetooth 5.15
import "../theme"

Page {
    id: connectPage
    
    title: qsTr("Connect to Pi")
    
    property bool isScanning: false
    property bool isConnected: false
    property string connectedDeviceName: ""
    property bool wifiProvisioningMode: false
    
    // Bluetooth discovery agent
    BluetoothDiscoveryModel {
        id: bluetoothModel
        running: isScanning
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        
        onRunningChanged: {
            if (!running) {
                isScanning = false
            }
        }
        
        onErrorChanged: {
            if (error !== BluetoothDiscoveryModel.NoError) {
                console.log("Bluetooth discovery error:", error)
                isScanning = false
            }
        }
    }
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: Theme.spacingM
        
        ColumnLayout {
            width: parent.width
            spacing: Theme.spacingL
            
            // Connection status card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                color: Theme.currentCardBackground
                radius: Theme.cornerRadiusM
                border.color: Theme.outline
                border.width: 1
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacingS
                    
                    Text {
                        text: isConnected ? qsTr("🔗 Connected") : qsTr("📱 Not Connected")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTitleLarge
                        color: isConnected ? "#4CAF50" : Theme.secondary
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: isConnected ? 
                              qsTr("Connected to: %1").arg(connectedDeviceName) :
                              qsTr("Search for Raspberry Pi devices")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodyMedium
                        color: Theme.currentOnSurface
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            // Bluetooth controls
            GroupBox {
                title: qsTr("Bluetooth Connection")
                Layout.fillWidth: true
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacingM
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacingM
                        
                        Button {
                            text: isScanning ? qsTr("Stop Scan") : qsTr("Scan for Devices")
                            font.family: Theme.fontFamily
                            enabled: !isConnected
                            
                            background: Rectangle {
                                color: isScanning ? Theme.error : Theme.primary
                                radius: Theme.cornerRadiusS
                                opacity: parent.enabled ? 1.0 : 0.5
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: isScanning ? Theme.onError : Theme.onPrimary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                if (isScanning) {
                                    stopScan()
                                } else {
                                    startScan()
                                }
                            }
                        }
                        
                        Button {
                            text: qsTr("Disconnect")
                            font.family: Theme.fontFamily
                            enabled: isConnected
                            
                            background: Rectangle {
                                color: Theme.error
                                radius: Theme.cornerRadiusS
                                opacity: parent.enabled ? 1.0 : 0.5
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: Theme.onError
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                disconnectDevice()
                            }
                        }
                    }
                    
                    // Device list
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        color: Theme.currentBackground
                        radius: Theme.cornerRadiusS
                        border.color: Theme.outline
                        border.width: 1
                        
                        ListView {
                            id: deviceListView
                            anchors.fill: parent
                            anchors.margins: Theme.spacingS
                            model: bluetoothModel
                            clip: true
                            
                            delegate: Rectangle {
                                width: deviceListView.width
                                height: 60
                                color: deviceMouseArea.containsMouse ? Theme.secondary : "transparent"
                                radius: Theme.cornerRadiusS
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Theme.spacingS
                                    spacing: Theme.spacingM
                                    
                                    Text {
                                        text: "📟"
                                        font.pixelSize: 24
                                        color: Theme.primary
                                    }
                                    
                                    ColumnLayout {
                                        spacing: 2
                                        Layout.fillWidth: true
                                        
                                        Text {
                                            text: model.name || qsTr("Unknown Device")
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeTitleSmall
                                            color: Theme.currentOnSurface
                                        }
                                        
                                        Text {
                                            text: model.address
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeBodySmall
                                            color: Theme.secondary
                                        }
                                    }
                                    
                                    Button {
                                        text: qsTr("Connect")
                                        font.family: Theme.fontFamily
                                        enabled: !isConnected
                                        
                                        background: Rectangle {
                                            color: Theme.primary
                                            radius: Theme.cornerRadiusS
                                            opacity: parent.enabled ? 1.0 : 0.5
                                        }
                                        
                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            color: Theme.onPrimary
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        
                                        onClicked: {
                                            connectToDevice(model.address, model.name)
                                        }
                                    }
                                }
                                
                                MouseArea {
                                    id: deviceMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }
                            
                            // Empty state
                            Text {
                                anchors.centerIn: parent
                                text: isScanning ? qsTr("Scanning for devices...") : qsTr("No devices found. Tap 'Scan for Devices' to search.")
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeBodyMedium
                                color: Theme.secondary
                                visible: deviceListView.count === 0
                                wrapMode: Text.WordWrap
                                width: parent.width - 40
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }
            }
            
            // Wi-Fi Provisioning
            GroupBox {
                title: qsTr("Wi-Fi Provisioning")
                Layout.fillWidth: true
                visible: isConnected
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacingM
                    
                    Text {
                        text: qsTr("Send Wi-Fi credentials to the Raspberry Pi")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodyMedium
                        color: Theme.currentOnSurface
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    
                    TextField {
                        id: ssidField
                        Layout.fillWidth: true
                        placeholderText: qsTr("Wi-Fi Network Name (SSID)")
                        font.family: Theme.fontFamily
                    }
                    
                    TextField {
                        id: passwordField
                        Layout.fillWidth: true
                        placeholderText: qsTr("Wi-Fi Password")
                        font.family: Theme.fontFamily
                        echoMode: TextInput.Password
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Button {
                            text: qsTr("Send Wi-Fi Credentials")
                            font.family: Theme.fontFamily
                            enabled: ssidField.text.length > 0 && passwordField.text.length > 0
                            Layout.fillWidth: true
                            
                            background: Rectangle {
                                color: Theme.secondary
                                radius: Theme.cornerRadiusS
                                opacity: parent.enabled ? 1.0 : 0.5
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: Theme.onSecondary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                sendWifiCredentials(ssidField.text, passwordField.text)
                            }
                        }
                        
                        Button {
                            text: qsTr("SoftAP Setup")
                            font.family: Theme.fontFamily
                            
                            background: Rectangle {
                                color: Theme.primary
                                radius: Theme.cornerRadiusS
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: Theme.onPrimary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                // Show SoftAP wizard (to be implemented)
                                console.log("SoftAP setup requested")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Loading indicator
    BusyIndicator {
        anchors.centerIn: parent
        running: isScanning
        visible: running
        
        Material.accent: Theme.primary
    }
    
    // Functions
    function startScan() {
        console.log("Starting Bluetooth scan...")
        isScanning = true
        bluetoothModel.running = true
    }
    
    function stopScan() {
        console.log("Stopping Bluetooth scan...")
        bluetoothModel.running = false
        isScanning = false
    }
    
    function connectToDevice(address, name) {
        console.log("Connecting to device:", name, "at", address)
        // Here you would implement actual Bluetooth connection logic
        // For now, simulate connection
        isConnected = true
        connectedDeviceName = name || qsTr("Raspberry Pi")
        stopScan()
    }
    
    function disconnectDevice() {
        console.log("Disconnecting from device...")
        isConnected = false
        connectedDeviceName = ""
    }
    
    function sendWifiCredentials(ssid, password) {
        console.log("Sending Wi-Fi credentials via BLE...")
        // Here you would implement GATT characteristic writing
        // For now, simulate sending
        
        // Clear fields after sending
        ssidField.text = ""
        passwordField.text = ""
        
        // Show confirmation (you might want to add a toast notification)
        console.log("Wi-Fi credentials sent successfully")
    }
}