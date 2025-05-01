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
        #if DEBUG
        let filePath = Bundle.main.path(forResource: "GoogleService-Info_dev", ofType: "plist")
        #else
        let filePath = Bundle.main.path(forResource: "GoogleService-Info_prod", ofType: "plist")
        #endif

        guard let filePath = filePath else {
            fatalError("❌ Firebase config file path is nil. Check if the .plist is included in the project.")
        }
        print("📦 Using Firebase config at path: \(filePath)")

        guard let fileopts = FirebaseOptions(contentsOfFile: filePath) else {
            fatalError("❌ Couldn't load Firebase config from file.")
        }

        FirebaseApp.configure(options: fileopts)
        return true
    }
}

@main
struct fortydaysApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            AnimatedSplashView()
            .environmentObject(sessionManager) // 👈 injecte ici

        }
    }
}
