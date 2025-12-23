import Foundation

extension Calendar {
    
    static var gregorianSundayFirst: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale.current
        cal.timeZone = TimeZone.current
        cal.firstWeekday = 1 // Sunday
        return cal
    }
    
    func startOfWeek(containing date: Date) -> Date {
        let startOfDay = startOfDay(for: date)
        let weekday = component(.weekday, from: startOfDay) // 1 = Sunday
        let daysToSubtract = (weekday - firstWeekday + 7) % 7
        return self.date(byAdding: .day, value: -daysToSubtract, to: startOfDay) ?? startOfDay
    }

}

extension Date {

    func addingDays(_ days: Int, calendar: Calendar = .gregorianSundayFirst) -> Date {
        calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func atTime(hour: Int, minute: Int, calendar: Calendar = .gregorianSundayFirst) -> Date {
        calendar.date(bySettingHour: hour, minute: minute, second: 0, of: self) ?? self
    }

}
