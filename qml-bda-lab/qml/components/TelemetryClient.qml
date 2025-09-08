import QtQuick 2.15
import QtNetwork 5.15
import "../theme"

QtObject {
    id: telemetryClient
    
    // Properties
    property bool isConnected: false
    property bool useUdpMode: true
    property int udpPort: 14555
    property string httpEndpoint: "http://pi.local:8000/api/telemetry"
    property int httpPollInterval: 1000 // milliseconds
    
    // Drone data properties
    property real latitude: 0.0
    property real longitude: 0.0
    property real altitude: 0.0
    property string fixType: "No Fix"
    property int satellites: 0
    property date lastUpdate: new Date()
    property bool hasValidPosition: false
    
    // UDP Socket for receiving telemetry
    property var udpSocket: null
    
    // HTTP timer for polling
    Timer {
        id: httpTimer
        interval: telemetryClient.httpPollInterval
        running: !telemetryClient.useUdpMode && telemetryClient.isConnected
        repeat: true
        onTriggered: {
            pollTelemetryHttp()
        }
    }
    
    // UDP Socket creation
    Component {
        id: udpSocketComponent
        
        Item {
            property alias socket: udpSocket
            
            UdpSocket {
                id: udpSocket
                
                onReadyRead: {
                    while (hasPendingDatagrams()) {
                        var datagram = receiveDatagram()
                        try {
                            var data = JSON.parse(datagram.data)
                            processTelemetryData(data)
                        } catch (e) {
                            console.log("Failed to parse UDP telemetry data:", e)
                        }
                    }
                }
                
                onErrorOccurred: function(error) {
                    console.log("UDP Socket error:", error)
                    telemetryClient.isConnected = false
                }
            }
        }
    }
    
    // Start telemetry client
    function start() {
        console.log("Starting telemetry client...")
        
        if (useUdpMode) {
            startUdpMode()
        } else {
            startHttpMode()
        }
    }
    
    // Stop telemetry client
    function stop() {
        console.log("Stopping telemetry client...")
        isConnected = false
        
        if (udpSocket) {
            udpSocket.close()
            udpSocket = null
        }
    }
    
    // Start UDP mode
    function startUdpMode() {
        console.log("Starting UDP telemetry on port", udpPort)
        
        if (udpSocket) {
            udpSocket.close()
        }
        
        // Create UDP socket
        var socketItem = udpSocketComponent.createObject(telemetryClient)
        if (socketItem) {
            udpSocket = socketItem.socket
            
            if (udpSocket.bind(udpPort)) {
                console.log("UDP socket bound to port", udpPort)
                isConnected = true
            } else {
                console.log("Failed to bind UDP socket to port", udpPort)
                isConnected = false
            }
        }
    }
    
    // Start HTTP polling mode
    function startHttpMode() {
        console.log("Starting HTTP telemetry polling:", httpEndpoint)
        isConnected = true
        // Timer will start automatically due to binding
    }
    
    // Poll telemetry via HTTP
    function pollTelemetryHttp() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", httpEndpoint)
        xhr.timeout = 5000 // 5 second timeout
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText)
                        processTelemetryData(data)
                    } catch (e) {
                        console.log("Failed to parse HTTP telemetry data:", e)
                    }
                } else {
                    console.log("HTTP telemetry request failed:", xhr.status)
                    // Don't mark as disconnected for occasional failures
                }
            }
        }
        
        xhr.ontimeout = function() {
            console.log("HTTP telemetry request timed out")
        }
        
        xhr.send()
    }
    
    // Process incoming telemetry data
    function processTelemetryData(data) {
        // Expected JSON format:
        // {
        //   "lat": 25.2048,
        //   "lon": 55.2708,
        //   "alt": 100.5,
        //   "fix": "3D",
        //   "sats": 12,
        //   "timestamp": "2024-01-01T12:00:00Z"
        // }
        
        if (data.lat !== undefined && data.lon !== undefined) {
            latitude = data.lat
            longitude = data.lon
            hasValidPosition = true
        }
        
        if (data.alt !== undefined) {
            altitude = data.alt
        }
        
        if (data.fix !== undefined) {
            fixType = data.fix
        }
        
        if (data.sats !== undefined) {
            satellites = data.sats
        }
        
        lastUpdate = new Date()
        
        // Emit signal for UI updates
        telemetryUpdated()
        
        console.log("Telemetry updated:", 
                   "Lat:", latitude.toFixed(6), 
                   "Lon:", longitude.toFixed(6), 
                   "Alt:", altitude.toFixed(1),
                   "Fix:", fixType,
                   "Sats:", satellites)
    }
    
    // Configuration functions
    function setUdpMode(port) {
        if (isConnected) {
            stop()
        }
        useUdpMode = true
        udpPort = port
    }
    
    function setHttpMode(endpoint, interval) {
        if (isConnected) {
            stop()
        }
        useUdpMode = false
        httpEndpoint = endpoint
        if (interval) {
            httpPollInterval = interval
        }
    }
    
    // Get current position as coordinate
    function getCurrentCoordinate() {
        return Qt.createQmlObject(
            'import QtPositioning 5.15; Coordinate { latitude: ' + latitude + '; longitude: ' + longitude + ' }',
            telemetryClient,
            "TelemetryCoordinate"
        )
    }
    
    // Signals
    signal telemetryUpdated()
    signal connectionStatusChanged()
    
    // Cleanup
    Component.onDestruction: {
        stop()
    }
}