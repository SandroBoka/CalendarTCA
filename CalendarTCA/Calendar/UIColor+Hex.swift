import UIKit

extension UIColor {

    convenience init?(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard s.count == 6 else { return nil }
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        self.init(
            red: CGFloat((v >> 16) & 0xFF) / 255.0,
            green: CGFloat((v >> 8) & 0xFF) / 255.0,
            blue: CGFloat(v & 0xFF) / 255.0,
            alpha: 1
        )
    }

}
