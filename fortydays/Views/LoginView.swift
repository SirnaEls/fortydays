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
    @State private var isLoading = false
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary-100")
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
                        Text("Connexion")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color("Primary-900"))

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color("Primary-250"))
                            .cornerRadius(8)
                            .accessibilityLabel("Adresse email")

                        SecureField("Mot de passe", text: $password)
                            .padding()
                            .background(Color("Primary-250"))
                            .cornerRadius(8)
                            .accessibilityLabel("Mot de passe")

                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        Button(action: login) {
                            Text("Se connecter")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((email.isEmpty || password.isEmpty) ? Color.gray.opacity(0.5) : Color("Primary-500"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(email.isEmpty || password.isEmpty)
                        
                        if isLoading {
                            ProgressView("Connexion en cours...")
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
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

                                        isLoading = true
                                        Auth.auth().signIn(with: credential) { authResult, error in
                                            isLoading = false
                                            if let error = error {
                                                print("Firebase sign in with Apple failed: \(error.localizedDescription)")
                                            } else if let user = authResult?.user {
                                                print("Firebase sign in with Apple successful: \(user.uid)")

                                                print("🧪 Apple full name received:", appleIDCredential.fullName ?? "nil")

                                                if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                                                    let fullName = appleIDCredential.fullName
                                                    let firstName = fullName?.givenName ?? ""
                                                    if !firstName.isEmpty {
                                                        let changeRequest = user.createProfileChangeRequest()
                                                        changeRequest.displayName = firstName
                                                        changeRequest.commitChanges { commitError in
                                                            if let commitError = commitError {
                                                                print("Failed to update display name: \(commitError.localizedDescription)")
                                                            } else {
                                                                print("Display name updated successfully")
                                                                user.reload { reloadError in
                                                                    if let reloadError = reloadError {
                                                                        print("Failed to reload user: \(reloadError.localizedDescription)")
                                                                    } else {
                                                                        print("User reloaded successfully.")
                                                                        sessionManager.isLoggedIn = true
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
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
                        }

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
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Veuillez remplir tous les champs."
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = "Erreur : \(error.localizedDescription)"
                print("❌ Erreur connexion :", error.localizedDescription)
            } else {
                print("✅ Connexion réussie")
            }
        }
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
