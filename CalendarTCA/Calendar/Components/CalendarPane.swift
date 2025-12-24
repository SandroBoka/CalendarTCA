import SwiftUI

struct CalendarPane: View {

    let mode: CalendarDisplayMode
    let selectedDate: Date

    let shouldJumpToToday: Bool
    let onDidFinishJumpToToday: () -> Void

    let events: [DemoEvent]
    let enabledCategories: Set<EventCategory>

    let selectedEvent: DemoEvent?
    let selectedEventFrame: CGRect?

    let onCalendarDateChanged: (Date) -> Void
    let onEventSelectionChanged: (DemoEvent?, CGRect?) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {

                KVKCalendarContainer(
                    mode: mode,
                    selectedDate: selectedDate,
                    shouldJumpToToday: shouldJumpToToday,
                    onDidFinishJumpToToday: onDidFinishJumpToToday,
                    events: events,
                    enabledCategories: enabledCategories,
                    onCalendarDateChanged: onCalendarDateChanged,
                    onEventSelectionChanged: onEventSelectionChanged
                )
                .id(mode) // ✅ force correct type init per tab
                .frame(width: geo.size.width, height: geo.size.height)

                if selectedEvent != nil {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture { onEventSelectionChanged(nil, nil) }
                        .zIndex(10)
                }

                if let event = selectedEvent, let frame = selectedEventFrame {
                    EventPopup(
                        event: event,
                        onClose: { onEventSelectionChanged(nil, nil) },
                        onPrimaryAction: { onEventSelectionChanged(nil, nil) }
                    )
                    .position(popupPosition(for: frame, containerSize: geo.size))
                    .zIndex(20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func popupPosition(for eventFrame: CGRect, containerSize: CGSize) -> CGPoint {
        let popupW: CGFloat = 320
        let popupH: CGFloat = 260
        let margin: CGFloat = 12

        var x = eventFrame.maxX + margin + popupW / 2
        if x + popupW / 2 > containerSize.width - margin {
            x = eventFrame.minX - margin - popupW / 2
        }
        x = max(margin + popupW / 2, min(x, containerSize.width - margin - popupW / 2))

        var y = eventFrame.midY
        y = max(margin + popupH / 2, min(y, containerSize.height - margin - popupH / 2))

        return CGPoint(x: x, y: y)
    }

}
