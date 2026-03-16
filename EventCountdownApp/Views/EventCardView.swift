import SwiftUI

struct EventCardView: View {
    let event: EventItem

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(event.title)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                Spacer()
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }

            CountdownTextView(date: event.date)
        }
        .padding()
        .background(Color(hex: event.colorHex).gradient)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.13), radius: 10, y: 4)
    }
}
