import SwiftUI

struct EventEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var date = Date().addingTimeInterval(24 * 60 * 60)
    @State private var selectedColorHex = Color.eventPalette[0]

    let onSave: (String, Date, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Event") {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date)
                }

                Section("Card Color") {
                    LazyVGrid(columns: [.init(.adaptive(minimum: 40))], spacing: 12) {
                        ForEach(Color.eventPalette, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 34, height: 34)
                                .overlay {
                                    if selectedColorHex == hex {
                                        Circle().stroke(.white, lineWidth: 3)
                                    }
                                }
                                .onTapGesture { selectedColorHex = hex }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title.trimmingCharacters(in: .whitespacesAndNewlines), date, selectedColorHex)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
