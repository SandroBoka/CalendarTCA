import UIKit
import KVKCalendar

extension DemoEvent {

    func toKVKEvent() -> Event {
        var event = Event(ID: id.uuidString)

        event.title = TextEvent(timeline: title, month: title, list: title)
        event.start = startDate
        event.end = endDate
        event.isAllDay = isAllDay

        event.color = category.kvkColor
        event.textColor = category.kvkTextColor

        // Keep a pointer back to our model so selection can recover the DemoEvent.
        event.data = self

        return event
    }

}

private extension EventCategory {

    var kvkColor: Event.Color {
        let ui = UIColor(hex: hex) ?? .systemBlue
        let alpha: CGFloat = (self == .closures) ? 1.0 : 0.22
        return Event.Color(ui, alpha: alpha)
    }

    var kvkTextColor: UIColor {
        switch self {
        case .closures: return .white
        default: return UIColor(hex: hex) ?? .label
        }
    }

}
