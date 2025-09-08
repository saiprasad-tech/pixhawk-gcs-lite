#!/usr/bin/env python3
"""
Raspberry Pi Telemetry Bridge Example
Converts MAVLink telemetry to JSON for the Pixhawk GCS Lite app

This script demonstrates how to bridge telemetry data from a Pixhawk
flight controller to the mobile app via HTTP and UDP.
"""

import json
import time
import socket
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime

class TelemetryData:
    """Stores current telemetry data"""
    def __init__(self):
        self.latitude = 25.2048  # Default to Dubai
        self.longitude = 55.2708
        self.altitude = 0.0
        self.fix_type = "No Fix"
        self.satellites = 0
        self.last_update = datetime.now()
        
    def to_json(self):
        return {
            "lat": self.latitude,
            "lon": self.longitude, 
            "alt": self.altitude,
            "fix": self.fix_type,
            "sats": self.satellites,
            "timestamp": self.last_update.isoformat()
        }

# Global telemetry data
telemetry = TelemetryData()

class TelemetryHTTPHandler(BaseHTTPRequestHandler):
    """HTTP handler for telemetry requests"""
    
    def do_GET(self):
        if self.path == '/api/telemetry':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            response = json.dumps(telemetry.to_json())
            self.wfile.write(response.encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def do_POST(self):
        if self.path.startswith('/api/tracking/'):
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            
            try:
                data = json.loads(post_data.decode())
                command = data.get('command')
                
                if self.path == '/api/tracking/start':
                    print(f"Starting person tracking: {command}")
                    # Implement person tracking start logic here
                    self.send_response(200)
                elif self.path == '/api/tracking/stop':
                    print(f"Stopping person tracking: {command}")
                    # Implement person tracking stop logic here
                    self.send_response(200)
                else:
                    self.send_response(404)
                    
            except json.JSONDecodeError:
                self.send_response(400)
                
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(b'{"status": "ok"}')
        else:
            self.send_response(404)
            self.end_headers()

def udp_telemetry_sender():
    """Send telemetry data via UDP"""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    while True:
        try:
            # Send to mobile app (adjust IP as needed)
            data = json.dumps(telemetry.to_json())
            sock.sendto(data.encode(), ('192.168.1.100', 14555))
            print(f"Sent UDP telemetry: {data}")
        except Exception as e:
            print(f"UDP send error: {e}")
        
        time.sleep(1)

def mavlink_reader():
    """
    Simulate reading MAVLink telemetry data
    In a real implementation, this would connect to the flight controller
    """
    import random
    
    while True:
        # Simulate telemetry updates
        telemetry.latitude += (random.random() - 0.5) * 0.0001
        telemetry.longitude += (random.random() - 0.5) * 0.0001
        telemetry.altitude = 50 + random.random() * 200
        telemetry.satellites = 8 + random.randint(0, 8)
        telemetry.fix_type = "3D Fix" if telemetry.satellites > 6 else "2D Fix"
        telemetry.last_update = datetime.now()
        
        print(f"Updated telemetry: {telemetry.latitude:.6f}, {telemetry.longitude:.6f}")
        time.sleep(2)

def main():
    print("Starting Pixhawk GCS Lite - Pi Telemetry Bridge")
    
    # Start MAVLink reader thread
    mavlink_thread = threading.Thread(target=mavlink_reader, daemon=True)
    mavlink_thread.start()
    
    # Start UDP sender thread
    udp_thread = threading.Thread(target=udp_telemetry_sender, daemon=True)
    udp_thread.start()
    
    # Start HTTP server
    print("Starting HTTP server on port 8000...")
    httpd = HTTPServer(('0.0.0.0', 8000), TelemetryHTTPHandler)
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down...")
        httpd.shutdown()

if __name__ == "__main__":
    main()