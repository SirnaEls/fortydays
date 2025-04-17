//
//  fortydaysApp.swift
//  fortydays
//
//  Created by Nassir El abbassi on 15/04/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct fortydaysApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}
