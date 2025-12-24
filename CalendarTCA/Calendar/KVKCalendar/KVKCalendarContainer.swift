//import SwiftUI
//import UIKit
//import EventKit
//import KVKCalendar
//
//struct KVKCalendarContainer: UIViewRepresentable {
//
//    let mode: CalendarDisplayMode
//    let selectedDate: Date
//
//    let shouldJumpToToday: Bool
//    let onDidFinishJumpToToday: () -> Void
//
//    let events: [DemoEvent]
//    let enabledCategories: Set<EventCategory>
//
//    let onCalendarDateChanged: (Date) -> Void
//    let onEventSelectionChanged: (DemoEvent?, CGRect?) -> Void
//
//    // MARK: - HostView (fixes blank Day/Week rendering)
//    final class HostView: UIView {
//
//        let calendarView: KVKCalendarView
//        private var lastSize: CGSize = .zero
//
//        init(calendarView: KVKCalendarView) {
//            self.calendarView = calendarView
//            super.init(frame: .zero)
//            backgroundColor = .clear
//            addSubview(calendarView)
//        }
//
//        required init?(coder: NSCoder) { fatalError() }
//
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            calendarView.frame = bounds
//
//            // Only reloadFrame when size changes (prevents unwanted scroll resets)
//            if bounds.size != lastSize {
//                lastSize = bounds.size
//                calendarView.reloadFrame(bounds)
//            }
//        }
//
//        func forceReloadFrameNow() {
//            lastSize = bounds.size
//            calendarView.frame = bounds
//            calendarView.reloadFrame(bounds)
//        }
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    func makeUIView(context: Context) -> HostView {
//        let type = calendarType(for: mode)
//        let style = makeStyle(defaultType: type)
//
//        let kvk = KVKCalendarView(frame: .zero, date: selectedDate, style: style)
//        kvk.delegate = context.coordinator
//        kvk.dataSource = context.coordinator
//
//        context.coordinator.calendarView = kvk
//        context.coordinator.currentType = type
//        context.coordinator.rebuildIndex(from: events)
//
//        let host = HostView(calendarView: kvk)
//
//        // Initial alignment
//        let day = Calendar.gregorianSundayFirst.startOfDay(for: selectedDate)
//        context.coordinator.lastAppliedDay = day
//        context.coordinator.isProgrammaticSync = true
//        kvk.set(type: type, date: day, animated: false)
//        kvk.reloadData()
//
//        // after first layout, ensure frame is applied (Day/Week needs this)
//        DispatchQueue.main.async {
//            host.forceReloadFrameNow()
//            context.coordinator.isProgrammaticSync = false
//        }
//
//        return host
//    }
//
//    func updateUIView(_ host: HostView, context: Context) {
//        context.coordinator.parent = self
//        context.coordinator.rebuildIndex(from: events)
//
//        let kvk = host.calendarView
//
//        let targetType = calendarType(for: mode)
//        let typeChanged = context.coordinator.currentType != targetType
//        context.coordinator.currentType = targetType
//
//        let newSignature = signature(events: events, enabled: enabledCategories)
//        let dataChanged = newSignature != context.coordinator.lastSignature
//        context.coordinator.lastSignature = newSignature
//
//        let day = Calendar.gregorianSundayFirst.startOfDay(for: selectedDate)
//        let dateChangedExternally: Bool = {
//            guard let last = context.coordinator.lastAppliedDay else { return true }
//
//            return !Calendar.gregorianSundayFirst.isDate(last, inSameDayAs: day)
//        }()
//
//        func syncKVK(animated: Bool, scrollTo: Bool) {
//            context.coordinator.isProgrammaticSync = true
//
//            kvk.updateStyle(makeStyle(defaultType: targetType))
//            kvk.set(type: targetType, date: day, animated: animated)
//            if scrollTo {
//                kvk.scrollTo(day, animated: animated)
//            }
//
//            context.coordinator.lastAppliedDay = day
//
//            // Day/Week grid often won't show without these:
//            kvk.reloadData()
//            DispatchQueue.main.async {
//                host.forceReloadFrameNow()
//                context.coordinator.isProgrammaticSync = false
//            }
//        }
//
//        // 1) Today jump (first open or Today button)
//        if shouldJumpToToday {
//            syncKVK(animated: true, scrollTo: true)
//            DispatchQueue.main.async { onDidFinishJumpToToday() }
//
//            return
//        }
//
//        // 2) Switching tabs, must redraw Day/Week grid
//        if typeChanged {
//            syncKVK(animated: false, scrollTo: false)
//
//            return
//        }
//
//        // 3) If selectedDate changed externally (not from KVK scroll), we need to sync it
//        if dateChangedExternally {
//            syncKVK(animated: false, scrollTo: false)
//
//            return
//        }
//
//        // 4) Filters changed, reload events only (avoid frame reload to preserve scroll position)
//        if dataChanged {
//            kvk.reloadData()
//        }
//    }
//
//    // MARK: - Helpers
//    private func calendarType(for mode: CalendarDisplayMode) -> CalendarType {
//        switch mode {
//        case .day: return .day
//        case .week: return .week
//        case .month: return .month
//        }
//    }
//
//    private func makeStyle(defaultType: CalendarType) -> Style {
//        var style = Style()
//
//        applyCoreConfig(to: &style, defaultType: defaultType)
//        applyHeaderConfig(to: &style)
//        applyMonthConfig(to: &style)
//        applyTimelineLayout(to: &style)
//        applyAllDayConfig(to: &style)
//        applyEventTextInsets(to: &style)
//
//        return style
//    }
//
//    private func applyCoreConfig(to style: inout Style, defaultType: CalendarType) {
//        style.calendar = Calendar.gregorianSundayFirst
//        style.startWeekDay = .sunday
//        style.timeSystem = .twentyFour
//        style.defaultType = defaultType
//
//        style.event.states = []
//        style.timeline.isEnabledCreateNewEvent = false
//    }
//
//    private func applyHeaderConfig(to style: inout Style) {
//        // We show our header.
//        style.headerScroll.isHidden = true
//        style.month.isHiddenTitleHeader = true
//    }
//
//    private func applyMonthConfig(to style: inout Style) {
//        style.month.colorWeekendDate = style.month.colorDate
//        style.month.colorBackgroundWeekendDate = style.month.colorBackgroundDate
//
//        // Scroll disabled to remove empty lines
//        // TODO: this needs further investigation
//        style.month.scrollDirection = .vertical
//        style.month.isPagingEnabled = true
//        style.month.isScrollEnabled = false
//        style.month.autoSelectionDateWhenScrolling = false
//        style.month.isHiddenSectionHeader = true
//        style.month.selectionMode = .single
//    }
//
//    private func applyTimelineLayout(to style: inout Style) {
//        // whithout this KVK calendar defaults to fixed width
//        style.timeline.widthEventViewer = nil
//
//        // Removed default paddings
//        style.timeline.offsetTimeX = 0
//        style.timeline.offsetLineLeft = 0
//        style.timeline.offsetLineRight = 0
//
//        style.timeline.widthTime = 60
//    }
//
//    private func applyAllDayConfig(to style: inout Style) {
//        style.allDay.titleText = "ALL DAY"
//        style.allDay.backgroundColor = .white
//
//        style.allDay.titleColor = .black
//        style.allDay.fontTitle = .systemFont(ofSize: 10, weight: .semibold)
//        style.allDay.titleAlignment = .left
//
//        style.allDay.offsetHeight = 5
//        style.allDay.offsetWidth = 10
//    }
//
//    private func applyEventTextInsets(to style: inout Style) {
//        style.event.textContainerInset = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
//    }
//
//    private func signature(events: [DemoEvent], enabled: Set<EventCategory>) -> Int {
//        var hasher = Hasher()
//
//        hasher.combine(events.count)
//        for event in events { hasher.combine(event.id) }
//
//        for category in enabled.sorted(by: { $0.rawValue < $1.rawValue }) {
//            hasher.combine(category.rawValue)
//        }
//
//        return hasher.finalize()
//    }
//
//    // MARK: - Coordinator
//    final class Coordinator: NSObject, CalendarDataSource, CalendarDelegate {
//
//        var parent: KVKCalendarContainer
//        weak var calendarView: KVKCalendarView?
//
//        var currentType: CalendarType?
//        var lastSignature: Int = 0
//
//        /// Ignore header callbacks when we are programmatically setting type/date
//        var isProgrammaticSync: Bool = false
//
//        /// Tracks where KVK already is (prevents snap-back on user scroll)
//        var lastAppliedDay: Date?
//
//        private var byID: [String: DemoEvent] = [:]
//
//        init(parent: KVKCalendarContainer) {
//            self.parent = parent
//        }
//
//        func rebuildIndex(from events: [DemoEvent]) {
//            byID = Dictionary(uniqueKeysWithValues: events.map { ($0.id.uuidString, $0) })
//        }
//
//        // DataSource
//        func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
//            parent.events
//                .filter { parent.enabledCategories.contains($0.category) }
//                .map { $0.toKVKEvent() }
//        }
//
//        // Delegate: date selection
//        func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
//            guard let first = dates.first else { return }
//            let day = Calendar.gregorianSundayFirst.startOfDay(for: first)
//            lastAppliedDay = day
//            DispatchQueue.main.async {
//                self.parent.onCalendarDateChanged(day)
//            }
//        }
//
//        // Delegate: visible header date (scroll paging)
//        func didDisplayHeaderTitle(_ date: Date, style: Style, type: CalendarType) {
//            guard !isProgrammaticSync, !parent.shouldJumpToToday else { return }
//            let day = Calendar.gregorianSundayFirst.startOfDay(for: date)
//            lastAppliedDay = day
//            DispatchQueue.main.async {
//                self.parent.onCalendarDateChanged(day)
//            }
//        }
//
//        // Delegate: events
//        func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
//            let demo = (event.data as? DemoEvent) ?? byID[event.ID]
//            DispatchQueue.main.async {
//                self.parent.onEventSelectionChanged(demo, frame)
//            }
//        }
//
//        func didDeselectEvent(_ event: Event, animated: Bool) {
//            DispatchQueue.main.async {
//                self.parent.onEventSelectionChanged(nil, nil)
//            }
//        }
//
//    }
//
//}
