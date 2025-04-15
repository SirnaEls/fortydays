import SwiftUI

struct DashboardView: View {
    let userName: String
    @ObservedObject var taskViewModel: TaskViewModel

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
            HStack(spacing: 12) {
                Image("userAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                (
                    Text("Salam Aleykoum ")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    +
                    Text(userName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("Primary-900"))
                )
            }
            .padding(.leading, 20)
            
            // Days counter circle
            CircleProgressView(days: 32, maxDays: 40)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            
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
                    ForEach(taskViewModel.tasks) { task in
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
        .background(Color("Primary-100").opacity(0.4))
    }
}

#Preview {
    DashboardView(
        userName: "Nassir",
        taskViewModel: TaskViewModel()
    )
}
