import Foundation

enum MockData {
    /// Creates mock events for current week + next week (relative to `now`).
    static func makeEvents(now: Date = Date(), calendar: Calendar = .gregorianSundayFirst) -> [DemoEvent] {
        let startOfWeek = calendar.startOfWeek(containing: now)           // Sunday
        let nextWeekStart = startOfWeek.addingDays(7, calendar: calendar) // next Sunday

        func day(_ offset: Int) -> Date { startOfWeek.addingDays(offset, calendar: calendar) }
        func day2(_ offset: Int) -> Date { nextWeekStart.addingDays(offset, calendar: calendar) }

        func allDay(_ start: Date, days: Int = 1) -> (start: Date, end: Date) {
            let s = calendar.startOfDay(for: start)
            let e = calendar.date(byAdding: .day, value: days, to: s)!
            return (s, e)
        }

        func timed(_ day: Date, _ sh: Int, _ sm: Int, _ eh: Int, _ em: Int) -> (start: Date, end: Date) {
            let s = day.atTime(hour: sh, minute: sm, calendar: calendar)
            let e = day.atTime(hour: eh, minute: em, calendar: calendar)
            return (s, e)
        }

        var events: [DemoEvent] = []

        // -------- Current week --------
        let mon = day(1)
        let tue = day(2)
        let wed = day(3)
        let thu = day(4)
        let sat = day(6)

        // Monday: deliveries + birthday (all day)
        do {
            let r = allDay(mon)
            events.append(
                DemoEvent(
                    category: .deliveries,
                    title: "4 Deliveries Expected",
                    startDate: r.start,
                    endDate: r.end,
                    isAllDay: true,
                    people: ["Frederick Cupid", "Gerald Donner", "Harry Blitzen", "Icarus Rudolph"],
                    bodyText: "Tap Track Order to open a mock flow (demo just dismisses).",
                    action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
                )
            )
        }
        do {
            let r = allDay(mon)
            events.append(
                DemoEvent(
                    category: .birthdays,
                    title: "1 Client Birthday",
                    startDate: r.start,
                    endDate: r.end,
                    isAllDay: true,
                    people: ["Cal Prancer"],
                    action: DemoEventAction(title: "View Details", systemImage: "arrow.up.right")
                )
            )
        }

        // Monday: note + J.Hilburn timed events
        do {
            let r = timed(mon, 9, 0, 10, 0)
            events.append(
                DemoEvent(
                    category: .notes,
                    title: "Fitting for Adam Dasher at Dallas Studio",
                    subtitle: "Adam Dasher",
                    startDate: r.start,
                    endDate: r.end,
                    bodyText: "Remember: client prefers musky colognes.",
                    action: DemoEventAction(title: "Open Note", systemImage: "doc.text")
                )
            )
        }
        do {
            let r = timed(mon, 10, 30, 11, 0)
            events.append(
                DemoEvent(
                    category: .jHilburn,
                    title: "All Stylists Monthly Kick‑Off",
                    startDate: r.start,
                    endDate: r.end,
                    bodyText: "Join Brand President & Director of Merchandising.",
                    action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
                )
            )
        }

        // Tuesday: one delivery all day
        do {
            let r = allDay(tue)
            events.append(
                DemoEvent(
                    category: .deliveries,
                    title: "1 Delivery",
                    startDate: r.start,
                    endDate: r.end,
                    isAllDay: true,
                    people: ["Rudy Snow"],
                    action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
                )
            )
        }

        // Wednesday: note
        do {
            let r = timed(wed, 16, 0, 16, 30)
            events.append(
                DemoEvent(
                    category: .notes,
                    title: "Follow up: measurements",
                    subtitle: "Send final sizing confirmation",
                    startDate: r.start,
                    endDate: r.end,
                    bodyText: "Ask about preferred trouser break.",
                    action: DemoEventAction(title: "Open Note", systemImage: "doc.text")
                )
            )
        }

        // Thursday: closure spanning into next week (all day)
        do {
            let start = calendar.startOfDay(for: thu)
            let end = calendar.date(byAdding: .day, value: 7, to: start)! // Thu -> next Thu (displayed end-1 day)
            events.append(
                DemoEvent(
                    category: .closures,
                    title: "TAL–TGM Factory Closure",
                    startDate: start,
                    endDate: end,
                    isAllDay: true,
                    bodyText: "TAL Group – TGM closed for Holiday Closure."
                )
            )
        }

        // Thursday: stylist event
        do {
            let r = timed(thu, 13, 30, 14, 30)
            events.append(
                DemoEvent(
                    category: .stylistEvents,
                    title: "Nashville – Fall Market Meeting",
                    startDate: r.start,
                    endDate: r.end,
                    action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
                )
            )
        }

        // Saturday: two deliveries all day
        do {
            let r = allDay(sat)
            events.append(
                DemoEvent(
                    category: .deliveries,
                    title: "2 Deliveries",
                    startDate: r.start,
                    endDate: r.end,
                    isAllDay: true,
                    people: ["Ginger Noel", "Hope Garland"],
                    action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
                )
            )
        }

        // -------- Next week --------
        let mon2 = day2(1)
        let tue2 = day2(2)
        let wed2 = day2(3)
        let thu2 = day2(4)

        // Monday next week: birthdays + note
        do {
            let r = allDay(mon2)
            events.append(
                DemoEvent(
                    category: .birthdays,
                    title: "2 Birthdays",
                    startDate: r.start,
                    endDate: r.end,
                    isAllDay: true,
                    people: ["Elsa North", "Jack Frost"],
                    action: DemoEventAction(title: "View Details", systemImage: "arrow.up.right")
                )
            )
        }
        do {
            let r = timed(mon2, 11, 0, 12, 0)
            events.append(
                DemoEvent(
                    category: .notes,
                    title: "Style board review",
                    subtitle: "Prep outfits for upcoming trip",
                    startDate: r.start,
                    endDate: r.end,
                    bodyText: "Bring 2 denim options + 1 knit jacket.",
                    action: DemoEventAction(title: "Open Note", systemImage: "doc.text")
                )
            )
        }

        // Tuesday next week: J.Hilburn training
        do {
            let r = timed(tue2, 15, 0, 16, 0)
            events.append(
                DemoEvent(
                    category: .jHilburn,
                    title: "Product Training (Virtual)",
                    startDate: r.start,
                    endDate: r.end,
                    bodyText: "New fabric drops overview.",
                    action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
                )
            )
        }

        // Wednesday next week: deliveries
        do {
            let r = allDay(wed2)
            events.append(
                DemoEvent(
                    category: .deliveries,
                    title: "3 Deliveries",
                    startDate: r.start,
                    endDate: r.end,
                    isAllDay: true,
                    people: ["Miles Sleigh", "Nova Star", "Orion Sky"],
                    action: DemoEventAction(title: "Track Order", systemImage: "cube.box")
                )
            )
        }

        // Thursday next week: stylist fittings
        do {
            let r = timed(thu2, 9, 30, 11, 0)
            events.append(
                DemoEvent(
                    category: .stylistEvents,
                    title: "In‑person fittings (Austin)",
                    subtitle: "Showroom",
                    startDate: r.start,
                    endDate: r.end,
                    bodyText: "Confirm arrival time with client.",
                    action: DemoEventAction(title: "Register", systemImage: "arrow.up.right.square")
                )
            )
        }

        return events
    }
}
