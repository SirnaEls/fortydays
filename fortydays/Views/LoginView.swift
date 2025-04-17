//
//  SwiftUIView.swift
//  fortydays
//
//  Created by Nassir El abbassi on 16/04/2025.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var currentNonce: String?

    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary-100")
                    .opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("Logo40Days")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(.top, 16)

                        Spacer()

                    VStack(spacing: 8) {
                        
                        Text("Salam Aleykoum👋")
                            .font(.title)
                            .foregroundColor(Color("Primary-900"))

                        Text("Connecte-toi pour continuer ton rituel de bien-être.")
                            .font(.subheadline)
                            .foregroundColor(Color("Primary-750"))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 30)

                    VStack(alignment: .leading, spacing: 24) {
                        Text("Sign In")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color("Primary-900"))

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color("Primary-100"))
                            .cornerRadius(8)

                        SecureField("Mot de passe", text: $password)
                            .padding()
                            .background(Color("Primary-100"))
                            .cornerRadius(8)

                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        Button(action: login) {
                            Text("Se connecter")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Primary-500"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        SignInWithAppleButton(
                            onRequest: { request in
                                let nonce = randomNonceString()
                                currentNonce = nonce
                                request.requestedScopes = [.fullName, .email]
                                request.nonce = sha256(nonce)
                            },
                            onCompletion: { result in
                                switch result {
                                case .success(let authResults):
                                    guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                                          let identityToken = appleIDCredential.identityToken,
                                          let tokenString = String(data: identityToken, encoding: .utf8) else {
                                        print("Unable to fetch identity token")
                                        return
                                    }

                                    guard let nonce = currentNonce else {
                                        print("Invalid state: A login callback was received, but no login request was sent.")
                                        return
                                    }

                                    let credential = OAuthProvider.credential(
                                        providerID: .apple,
                                        idToken: tokenString,
                                        rawNonce: nonce
                                    )

                                    Auth.auth().signIn(with: credential) { authResult, error in
                                        if let error = error {
                                            print("Firebase sign in with Apple failed: \(error.localizedDescription)")
                                        } else {
                                            print("Firebase sign in with Apple successful: \(authResult?.user.uid ?? "")")
                                            isLoggedIn = true
                                        }
                                    }

                                case .failure(let error):
                                    print("Apple sign-in failed: \(error.localizedDescription)")
                                }
                            }
                        )
                        .frame(height: 45)
                        .signInWithAppleButtonStyle(.black)
                        .cornerRadius(8)

                        HStack {
                            Text("Pas encore de compte ?")
                                .foregroundColor(Color("Primary-900"))
                            NavigationLink(destination: RegisterView()) {
                                Text("Créer un compte")
                                    .foregroundColor(Color("Primary-750"))
                                    .bold()
                            }
                        }
                        .font(.footnote)
                        .padding(.top, 10)
                    }
                    Spacer()
                }
                .padding()
                .padding(.horizontal)
            }
        }
    }

    func login() {
        // Placeholder for Firebase login logic
    }
    
    func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms = (0..<16).map { _ in UInt8.random(in: 0...255) }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random) % charset.count])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
}

#Preview {
    LoginView()
}
