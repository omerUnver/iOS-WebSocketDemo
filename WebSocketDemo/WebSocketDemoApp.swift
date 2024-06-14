//
//  WebSocketDemoApp.swift
//  WebSocketDemo
//
//  Created by M.Ömer Ünver on 13.06.2024.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestNotificationAuthorization()
        return true
    }
// Notification Permissions
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission denied: \(error)")
            }
        }
    }
}

@main
struct WebSocketDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
//            ContentView()
            BinanceMarketPriceHomePage()
        }
    }
}
