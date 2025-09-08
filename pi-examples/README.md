# Raspberry Pi Integration Examples

This directory contains example Python scripts demonstrating the Pi-side implementation for the Pixhawk GCS Lite mobile app.

## Files

### telemetry_bridge.py
- Bridges MAVLink telemetry to JSON format
- Provides HTTP API endpoint for telemetry polling
- Sends telemetry via UDP for real-time updates
- Handles person tracking commands from mobile app

### ble_provisioning.py
- BLE GATT server for Wi-Fi provisioning
- Receives Wi-Fi credentials from mobile app
- Handles person tracking start/stop commands
- Configures Pi networking automatically

## Usage

1. Install dependencies:
```bash
pip install bleak asyncio
```

2. Run telemetry bridge:
```bash
sudo python3 telemetry_bridge.py
```

3. Run BLE provisioning server:
```bash
sudo python3 ble_provisioning.py
```

## Integration Notes

- Modify scripts for your specific flight controller connection
- Adjust networking interfaces as needed
- Implement actual person tracking algorithms
- Add proper error handling and logging

## Camera Streaming

For camera streaming, use a separate service like:
```bash
# Using mjpg-streamer
mjpg_streamer -i "input_raspicam.so" -o "output_http.so -p 8080"
```

The mobile app will connect to `http://pi:8080/stream.mjpeg` for live video.