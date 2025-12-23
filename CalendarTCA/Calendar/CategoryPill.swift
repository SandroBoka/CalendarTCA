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
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.7).combined(with: .opacity),
                            removal: .opacity
                        ))
                }

                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(isOn ? style.text : .black.opacity(0.8))
            .background(isOn ? style.bg : .gray.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 999)
                    .stroke(isOn ? style.border : .black.opacity(0.8), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 999))
        }
        .buttonStyle(.plain)
    }
    
}
