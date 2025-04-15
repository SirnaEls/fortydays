import SwiftUI

struct ProfileView: View {
    @State private var notifications = true
    @State private var userName = "Nassir"

    var body: some View {
        ZStack {
            // 💡 Background global
            Color("Primary-100").opacity(0.4)
                .ignoresSafeArea() // Pour aller sous la barre de statut

            VStack(alignment: .leading, spacing: 20) {
                Text("Profil")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("Primary-900"))
                    .padding(.top, 20)
                    .padding(.leading, 20)

                Form {
                    Section(header: Text("Informations personnelles")) {
                        TextField("Nom d'utilisateur", text: $userName)
                    }

                    Section(header: Text("Préférences")) {
                        Toggle("Notifications", isOn: $notifications)
                    }

                    Section {
                        Button(action: {
                            // Action de déconnexion
                        }) {
                            Text("Déconnexion")
                                .foregroundColor(.red)
                        }
                    }
                }
                .scrollContentBackground(.hidden) // << cache le fond natif du Form
                .background(Color.clear)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
