import QtQuick 2.15
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
    }
    
    // Start UDP mode (simplified - logs for now)
    function startUdpMode() {
        console.log("UDP telemetry mode enabled on port", udpPort)
        console.log("Note: UDP implementation requires platform-specific code")
        isConnected = true
        
        // Simulate telemetry data for demonstration
        simulateData()
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
    
    // Simulate telemetry data for testing
    Timer {
        id: simulationTimer
        interval: 2000
        running: telemetryClient.useUdpMode && telemetryClient.isConnected
        repeat: true
        onTriggered: {
            simulateData()
        }
    }
    
    function simulateData() {
        // Simulate drone movement around Dubai area
        var baseLat = 25.2048
        var baseLon = 55.2708
        var variation = 0.01 // About 1km variation
        
        latitude = baseLat + (Math.random() - 0.5) * variation
        longitude = baseLon + (Math.random() - 0.5) * variation
        altitude = 50 + Math.random() * 200
        satellites = 8 + Math.floor(Math.random() * 8)
        fixType = satellites > 6 ? "3D Fix" : "2D Fix"
        hasValidPosition = true
        lastUpdate = new Date()
        
        telemetryUpdated()
        
        console.log("Simulated telemetry:", 
                   "Lat:", latitude.toFixed(6), 
                   "Lon:", longitude.toFixed(6), 
                   "Alt:", altitude.toFixed(1),
                   "Fix:", fixType,
                   "Sats:", satellites)
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