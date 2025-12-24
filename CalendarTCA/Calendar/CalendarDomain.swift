import Foundation
import ComposableArchitecture

struct CalendarDomain: Reducer {

    struct State: Equatable {
        var mode: CalendarDisplayMode = .week

        var selectedDate: Date = Calendar.gregorianSundayFirst.startOfDay(for: Date())

        var activeFilters: Set<EventCategory> = Set(EventCategory.allCases)
        var allEvents: [DemoEvent] = []

        var selectedEvent: DemoEvent?
        var selectedEventFrame: CGRect?

        var shouldJumpToToday: Bool = false

        var filteredEvents: [DemoEvent] {
            allEvents.filter { activeFilters.contains($0.category) }
        }

        var eventsForSelectedDay: [DemoEvent] {
            filteredEvents
                .filter { $0.intersects(day: selectedDate, calendar: .gregorianSundayFirst) }
                .sorted { lhs, rhs in
                    if lhs.isAllDay != rhs.isAllDay { return lhs.isAllDay && !rhs.isAllDay }
                    return lhs.startDate < rhs.startDate
                }
        }
    }

    enum Action: Equatable {

        case onAppear
        case modeChanged(CalendarDisplayMode)

        case todayTapped
        case didFinishJumpToToday

        case calendarDateChanged(Date)

        case filterToggled(EventCategory)
        case eventSelectionChanged(DemoEvent?, CGRect?)

    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            let today = Calendar.gregorianSundayFirst.startOfDay(for: Date())
            state.selectedDate = today
            state.allEvents = MockData.makeEvents(now: today)
            state.activeFilters = Set(EventCategory.allCases)
            state.selectedEvent = nil
            state.selectedEventFrame = nil
            state.shouldJumpToToday = true

            return .none
        case let .modeChanged(mode):
            state.mode = mode
            state.selectedEvent = nil
            state.selectedEventFrame = nil

            return .none
        case .todayTapped:
            let today = Calendar.gregorianSundayFirst.startOfDay(for: Date())
            state.selectedDate = today
            state.selectedEvent = nil
            state.selectedEventFrame = nil
            state.shouldJumpToToday = true

            return .none
        case .didFinishJumpToToday:
            state.shouldJumpToToday = false

            return .none
        case let .calendarDateChanged(date):
            let day = Calendar.gregorianSundayFirst.startOfDay(for: date)
            state.selectedDate = day
            state.selectedEvent = nil
            state.selectedEventFrame = nil

            return .none
        case let .filterToggled(category):
            if state.activeFilters.contains(category) {
                state.activeFilters.remove(category)
            } else {
                state.activeFilters.insert(category)
            }

            if let selected = state.selectedEvent,
               !state.activeFilters.contains(selected.category) {
                state.selectedEvent = nil
                state.selectedEventFrame = nil
            }

            return .none
        case let .eventSelectionChanged(event, frame):
            state.selectedEvent = event
            state.selectedEventFrame = frame

            return .none
        }
    }

}
