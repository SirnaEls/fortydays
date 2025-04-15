import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []

    init() {
        loadInitialCategories()
    }

    private func loadInitialCategories() {
        let defaultCategories: [TaskCategory] = [.moustache, .aisselles, .pubis, .ongles]

        for category in defaultCategories {
            // Vérifie qu'on n'a pas déjà cette catégorie
            if !tasks.contains(where: { $0.category == category }) {
                let task = TaskModel(category: category, lastCompletionDate: Date())
                tasks.append(task)
            }
        }
    }

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
}
