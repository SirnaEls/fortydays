import SwiftUI

struct ContentView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var selectedTab = 0
    @State private var isPresentingNewTask = false
    
    let userName = "Nassir"
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                DashboardView(userName: userName, taskViewModel: taskViewModel)
                    .tabItem {
                        Image(systemName: "rectangle.grid.2x2")
                        Text("Dashboard")
                    }
                    .tag(0)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profil")
                    }
                    .tag(1)
            }
            .accentColor(Color("Primary-900"))
            
            // Floating "+" button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isPresentingNewTask = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(20)
                            .background(Circle().fill(Color("Primary-750")))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .offset(y: -20)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $isPresentingNewTask) {
            NewTaskView(taskViewModel: taskViewModel) {
                isPresentingNewTask = false // callback pour fermer la sheet
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
