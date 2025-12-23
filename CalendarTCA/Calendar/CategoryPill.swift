import SwiftUI

struct CategoryPill: View {

    struct Style {
        let bg: Color
        let border: Color
        let text: Color
    }

    let title: String
    let isOn: Bool
    let style: Style
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark")
                    .font(.system(size: 13, weight: .bold))
                    .opacity(isOn ? 1 : 0)

                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(style.text)
            .background(style.bg)
            .overlay(
                RoundedRectangle(cornerRadius: 999)
                    .stroke(style.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 999))
        }
        .buttonStyle(.plain)
    }
    
}
