import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var userName: String = "Utilisateur"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // App title
            Image("Logo40Days")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 70)
                .padding(.top, 10)
                .padding(.leading, 20)

            
            // User greeting
            HStack(spacing: 4) {
                Text("Salam Aleykoum")
                    .font(.system(size: 18))
                    .foregroundColor(Color("Primary-900"))
                Text(userName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("Primary-900"))
            }
            .padding(.leading, 20)
            
            // Days counter circle
            CircleProgressView(days: taskViewModel.daysUntilNextAction, maxDays: 40)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)

            if let nextTask = taskViewModel.tasks.sorted(by: { $0.lastCompletionDate < $1.lastCompletionDate }).first {
                let daysLeft = nextTask.daysRemainingBeforeDeadline
                Text(
                    daysLeft == 0 ?
                    "🚨 \(nextTask.category.displayName) est à faire aujourd’hui" :
                    "Prochain rituel à faire : \(nextTask.category.displayName) dans \(daysLeft) jour\(daysLeft > 1 ? "s" : "")"
                )
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // Cards
            List {
                if taskViewModel.tasks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("Aucun rituel pour le moment")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(taskViewModel.tasks.sorted(by: { $0.lastCompletionDate > $1.lastCompletionDate })) { task in
                        TaskCard(task: task)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: taskViewModel.deleteTask)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            
            Spacer()
        }
        .background(Color("Primary-100"))
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                currentUser.reload { _ in
                    withAnimation {
                        self.userName = currentUser.displayName ?? "Utilisateur"
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView(taskViewModel: TaskViewModel())
}
