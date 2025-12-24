import Foundation

extension Calendar {
    
    static var gregorianSundayFirst: Calendar {
        var calendar = Calendar(identifier: .gregorian)

        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        calendar.firstWeekday = 1 // Sunday

        return calendar
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
