import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var notifications = true
    @State private var userName: String = ""
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        ZStack {
            // 💡 Background global
            Color("Primary-100")
                .ignoresSafeArea() // Pour aller sous la barre de statut

            VStack(alignment: .leading, spacing: 20) {
                Text("Profil")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("Primary-900"))
                    .padding(.top, 20)
                    .padding(.leading, 20)

                Form {
                    Section(header: Text("Informations personnelles")) {
                        Text(userName)
                            
                    }.foregroundColor(Color("Primary-900"))

                    Section(header: Text("Préférences")) {
                        Toggle("Notifications", isOn: $notifications)
                            
                    }.foregroundColor(Color("Primary-900"))

                    Section {
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Text("Déconnexion")
                                .foregroundColor(.red)
                        }
                        .alert("Se déconnecter ?", isPresented: $showLogoutAlert) {
                            Button("Oui", role: .destructive) {
                                do {
                                    try Auth.auth().signOut()
                                } catch {
                                    print("Erreur lors de la déconnexion : \(error.localizedDescription)")
                                }
                            }
                            Button("Annuler", role: .cancel) { }
                        }
                    }
                    Section {
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Text("Supprimer mon compte")
                                .foregroundColor(.red)
                        }
                        .alert("Supprimer mon compte ?", isPresented: $showDeleteAlert) {
                            Button("Supprimer", role: .destructive) {
                                deleteAccount()
                            }
                            Button("Annuler", role: .cancel) { }
                        } message: {
                            Text("Cette action est irréversible.")
                        }
                    }
                }
                .scrollContentBackground(.hidden) // << cache le fond natif du Form
                .background(Color.clear)
                .onAppear {
                    if let currentUser = Auth.auth().currentUser {
                        self.userName = currentUser.displayName ?? "Utilisateur"
                    }
                }
            }
        }
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Erreur suppression : \(error.localizedDescription)")
            } else {
                // Optionally handle local logout logic if needed
                sessionManager.isLoggedIn = false
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
