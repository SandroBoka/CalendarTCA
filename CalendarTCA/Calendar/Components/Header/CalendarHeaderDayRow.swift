import SwiftUI

struct CalendarHeaderDayRow: View {

    let selectedDate: Date
    let days: [Date]
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onDayTapped: (Date) -> Void

    private let calendar = Calendar.gregorianSundayFirst

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(8)
            }
            .buttonStyle(.plain)

            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    let isSelected = calendar.isDate(day, inSameDayAs: selectedDate)
                    Button(action: { onDayTapped(day) }) {
                        HStack(spacing: 6) {
                            Text(day.formatted(.dateTime.weekday(.abbreviated)))
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)

                            Text(day.formatted(.dateTime.day()))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(isSelected ? .white : .primary)
                                .frame(width: 26, height: 26)
                                .background(
                                    Circle().fill(isSelected ? Color.blue : Color.clear)
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 6)
                    }
                    .buttonStyle(.plain)
                }
            }

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 4)
    }

}
