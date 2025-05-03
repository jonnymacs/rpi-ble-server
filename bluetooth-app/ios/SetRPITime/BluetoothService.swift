//
//  BluetoothService.swift
//  SetRPITime
//
//  Created by Jonathan McAllister on 3/3/25.
//

import CoreBluetooth

class BluetoothService: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var discoveredPeripherals: [String: CBPeripheral] = [:]
    @Published var connectedPeripheral: CBPeripheral?

    private var centralManager: CBCentralManager!
    private var targetPeripheral: CBPeripheral?
    private var targetCharacteristic: CBCharacteristic?
    
    private let deviceName = "SetRPITimeBLEServer" // Name of Raspberry Pi BLE server
    private let characteristicUUID = CBUUID(string: "00002A2B-0000-1000-8000-00805F9B34FB")
    private let serviceUUID = CBUUID(string: "00001805-0000-1000-8000-00805F9B34FB")
    
    @Published var status: String = "Ready"

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        print("Scanning for BLE devices...")
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Bluetooth is not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if discoveredPeripherals[peripheral.identifier.uuidString] == nil {
            DispatchQueue.main.async {
                self.discoveredPeripherals[peripheral.identifier.uuidString] = peripheral
            }
        }
    }

    func connectToDevice(_ peripheral: CBPeripheral) {
        centralManager.stopScan()
        targetPeripheral = peripheral
        targetPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        DispatchQueue.main.async {
            self.connectedPeripheral = peripheral
        }
        peripheral.discoverServices([serviceUUID])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            print("Failed to connect: \(error?.localizedDescription ?? "Unknown")")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                targetCharacteristic = characteristic
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            print("Disconnected from \(peripheral.name ?? "Unknown")")
            self.connectedPeripheral = nil
        }
    }

    // MARK: - Send Data
    func sendTimeAndTimezone(timezone: String) {
        guard let peripheral = targetPeripheral, let characteristic = targetCharacteristic else {
            status = "Not connected"
            print("No peripheral or characteristic")
            return
        }
        
        // Time: 8-byte timestamp + timezone
        let timestamp = Date().timeIntervalSince1970
        // Convert timestamp to 8-byte Double
        let timeData = withUnsafeBytes(of: timestamp) { Data($0) }
        
        // Convert timezone to UTF-8 bytes
        guard let timezoneData = timezone.data(using: .utf8) else {
            print("Failed to encode timezone")
            return
        }
        
        // Combine timestamp (8 bytes) and timezone
        let combinedData = timeData + timezoneData
        
        print("Sending data: \(combinedData.count) bytes, Timezone: \(timezone)")
        peripheral.writeValue(combinedData, for: characteristic, type: .withoutResponse)
    }
}
