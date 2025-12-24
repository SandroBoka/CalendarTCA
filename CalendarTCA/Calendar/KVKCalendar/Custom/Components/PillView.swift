import UIKit

class PillView: UIView {

    private let label = UILabel()

    init(text: String, backgroundColor: UIColor, textColor: UIColor) {
        super.init(frame: .zero)

        self.backgroundColor = backgroundColor
        layer.cornerRadius = 6
        layer.masksToBounds = true

        label.text = text
        label.textColor = textColor
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail

        addSubview(label)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds.inset(by: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
    }

}
