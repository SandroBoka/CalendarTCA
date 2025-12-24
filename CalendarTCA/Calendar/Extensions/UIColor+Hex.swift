import UIKit

extension UIColor {

    convenience init?(hex: String) {
        let s = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0

        guard Scanner(string: s).scanHexInt64(&v) else { return nil }

        switch s.count {
        case 3: // RGB (12-bit)
            self.init(
                red: CGFloat((v >> 8) & 0xF) / 15,
                green: CGFloat((v >> 4) & 0xF) / 15,
                blue: CGFloat(v & 0xF) / 15,
                alpha: 1
            )

        case 6: // RGB (24-bit)
            self.init(
                red: CGFloat((v >> 16) & 0xFF) / 255,
                green: CGFloat((v >> 8) & 0xFF) / 255,
                blue: CGFloat(v & 0xFF) / 255,
                alpha: 1
            )

        case 8: // ARGB (32-bit)
            self.init(
                red: CGFloat((v >> 16) & 0xFF) / 255,
                green: CGFloat((v >> 8) & 0xFF) / 255,
                blue: CGFloat(v & 0xFF) / 255,
                alpha: CGFloat((v >> 24) & 0xFF) / 255
            )

        default:
            return nil
        }
    }

}
