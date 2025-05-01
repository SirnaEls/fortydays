//
//  AnimatedSplashView.swift
//  fortydays
//
//  Created by Nassir El abbassi on 22/04/2025.
//

import SwiftUI

struct AnimatedSplashView: View {
    @State private var logoVisible = false
    @State private var shouldNavigate = false

    var body: some View {
        ZStack {
            Color("Primary-100").ignoresSafeArea()

            Image("Logo40Days")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .opacity(logoVisible ? 1 : 0)
                .animation(.easeIn(duration: 1), value: logoVisible)
        }
        .onAppear {
            logoVisible = true

            // Après 2 sec, on passe à la vraie vue (ex: RootView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                shouldNavigate = true
            }
        }
        .fullScreenCover(isPresented: $shouldNavigate) {
            RootView()
        }
    }
}

#Preview {
    AnimatedSplashView()
}
