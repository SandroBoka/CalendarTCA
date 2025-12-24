import UIKit
import EventKit
import KVKCalendar

class CustomMonthCell: UICollectionViewCell {

    static let reuseIdentifier = "CustomMonthCell"

    private let dayLabel = UILabel()
    private let selectionCircle = UIView()
    private var pillViews: [PillView] = []
    private let gridBorderLayer = CAShapeLayer()
    private var itemIndex: Int = 0

    private var isInCurrentMonth: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Cell border
        gridBorderLayer.fillColor = UIColor.clear.cgColor
        gridBorderLayer.strokeColor = UIColor.systemGray3.cgColor
        gridBorderLayer.lineWidth = 1
        contentView.layer.addSublayer(gridBorderLayer)
        contentView.layer.masksToBounds = true

        // Selection circle behind day label
        selectionCircle.backgroundColor = .black
        selectionCircle.isHidden = true
        contentView.addSubview(selectionCircle)

        dayLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        dayLabel.textAlignment = .right
        contentView.addSubview(dayLabel)

        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        selectionCircle.isHidden = true
        pillViews.forEach { $0.removeFromSuperview() }
        pillViews.removeAll()
        isInCurrentMonth = true
    }

    func configure(parameter: CellParameter, selectedDay: Date, item: Int) {
        itemIndex = item

        // clear old pills
        pillViews.forEach { $0.removeFromSuperview() }
        pillViews.removeAll()

        guard let date = parameter.date else {
            hideAllContent()
            isInCurrentMonth = false

            // empty cell should not be tappable
            isUserInteractionEnabled = false
            setNeedsLayout()

            return
        }

        let dayType = parameter.type ?? .empty
        switch dayType {
        case .empty:
            hideAllContent()
            isInCurrentMonth = false

            // empty cell should not be tappable
            isUserInteractionEnabled = false
            setNeedsLayout()

            return
        default:
            isInCurrentMonth = true
            isUserInteractionEnabled = true
        }

        // day number
        let day = Calendar.current.component(.day, from: date)
        dayLabel.text = "\(day)"

        // selection (black circle + white text)
        let normalized = Calendar.gregorianSundayFirst.startOfDay(for: date)
        let selected = Calendar.gregorianSundayFirst.isDate(normalized, inSameDayAs: selectedDay)

        selectionCircle.isHidden = !selected
        dayLabel.textColor = selected ? .white : .label

        // sort events by start time (earliest first), then show only first 3
        let sortedEvents = parameter.events.sorted { $0.start < $1.start }
        let eventsToShow = sortedEvents.prefix(3)

        for event in eventsToShow {
            let title = event.title.month ?? event.title.timeline
            guard !title.isEmpty else { continue }

            let demo = event.data as? DemoEvent
            let category = demo?.category

            let baseUIColor = category.map { UIColor(hex: $0.hex) ?? .systemBlue } ?? .systemBlue
            let bgAlpha: CGFloat = (category == .closures) ? 1.0 : 0.22

            let pillBG = baseUIColor.withAlphaComponent(bgAlpha)
            let pillText: UIColor = (category == .closures) ? .white : .black

            let pill = PillView(text: title, backgroundColor: pillBG, textColor: pillText)
            contentView.addSubview(pill)
            pillViews.append(pill)
        }

        setNeedsLayout()
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        let padding: CGFloat = 6
        let dateTrailingInset: CGFloat = 16

        dayLabel.frame = CGRect(
            x: padding,
            y: padding,
            width: contentView.bounds.width - padding - dateTrailingInset,
            height: 14
        )

        // Circle centered around rendered day text
        let circleSize: CGFloat = 20

        let text = dayLabel.text ?? ""
        let font = dayLabel.font ?? .systemFont(ofSize: 12, weight: .semibold)
        let textSize = (text as NSString).size(withAttributes: [.font: font])

        let textRightX = dayLabel.frame.maxX
        let textCenterX = textRightX - (textSize.width / 2)
        let textCenterY = dayLabel.frame.midY

        selectionCircle.frame = CGRect(
            x: textCenterX - circleSize / 2,
            y: textCenterY - circleSize / 2,
            width: circleSize,
            height: circleSize
        )
        selectionCircle.layer.cornerRadius = circleSize / 2

        contentView.sendSubviewToBack(selectionCircle)
        contentView.bringSubviewToFront(dayLabel)

        // pills under day label
        if isInCurrentMonth {
            var y = dayLabel.frame.maxY + 4
            let pillHeight: CGFloat = 16
            let maxWidth = contentView.bounds.width - 2 * padding

            for pill in pillViews {
                if y + pillHeight > contentView.bounds.height - padding { break }
                pill.frame = CGRect(x: padding, y: y, width: maxWidth, height: pillHeight)
                y += pillHeight + 4
            }
        }

        updateGridBorders()
    }

    private func hideAllContent() {
        dayLabel.text = nil
        selectionCircle.isHidden = true
        pillViews.forEach { $0.removeFromSuperview() }
        pillViews.removeAll()
    }

    private func updateGridBorders() {
        let b = contentView.bounds
        let path = UIBezierPath()

        let col = itemIndex % 7
        let isLastCol = (col == 6)

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: b.maxX, y: 0))

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: b.maxY))

        path.move(to: CGPoint(x: 0, y: b.maxY))
        path.addLine(to: CGPoint(x: b.maxX, y: b.maxY))

        if isLastCol {
            path.move(to: CGPoint(x: b.maxX, y: 0))
            path.addLine(to: CGPoint(x: b.maxX, y: b.maxY))
        }

        gridBorderLayer.path = path.cgPath
    }

}
