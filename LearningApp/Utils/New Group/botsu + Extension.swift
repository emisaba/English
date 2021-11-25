import UIKit

extension DateFormatter {
    
    static let formatter = DateFormatter()
    static func createDate() -> DateFormatter {
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}

extension Calendar {
    
    static func monthAndDate(selectedDate: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let date = selectedDate
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let monthAndDate = "\(year)-\(month)-\(day)"
        return monthAndDate
    }
}

