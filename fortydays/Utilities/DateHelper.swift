import Foundation

struct DateHelper {
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day ?? 0
    }
    
    static func daysRemainingUntil40(since date: Date) -> Int {
        let daysPassed = daysBetween(start: date, end: Date())
        return max(0, 40 - daysPassed)
    }
    
    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
