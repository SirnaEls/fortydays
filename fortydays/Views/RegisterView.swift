//
//  RegisterView.swift
//  fortydays
//
//  Created by Nassir El abbassi on 16/04/2025.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSignedUp = false

    var body: some View {
        ZStack {
            Color("Primary-100")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Créer mon compte")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("Primary-900"))

                TextField("Prénom", text: $name)
                    .padding()
                    .background(Color("Primary-250"))
                    .cornerRadius(8)
                    .accessibilityLabel("Prénom")

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

                Button(action: register) {
                    Text("Créer mon compte")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background((email.isEmpty || password.isEmpty || name.isEmpty) ? Color.gray.opacity(0.5) : Color("Primary-500"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(email.isEmpty || password.isEmpty || name.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Création de compte")
        .fullScreenCover(isPresented: $isSignedUp) {
            ContentView(taskViewModel: TaskViewModel())
        }
    }

    func register() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            self.errorMessage = "Veuillez remplir tous les champs."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "Erreur : \(error.localizedDescription)"
            } else if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { _ in
                    errorMessage = nil
                    isSignedUp = true
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
