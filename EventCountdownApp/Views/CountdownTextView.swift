import SwiftUI

struct CountdownTextView: View {
    let date: Date

    private var components: DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute], from: Date(), to: date)
    }

    var body: some View {
        HStack(spacing: 14) {
            valueBlock(value: components.day ?? 0, label: "DAYS")
            valueBlock(value: components.hour ?? 0, label: "HRS")
            valueBlock(value: components.minute ?? 0, label: "MIN")
        }
    }

    private func valueBlock(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(max(value, 0))")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}
