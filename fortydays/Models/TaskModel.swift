import Foundation

enum TaskCategory: String, CaseIterable, Identifiable, Codable {
    case moustache = "Moustache"
    case aisselles = "Aisselles"
    case pubis = "Pubis"
    case ongles = "Ongles"

    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .moustache: return "Moustache"
        case .aisselles: return "Aisselles"
        case .pubis: return "Pubis"
        case .ongles: return "Ongles"
        }
    }
}

struct TaskModel: Identifiable, Codable {
    let id: UUID
    let category: TaskCategory
    let lastCompletionDate: Date

    var daysSinceLastCompletion: Int {
        DateHelper.daysBetween(start: lastCompletionDate, end: Date())
    }

    var daysRemainingBeforeDeadline: Int {
        max(0, 40 - daysSinceLastCompletion)
    }

    var nextDueDate: Date {
        Calendar.current.date(byAdding: .day, value: 40, to: lastCompletionDate) ?? Date()
    }

    init(id: UUID = UUID(), category: TaskCategory, lastCompletionDate: Date) {
        self.id = id
        self.category = category
        self.lastCompletionDate = lastCompletionDate
    }
}
