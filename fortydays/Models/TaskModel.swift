import Foundation


enum TaskCategory: String, CaseIterable, Identifiable, Codable {
    case moustache = "Moustache"
    case aisselles = "Aisselles"
    case pubis = "Pubis"
    case ongles = "Ongles"

    var id: String { rawValue }
}

struct TaskModel: Identifiable, Codable {
    let id: UUID
    let category: TaskCategory
    let lastCompletionDate: Date

    var daysSince: Int {
        DateHelper.daysBetween(start: lastCompletionDate, end: Date())
    }

    var daysLeft: Int {
        DateHelper.daysRemainingUntil40(since: lastCompletionDate)
    }

    init(id: UUID = UUID(), category: TaskCategory, lastCompletionDate: Date) {
        self.id = id
        self.category = category
        self.lastCompletionDate = lastCompletionDate
    }
}
