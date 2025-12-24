import UIKit
import KVKCalendar
import EventKit

// MARK: - Coordinator
final class Coordinator: NSObject, CalendarDataSource, CalendarDelegate {

    var parent: KVKCalendarContainer
    weak var calendarView: KVKCalendarView?

    var currentType: CalendarType?
    var lastHighlightedDay: Date?
    var lastSignature: Int = 0

    // Ignore header callbacks when we programmatically set type/date
    var isProgrammaticSync: Bool = false

    // Tracks where KVK already is (prevents snap-back on user scroll)
    var lastAppliedDay: Date?

    private var byID: [String: DemoEvent] = [:]

    init(parent: KVKCalendarContainer) {
        self.parent = parent
    }

    var selectedDay: Date {
        Calendar.gregorianSundayFirst.startOfDay(for: parent.selectedDate)
    }

    func rebuildIndex(from events: [DemoEvent]) {
        byID = Dictionary(uniqueKeysWithValues: events.map { ($0.id.uuidString, $0) })
    }

    // DataSource
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        parent.events
            .filter { parent.enabledCategories.contains($0.category) }
            .map { $0.toKVKEvent() }
    }

    func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
        guard let first = dates.first else { return }

        let day = Calendar.gregorianSundayFirst.startOfDay(for: first)
        lastAppliedDay = day

        if type == .month {
            calendarView?.reloadData()
        }

        DispatchQueue.main.async {
            self.parent.onCalendarDateChanged(day)
        }
    }

    func didDisplayHeaderTitle(_ date: Date, style: Style, type: CalendarType) {
        guard !isProgrammaticSync, !parent.shouldJumpToToday else { return }

        let day = Calendar.gregorianSundayFirst.startOfDay(for: date)
        lastAppliedDay = day

        DispatchQueue.main.async {
            self.parent.onCalendarDateChanged(day)
        }
    }

    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        let demo = (event.data as? DemoEvent) ?? byID[event.ID]

        DispatchQueue.main.async {
            self.parent.onEventSelectionChanged(demo, frame)
        }
    }

    func didDeselectEvent(_ event: Event, animated: Bool) {
        DispatchQueue.main.async {
            self.parent.onEventSelectionChanged(nil, nil)
        }
    }

    func dequeueCell<T>(
        parameter: CellParameter,
        type: CalendarType,
        view: T,
        indexPath: IndexPath
    ) -> KVKCalendarCellProtocol? where T: UIScrollView {

        guard type == .month else { return nil }
        guard let collectionView = view as? UICollectionView else { return nil }

        collectionView.register(
            CustomMonthCell.self,
            forCellWithReuseIdentifier: CustomMonthCell.reuseIdentifier
        )

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomMonthCell.reuseIdentifier,
            for: indexPath
        ) as! CustomMonthCell

        let selectedDay = Calendar.gregorianSundayFirst.startOfDay(for: parent.selectedDate)

        cell.configure(
            parameter: parameter,
            selectedDay: selectedDay,
            item: indexPath.item
        )

        return cell
    }
}
