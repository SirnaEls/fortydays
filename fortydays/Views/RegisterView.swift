//
//  RegisterView.swift
//  fortydays
//
//  Created by Nassir El abbassi on 16/04/2025.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSignedUp = false

    var body: some View {
        ZStack {
            Color("Primary-100")
                .opacity(0.4)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Créer mon compte")
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

                Button(action: register) {
                    Text("Créer mon compte")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Primary-500"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Création de compte")
        .fullScreenCover(isPresented: $isSignedUp) {
            ContentView()
        }
    }

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = nil
                isSignedUp = true
            }
        }
    }
}

#Preview {
    RegisterView()
}
