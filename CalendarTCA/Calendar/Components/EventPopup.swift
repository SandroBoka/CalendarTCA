import SwiftUI

struct EventPopup: View {

    let event: DemoEvent
    let onClose: () -> Void
    let onPrimaryAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text(event.category.rawValue)
                    .font(.headline)

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(event.category.color)
                    .frame(width: 10, height: 10)
                    .padding(.top, 4)

                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.subheadline.weight(.semibold))

                    Text(event.isAllDay ? "All day" : event.timeRangeText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    if let subtitle = event.subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if !event.people.isEmpty {
                Text(event.people.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            if let body = event.bodyText, !body.isEmpty {
                Text(body)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
            }

            if let action = event.action {
                Button(action: onPrimaryAction) {
                    HStack {
                        Spacer()
                        Text(action.title)
                            .font(.subheadline.weight(.semibold))
                        Image(systemName: action.systemImage ?? "arrow.up.right.square")
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                    }
                    .frame(height: 40)
                }
                .buttonStyle(.plain)
                .background(Color.black)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
        .padding(16)
        .frame(width: 320)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(radius: 18)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

}
