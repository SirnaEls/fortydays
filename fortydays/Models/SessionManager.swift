//
//  SessionManager.swift
//  fortydays
//
//  Created by Nassir El abbassi on 18/04/2025.
//

import Foundation
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = Auth.auth().currentUser != nil
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
        }
    }
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
