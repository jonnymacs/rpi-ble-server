# SetRPITime - iOS Bluetooth App

This iOS application connects to a Raspberry Pi running a Bluetooth Low Energy (BLE) server and synchronizes the time and timezone settings.

## Project Structure

- **ios/**: Contains the iOS application code.
  - **SetRPITime/**: Main iOS application folder.
    - `BluetoothService.swift`: Manages Bluetooth connections, device discovery, and sending time data.
    - `ContentView.swift`: SwiftUI interface that displays the connection status and timezone options.
    - `SetRPITimeApp.swift`: Main entry point for the SwiftUI application.
    - **Assets.xcassets/**: Contains app icons and other image assets.
    - **Preview Content/**: Contains preview assets for SwiftUI.
  - **SetRPITime.xcodeproj/**: Xcode project configuration files.

## Features

- Scan for BLE devices advertising the time service (UUID: 00001805-0000-1000-8000-00805F9B34FB)
- Connect to the Raspberry Pi BLE server
- Select from a list of common timezones
- Send current time and selected timezone to the Raspberry Pi

## Setup Instructions

### iOS

1. Open the `ios/SetRPITime.xcodeproj` in Xcode.
2. Select your iOS device as the build target.
3. Build and run the app on your iOS device.

**Note**: The app requires a physical iOS device with Bluetooth capabilities as the iOS Simulator does not support Bluetooth.

## Usage

1. Launch the app on your iOS device.
2. Ensure Bluetooth is enabled on your device.
3. The app will automatically scan for compatible BLE devices.
4. Select your Raspberry Pi from the list of discovered devices.
5. Once connected, choose the desired timezone from the dropdown menu.
6. Tap "Send Time and Timezone" to synchronize the time.

## Requirements

- iOS 14.0 or later
- Xcode 12.0 or later
- A Raspberry Pi running the BLE server application

## Technical Details

The app communicates with the BLE server using the following:
- Service UUID: 00001805-0000-1000-8000-00805F9B34FB (Current Time Service)
- Characteristic UUID: 00002A2B-0000-1000-8000-00805F9B34FB (Current Time)

Time data is sent as an 8-byte timestamp (seconds since 1970) followed by the timezone string in UTF-8 format.

## Contributing

Feel free to submit issues or pull requests for improvements and bug fixes.