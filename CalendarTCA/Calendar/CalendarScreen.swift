import SwiftUI
import ComposableArchitecture

struct CalendarScreen: View {

    let store: StoreOf<CalendarDomain>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color(white: 0.94).ignoresSafeArea()

                VStack(spacing: 16) {
                    CalendarHeaderView(
                        monthTitle: monthTitle(for: viewStore.selectedDate),
                        mode: viewStore.mode,
                        selectedDate: viewStore.selectedDate,
                        onModeChange: { viewStore.send(.modeChanged($0)) },
                        onToday: { viewStore.send(.todayTapped) },
                        onDateChange: { viewStore.send(.calendarDateChanged($0)) },
                        enabledCategories: viewStore.activeFilters,
                        onToggleCategory: { viewStore.send(.filterToggled($0)) }
                    )

                    if viewStore.mode == .day {
                        HStack(spacing: 0) {
                            calendarPane(viewStore)

                            Divider().padding(.horizontal, 16)

                            DayAgendaListView(
                                date: viewStore.selectedDate,
                                events: viewStore.eventsForSelectedDay
                            )
                            .frame(width: 360)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        calendarPane(viewStore)
                    }
                }
                .padding(24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(24)
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }

    private func calendarPane(_ viewStore: ViewStore<CalendarDomain.State, CalendarDomain.Action>) -> some View {
        CalendarPane(
            mode: viewStore.mode,
            selectedDate: viewStore.selectedDate,
            shouldJumpToToday: viewStore.shouldJumpToToday,
            onDidFinishJumpToToday: { viewStore.send(.didFinishJumpToToday) },
            events: viewStore.allEvents,
            enabledCategories: viewStore.activeFilters,
            selectedEvent: viewStore.selectedEvent,
            selectedEventFrame: viewStore.selectedEventFrame,
            onCalendarDateChanged: { viewStore.send(.calendarDateChanged($0)) },
            onEventSelectionChanged: { event, frame in
                viewStore.send(.eventSelectionChanged(event, frame))
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func monthTitle(for date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "LLLL yyyy"

        return df.string(from: date)
    }

}
