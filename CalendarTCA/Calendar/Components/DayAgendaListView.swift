import SwiftUI

struct DayAgendaListView: View {

    let date: Date
    let events: [DemoEvent]

    private var title: String {
        date.formatted(.dateTime.weekday(.wide).month(.wide).day().year())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            if events.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.secondary)

                    Text("No events")
                        .font(.headline)

                    Text("Try enabling filters above.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(events) { event in
                            DayAgendaCard(event: event)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
    }
}

private struct DayAgendaCard: View {
    let event: DemoEvent

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(event.category.color)
                .frame(width: 10, height: 10)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(event.title)
                        .font(.system(size: 15, weight: .semibold))

                    Spacer()

                    Text(event.isAllDay ? "All day" : event.timeRangeText)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }

                if let subtitle = event.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }

                if !event.people.isEmpty {
                    Text(event.people.joined(separator: ", "))
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                if let body = event.bodyText, !body.isEmpty {
                    Text(body)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(12)
        .background(event.category.color.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(event.category.color.opacity(0.35), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

}
