import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme"

Page {
    id: cameraPage
    
    title: qsTr("Pi Camera")
    
    property string streamUrl: "http://pi.local:8080/stream.mjpeg"
    property bool isStreaming: false
    property bool trackingEnabled: false
    property string connectionStatus: "Disconnected"
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Camera controls header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Theme.currentCardBackground
            border.color: Theme.outline
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingM
                spacing: Theme.spacingL
                
                // Stream status
                RowLayout {
                    spacing: Theme.spacingS
                    
                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: isStreaming ? "#4CAF50" : "#F44336"
                        
                        SequentialAnimation on opacity {
                            running: isStreaming
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 0.3; duration: 500 }
                            NumberAnimation { from: 0.3; to: 1.0; duration: 500 }
                        }
                    }
                    
                    Text {
                        text: connectionStatus
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTitleSmall
                        color: Theme.currentOnSurface
                    }
                }
                
                // Stream URL display
                Text {
                    text: qsTr("Stream: %1").arg(streamUrl)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBodySmall
                    color: Theme.secondary
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                }
                
                // Person tracking controls
                RowLayout {
                    spacing: Theme.spacingS
                    
                    Button {
                        text: trackingEnabled ? qsTr("Untrack") : qsTr("Track Person")
                        font.family: Theme.fontFamily
                        enabled: isStreaming
                        
                        background: Rectangle {
                            color: trackingEnabled ? Theme.error : Theme.primary
                            radius: Theme.cornerRadiusS
                            opacity: parent.enabled ? 1.0 : 0.5
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: trackingEnabled ? Theme.onError : Theme.onPrimary
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            if (trackingEnabled) {
                                stopPersonTracking()
                            } else {
                                startPersonTracking()
                            }
                        }
                    }
                    
                    Button {
                        text: qsTr("Refresh")
                        font.family: Theme.fontFamily
                        
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
                            refreshStream()
                        }
                    }
                }
            }
        }
        
        // Camera stream display
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#000000"
            
            // Stream view
            Image {
                id: streamImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: false
                source: isStreaming ? streamUrl + "?_=" + Date.now() : "" // Anti-cache parameter
                
                onStatusChanged: {
                    if (status === Image.Ready) {
                        connectionStatus = "Connected - Streaming"
                        isStreaming = true
                    } else if (status === Image.Error) {
                        connectionStatus = "Error - Cannot connect to stream"
                        isStreaming = false
                    } else if (status === Image.Loading) {
                        connectionStatus = "Connecting..."
                    }
                }
            }
            
            // Overlay for no stream
            Rectangle {
                anchors.fill: parent
                color: Theme.currentBackground
                opacity: 0.9
                visible: !isStreaming
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacingL
                    
                    Text {
                        text: "📹"
                        font.pixelSize: 64
                        color: Theme.secondary
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: qsTr("No Camera Stream")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeTitleLarge
                        color: Theme.currentOnSurface
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: qsTr("Make sure the Pi camera is running and accessible")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodyMedium
                        color: Theme.secondary
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.WordWrap
                        Layout.maximumWidth: 300
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    Button {
                        text: qsTr("Try Connect")
                        font.family: Theme.fontFamily
                        Layout.alignment: Qt.AlignHCenter
                        
                        background: Rectangle {
                            color: Theme.primary
                            radius: Theme.cornerRadiusM
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: Theme.onPrimary
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            refreshStream()
                        }
                    }
                }
            }
            
            // Tracking status overlay
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Theme.spacingM
                width: trackingStatusText.width + 20
                height: trackingStatusText.height + 10
                color: trackingEnabled ? Qt.rgba(76/255, 175/255, 80/255, 0.8) : Qt.rgba(0, 0, 0, 0.6)
                radius: Theme.cornerRadiusS
                visible: isStreaming
                
                Text {
                    id: trackingStatusText
                    anchors.centerIn: parent
                    text: trackingEnabled ? qsTr("🎯 Person Tracking Active") : qsTr("👁 Live View")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBodySmall
                    color: "#FFFFFF"
                }
            }
        }
    }
    
    // Auto-refresh timer to keep stream alive
    Timer {
        id: refreshTimer
        interval: 30000 // 30 seconds
        running: isStreaming
        repeat: true
        onTriggered: {
            // Add a small cache-busting parameter to keep the stream fresh
            streamImage.source = streamUrl + "?_=" + Date.now()
        }
    }
    
    // Functions to control person tracking
    function startPersonTracking() {
        console.log("Starting person tracking...")
        trackingEnabled = true
        
        // Send HTTP command to Pi
        var xhr = new XMLHttpRequest()
        xhr.open("POST", "http://" + streamUrl.split("://")[1].split(":")[0] + ":8000/api/tracking/start")
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    console.log("Person tracking started successfully")
                } else {
                    console.log("Failed to start person tracking:", xhr.status)
                    trackingEnabled = false
                }
            }
        }
        xhr.send(JSON.stringify({command: "TRACK_START"}))
    }
    
    function stopPersonTracking() {
        console.log("Stopping person tracking...")
        trackingEnabled = false
        
        // Send HTTP command to Pi
        var xhr = new XMLHttpRequest()
        xhr.open("POST", "http://" + streamUrl.split("://")[1].split(":")[0] + ":8000/api/tracking/stop")
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    console.log("Person tracking stopped successfully")
                } else {
                    console.log("Failed to stop person tracking:", xhr.status)
                }
            }
        }
        xhr.send(JSON.stringify({command: "TRACK_STOP"}))
    }
    
    function refreshStream() {
        console.log("Refreshing camera stream...")
        isStreaming = false
        connectionStatus = "Connecting..."
        
        // Force reload the image
        streamImage.source = ""
        streamImage.source = streamUrl + "?_=" + Date.now()
    }
    
    // Component initialization
    Component.onCompleted: {
        refreshStream()
    }
}