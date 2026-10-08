import SwiftUI

struct CounterRowView: View {
    @Bindable var counter: Counter

    var body: some View {
        HStack {
            Text(counter.name)
                .foregroundStyle(.primary)
                .layoutPriority(1)

            Spacer()

            Text(counter.value, format: .number)
                .monospacedDigit()
                .foregroundStyle(.secondary)
                .contentTransition(.numericText(value: Double(counter.value)))
                .fixedSize()

            Button {
                withAnimation {
                    counter.increment()
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.tint)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Increment")
            .fixedSize()
        }
        .sensoryFeedback(.impact(weight: .light), trigger: counter.value)
    }
}
