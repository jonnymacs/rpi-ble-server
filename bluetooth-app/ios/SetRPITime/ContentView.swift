//
//  ContentView.swift
//  SetRPITime
//
//  Created by Jonathan McAllister on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bleManager = BluetoothService()
    @State private var selectedTimezone: String = "UTC"
    @State private var status: String = "Ready"
    private let timezones = ["UTC", "America/New_York", "America/Los_Angeles", "Europe/London", "Asia/Tokyo"] // Expand as needed

    var body: some View {
        VStack {
            Text("SetRPITime")
                .font(.largeTitle)
                .padding()

            if let connectedPeripheral = bleManager.connectedPeripheral {
                Text("Connected to: \(connectedPeripheral.name ?? "Unknown")")
                    .foregroundColor(.green)
                    .padding()

                Picker("Timezone", selection: $selectedTimezone) {
                    ForEach(timezones, id: \.self) { timezone in
                        Text(timezone).tag(timezone)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                
                Button(action: {
                    bleManager.sendTimeAndTimezone(timezone: selectedTimezone)
                    status = "Sending..."
                }) {
                    Text("Send Time and Timezone")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Text("Scanning for Devices..")
                    .foregroundColor(.red)
                    .padding()
                
                List(Array(bleManager.discoveredPeripherals.values), id: \.identifier) { peripheral in
                    Button(action: {
                        bleManager.connectToDevice(peripheral)
                    }) {
                        Text(peripheral.name ?? "Unknown Device")
                            .font(.headline)
                    }
                }
            }

            Spacer()
        }
        .onAppear {
            bleManager.startScanning()
        }
    }
}
