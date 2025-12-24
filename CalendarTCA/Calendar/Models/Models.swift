import Foundation
import SwiftUI
import UIKit

enum CalendarDisplayMode: String, CaseIterable, Identifiable, Equatable {

    case day = "Day"
    case week = "Week"
    case month = "Month"

    var id: String { rawValue }

}

enum EventCategory: String, CaseIterable, Identifiable, Codable, Hashable {

    case jHilburn =         "J.Hilburn"
    case birthdays =        "Birthdays"
    case deliveries =       "Deliveries"
    case notes =            "Notes"
    case stylistEvents =    "Stylist Events"
    case closures =         "Closures"

    var id: String { rawValue }

    var hex: String {
        switch self {
        case .jHilburn:         "#0F78C4"
        case .birthdays:        "#C88500"
        case .deliveries:       "#009160"
        case .notes:            "#9F1D8A"
        case .stylistEvents:    "#C21E2A"
        case .closures:         "#4C4D53"
        }
    }

    var uiColor: UIColor { UIColor(hex: hex) ?? .systemBlue }
    var color: Color { Color(uiColor: uiColor) }

}

struct DemoEventAction: Equatable, Hashable {

    var title: String
    var systemImage: String? = nil

}

struct DemoEvent: Identifiable, Equatable, Hashable {

    var id: UUID = UUID()
    var category: EventCategory
    var title: String
    var subtitle: String? = nil
    var startDate: Date
    var endDate: Date
    var isAllDay: Bool = false
    var people: [String] = []
    var bodyText: String? = nil
    var action: DemoEventAction? = nil

}

extension DemoEvent {

    func intersects(day: Date, calendar: Calendar = .gregorianSundayFirst) -> Bool {
        let dayStart = calendar.startOfDay(for: day)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else { return false }

        return startDate < dayEnd && endDate > dayStart
    }

    var timeRangeText: String {
        guard !isAllDay else { return "All day" }

        let start = startDate.formatted(date: .omitted, time: .shortened)
        let end = endDate.formatted(date: .omitted, time: .shortened)

        return "\(start) – \(end)"
    }

}
