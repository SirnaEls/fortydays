import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []

    init() { }

    func addOrUpdateTask(for category: TaskCategory, with date: Date) {
        if let index = tasks.firstIndex(where: { $0.category == category }) {
            tasks[index] = TaskModel(category: category, lastCompletionDate: date)
        } else {
            tasks.append(TaskModel(category: category, lastCompletionDate: date))
        }
    }
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    var isAllTasksCompletedForToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.allSatisfy {
            Calendar.current.isDate($0.lastCompletionDate, inSameDayAs: today)
        }
    }

    var daysUntilNextAction: Int {
        let today = Calendar.current.startOfDay(for: Date())

        if isAllTasksCompletedForToday {
            // Si tout est complété aujourd'hui, on affiche les jours restants jusqu'à 40 depuis le tout premier rituel
            guard let firstTask = tasks.sorted(by: { $0.lastCompletionDate < $1.lastCompletionDate }).first else {
                return 40
            }
            let daysSinceStart = Calendar.current.dateComponents([.day], from: firstTask.lastCompletionDate, to: today).day ?? 0
            return max(0, 40 - daysSinceStart)
        } else {
            // Sinon, on affiche le nombre de jours jusqu'au prochain rituel à faire
            let nextTask = tasks
                .filter { !Calendar.current.isDate($0.lastCompletionDate, inSameDayAs: today) }
                .sorted(by: { $0.nextDueDate < $1.nextDueDate })
                .first

            return nextTask?.daysRemainingBeforeDeadline ?? 0
        }
    }

    func loadTasksFromFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("tasks").getDocuments { snapshot, error in
            if let error = error {
                print("Erreur lors du chargement des tâches: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            let loadedTasks: [TaskModel] = documents.compactMap { doc in
                let data = doc.data()
                guard let categoryRaw = data["category"] as? String,
                      let category = TaskCategory(rawValue: categoryRaw),
                      let timestamp = data["lastCompletionDate"] as? Timestamp else {
                    return nil
                }

                return TaskModel(category: category, lastCompletionDate: timestamp.dateValue())
            }

            DispatchQueue.main.async {
                self.tasks = loadedTasks
            }
        }
    }
}
