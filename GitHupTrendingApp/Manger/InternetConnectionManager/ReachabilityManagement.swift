//
//  ReachabilityManagement.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import Network
import UIKit

class Reachability {
    static let shared = Reachability()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")
    var isConnected: Bool = true
    
    private init() {}
    
    // Start monitoring network connectivity
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("Connected to the internet")
                    NotificationCenter.default.post(name: .internetConnected, object: nil)
                } else {
                    print("No internet connection")
                    NotificationCenter.default.post(name: .internetDisconnected, object: nil)
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    // Stop monitoring
    func stopMonitoring() {
        monitor.cancel()
    }
}

// Custom Notifications for connection status
extension Notification.Name {
    static let internetConnected = Notification.Name("internetConnected")
    static let internetDisconnected = Notification.Name("internetDisconnected")
}
