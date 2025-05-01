//
//  RootView.swift
//  fortydays
//
//  Created by Nassir El abbassi on 17/04/2025.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var sessionManager = SessionManager()

    var body: some View {
        Group {
            if sessionManager.isLoggedIn {
                ContentView(taskViewModel: taskViewModel)
                    .onAppear {
                        taskViewModel.loadTasksFromFirebase()
                    }
            } else {
                LoginView()
            }
        }
    }
}
