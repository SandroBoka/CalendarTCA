import SwiftUI

struct CalendarHeaderView: View {

    let monthTitle: String

    let mode: CalendarDisplayMode
    let selectedDate: Date
    let onModeChange: (CalendarDisplayMode) -> Void

    let onToday: () -> Void
    let onDateChange: (Date) -> Void

    let enabledCategories: Set<EventCategory>
    let onToggleCategory: (EventCategory) -> Void

    private let calendar = Calendar.gregorianSundayFirst

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Calendar")
                        .font(.system(size: 26, weight: .bold))

                    Text(monthTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Picker("", selection: Binding(
                    get: { mode },
                    set: { onModeChange($0) }
                )) {
                    ForEach(CalendarDisplayMode.allCases) { m in
                        Text(m.rawValue).tag(m)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 240)

                Spacer()

                Button("Today", action: onToday)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(uiColor: .systemBlue))
                    .padding(.leading, 12)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(EventCategory.allCases) { category in
                        CategoryPill(
                            title: category.rawValue,
                            isOn: enabledCategories.contains(category),
                            style: pillStyle(for: category)
                        ) {
                            onToggleCategory(category)
                        }
                    }
                }
                .padding(.vertical, 2)
            }

            if mode == .day || mode == .week {
                CalendarHeaderDayRow(
                    selectedDate: selectedDate,
                    days: weekDays(for: selectedDate),
                    onPrevious: { onDateChange(selectedDate.addingDays(-chevronDayCount, calendar: calendar)) },
                    onNext: { onDateChange(selectedDate.addingDays(chevronDayCount, calendar: calendar)) },
                    onDayTapped: { onDateChange($0) }
                )
            } else if mode == .month {
                CalendarHeaderMonthRow(
                    referenceDate: selectedDate,
                    onPreviousMonth: { onDateChange(previousMonthAnchor(from: selectedDate)) },
                    onNextMonth: { onDateChange(nextMonthAnchor(from: selectedDate)) }
                )
            }
        }
        .padding(16)
        .background(Color(white: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func weekDays(for date: Date) -> [Date] {
        let start = calendar.startOfWeek(containing: date)
        return (0..<7).map { start.addingDays($0, calendar: calendar) }
    }

    private func previousMonthAnchor(from date: Date) -> Date {
        let prev = calendar.date(byAdding: .month, value: -1, to: date) ?? date
        return firstDayOfMonth(for: prev)
    }

    private func nextMonthAnchor(from date: Date) -> Date {
        let next = calendar.date(byAdding: .month, value: 1, to: date) ?? date
        return firstDayOfMonth(for: next)
    }

    private func firstDayOfMonth(for date: Date) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps).map { calendar.startOfDay(for: $0) } ?? date
    }

    private var chevronDayCount: Int {
        switch mode {
        case .day:
            1
        case .week:
            7
        case .month:
            0
        }
    }

    private func pillStyle(for category: EventCategory) -> CategoryPill.Style {
        switch category {
        case .jHilburn:
            return .init(bg: Color(hex: "#E6F1F9"), border: Color(hex: "#0F78C4"), text: Color(hex: "#0F78C4"))
        case .birthdays:
            return .init(bg: Color(hex: "#F9F0CF"), border: Color(hex: "#C88500"), text: Color(hex: "#C88500"))
        case .deliveries:
            return .init(bg: Color(hex: "#D3F0E0"), border: Color(hex: "#009160"), text: Color(hex: "#009160"))
        case .notes:
            return .init(bg: Color(hex: "#F5E8F3"), border: Color(hex: "#9F1D8A"), text: Color(hex: "#9F1D8A"))
        case .stylistEvents:
            return .init(bg: Color(hex: "#FAD6D8"), border: Color(hex: "#C21E2A"), text: Color(hex: "#C21E2A"))
        case .closures:
            return .init(bg: Color(hex: "#4C4D53"), border: .white, text: .white)
        }
    }
    
}

private extension Color {
    init(hex: String) {
        if let ui = UIColor(hex: hex) {
            self.init(uiColor: ui)
        } else {
            self = .gray
        }
    }
}
