import SwiftUI

struct CalendarHeaderMonthRow: View {

    let referenceDate: Date
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void

    private let calendar = Calendar.gregorianSundayFirst

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(8)
            }
            .buttonStyle(.plain)

            HStack(spacing: 0) {
                ForEach(weekdayLabelDates(reference: referenceDate), id: \.self) { day in
                    Text(day.formatted(.dateTime.weekday(.abbreviated)))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 6)
                }
            }

            Button(action: onNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 4)
    }

    private func weekdayLabelDates(reference: Date) -> [Date] {
        let start = calendar.startOfWeek(containing: reference) // Sunday..Saturday
        return (0..<7).map { start.addingDays($0, calendar: calendar) }
    }

}
