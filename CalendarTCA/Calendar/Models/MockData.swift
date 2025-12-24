import Foundation

enum MockData {

    /// Creates mock events for current week + next week (relative to `now`).
    static func makeEvents(
        now: Date = Date(),
        calendar: Calendar = .gregorianSundayFirst
    ) -> [DemoEvent] {
        let startOfWeek = calendar.startOfWeek(containing: now)           // Sunday
        let nextWeekStart = startOfWeek.addingDays(7, calendar: calendar) // next Sunday

        var events: [DemoEvent] = []

        func dayThisWeek(offset: Int) -> Date { startOfWeek.addingDays(offset, calendar: calendar) }
        func dayNextWeek(offset: Int) -> Date { nextWeekStart.addingDays(offset, calendar: calendar) }

        func allDayRange(_ startDate: Date, numberOfDays: Int = 1) -> DateRange {
            let start = calendar.startOfDay(for: startDate)
            let end = calendar.date(byAdding: .day, value: numberOfDays, to: start)!

            return DateRange(start: start, end: end)
        }

        func timedRange(
            on day: Date,
            startHour: Int,
            startMinute: Int,
            endHour: Int,
            endMinute: Int
        ) -> DateRange {
            let start = day.atTime(hour: startHour, minute: startMinute, calendar: calendar)
            let end = day.atTime(hour: endHour, minute: endMinute, calendar: calendar)

            return DateRange(start: start, end: end)
        }

        func addAllDayEvent(
            category: EventCategory,
            title: String,
            on day: Date,
            durationInDays: Int = 1,
            people: [String] = [],
            bodyText: String? = nil,
            action: DemoEventAction? = nil
        ) {
            let range = allDayRange(day, numberOfDays: durationInDays)
            events.append(
                DemoEvent(
                    category: category,
                    title: title,
                    startDate: range.start,
                    endDate: range.end,
                    isAllDay: true,
                    people: people,
                    bodyText: bodyText,
                    action: action
                )
            )
        }

        func addTimedEvent(
            category: EventCategory,
            title: String,
            subtitle: String? = nil,
            on day: Date,
            startHour: Int, startMinute: Int,
            endHour: Int, endMinute: Int,
            people: [String] = [],
            bodyText: String? = nil,
            action: DemoEventAction? = nil
        ) {
            let range = timedRange(
                on: day,
                startHour: startHour, startMinute: startMinute,
                endHour: endHour, endMinute: endMinute
            )

            events.append(
                DemoEvent(
                    category: category,
                    title: title,
                    subtitle: subtitle,
                    startDate: range.start,
                    endDate: range.end,
                    isAllDay: false,
                    people: people,
                    bodyText: bodyText,
                    action: action
                )
            )
        }

        // MARK: - Current week
        let monday = dayThisWeek(offset: 1)
        let tuesday = dayThisWeek(offset: 2)
        let wednesday = dayThisWeek(offset: 3)
        let thursday = dayThisWeek(offset: 4)
        let saturday = dayThisWeek(offset: 6)

        addAllDayEvent(
            category: .deliveries,
            title: "4 Deliveries Expected",
            on: monday,
            people: ["Frederick Cupid", "Gerald Donner", "Harry Blitzen", "Icarus Rudolph"],
            bodyText: "Tap Track Order to open a mock flow (demo just dismisses).",
            action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
        )

        addAllDayEvent(
            category: .birthdays,
            title: "1 Client Birthday",
            on: monday,
            people: ["Cal Prancer"],
            action: DemoEventAction(title: "View Details", systemImage: "arrow.up.right")
        )

        addTimedEvent(
            category: .notes,
            title: "Fitting for Adam Dasher at Dallas Studio",
            subtitle: "Adam Dasher",
            on: monday,
            startHour: 9, startMinute: 0,
            endHour: 10, endMinute: 0,
            bodyText: "Remember: client prefers musky colognes.",
            action: DemoEventAction(title: "Open Note", systemImage: "doc.text")
        )

        addTimedEvent(
            category: .jHilburn,
            title: "All Stylists Monthly Kick-Off",
            on: monday,
            startHour: 10, startMinute: 30,
            endHour: 11, endMinute: 0,
            bodyText: "Join Brand President & Director of Merchandising.",
            action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
        )

        addAllDayEvent(
            category: .deliveries,
            title: "1 Delivery",
            on: tuesday,
            people: ["Rudy Snow"],
            action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
        )

        addTimedEvent(
            category: .notes,
            title: "Follow up: measurements",
            subtitle: "Send final sizing confirmation",
            on: wednesday,
            startHour: 16, startMinute: 0,
            endHour: 16, endMinute: 30,
            bodyText: "Ask about preferred trouser break.",
            action: DemoEventAction(title: "Open Note", systemImage: "doc.text")
        )

        // All-day closure spanning Thu -> next Thu (7 days)
        addAllDayEvent(
            category: .closures,
            title: "TAL–TGM Factory Closure",
            on: thursday,
            durationInDays: 7,
            bodyText: "TAL Group – TGM closed for Holiday Closure."
        )

        addTimedEvent(
            category: .stylistEvents,
            title: "Nashville – Fall Market Meeting",
            on: thursday,
            startHour: 13, startMinute: 30,
            endHour: 14, endMinute: 30,
            action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
        )

        addAllDayEvent(
            category: .deliveries,
            title: "2 Deliveries",
            on: saturday,
            people: ["Ginger Noel", "Hope Garland"],
            action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
        )

        // MARK: - Next week
        let nextMonday = dayNextWeek(offset: 1)
        let nextTuesday = dayNextWeek(offset: 2)
        let nextWednesday = dayNextWeek(offset: 3)
        let nextThursday = dayNextWeek(offset: 4)

        addAllDayEvent(
            category: .birthdays,
            title: "2 Birthdays",
            on: nextMonday,
            people: ["Elsa North", "Jack Frost"],
            action: DemoEventAction(title: "View Details", systemImage: "arrow.up.right")
        )

        addTimedEvent(
            category: .notes,
            title: "Style board review",
            subtitle: "Prep outfits for upcoming trip",
            on: nextMonday,
            startHour: 11, startMinute: 0,
            endHour: 12, endMinute: 0,
            bodyText: "Bring 2 denim options + 1 knit jacket.",
            action: DemoEventAction(title: "Open Note", systemImage: "doc.text")
        )

        addTimedEvent(
            category: .jHilburn,
            title: "Product Training (Virtual)",
            on: nextTuesday,
            startHour: 15, startMinute: 0,
            endHour: 16, endMinute: 0,
            bodyText: "New fabric drops overview.",
            action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
        )

        addAllDayEvent(
            category: .deliveries,
            title: "3 Deliveries",
            on: nextWednesday,
            people: ["Miles Sleigh", "Nova Star", "Orion Sky"],
            action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
        )

        addTimedEvent(
            category: .stylistEvents,
            title: "In-person fittings (Austin)",
            subtitle: "Showroom",
            on: nextThursday,
            startHour: 9, startMinute: 30,
            endHour: 11, endMinute: 0,
            bodyText: "Confirm arrival time with client.",
            action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
        )

        return events
    }
    
}

struct DateRange {

    let start: Date
    let end: Date

}
