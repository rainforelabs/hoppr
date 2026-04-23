//
//  LoadingAnimation.swift
//  Hoppr
//
//  Created by Aditya Rohman on 22/04/26.
//

import SwiftUI

struct LoadingAnimation: View {
  private let rows: [[String]] = [
    ["✈️", "🗺️", "🧳", "🏨"],
    ["🚂", "⛵", "🚗", "🏕️"],
    ["🗼", "🏖️", "🎡", "🌍"],
  ]

  private let rotations: [[Double]] = (0..<3).map { _ in
    (0..<4).map { _ in Double.random(in: -4...4) }
  }

  private let texts: [String] = [
    "Scanning the best spots...",
    "Checking hidden gems...",
    "Building your itinerary...",
    "Plotting the route...",
    "Almost ready...",
  ]

  @State private var currentRow = 0
  @State private var textIndex = 0
  @State private var enterOrder: [Int] = [0, 1, 2, 3]
  @State private var exitOrder: [Int] = [0, 1, 2, 3]

  var body: some View {
    VStack(spacing: 20) {
      ZStack {
        ForEach(rows.indices, id: \.self) { rowIndex in
          HStack(spacing: -8) {
            ForEach(Array(rows[rowIndex].enumerated()), id: \.offset) { emojiIndex, emoji in
              Text(emoji)
                .stickered()
                .rotationEffect(.degrees(rotations[rowIndex][emojiIndex]))
                .font(.system(size: 40))
                .opacity(rowIndex == currentRow ? 1 : 0)
                .scaleEffect(rowIndex == currentRow ? 1 : 0.6)
                .blur(radius: rowIndex == currentRow ? 0 : 10)
                .animation(
                  .spring(response: 0.35, dampingFraction: 0.85)
                    .delay(
                      rowIndex == currentRow
                        ? Double(enterOrder[emojiIndex]) * 0.1
                        : Double(exitOrder[emojiIndex]) * 0.05
                    ),
                  value: currentRow
                )
            }
          }
        }
      }

      ZStack {
        ForEach(texts.indices, id: \.self) { index in
          Text(texts[index])
            .font(.callout)
            .foregroundStyle(.secondary)
            .opacity(index == textIndex ? 1 : 0)
            .scaleEffect(index == textIndex ? 1 : 0.85)
            .blur(radius: index == textIndex ? 0 : 6)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: textIndex)
        }
      }
      .fixedSize()
    }
    .task {
      while !Task.isCancelled {
        enterOrder = (0..<rows[0].count).shuffled()
        exitOrder = (0..<rows[0].count).shuffled()
        currentRow = (currentRow + 1) % rows.count
        textIndex = (textIndex + 1) % texts.count
        try? await Task.sleep(for: .seconds(1.1))

        textIndex = (textIndex + 1) % texts.count
        try? await Task.sleep(for: .seconds(1.1))
      }
    }
  }
}

#Preview {
  ZStack {
    Color(.appGrey)
      .ignoresSafeArea()
  }
  .fontDesign(.rounded)
  .sheet(isPresented: Binding.constant(true)) {
    LoadingAnimation()
      .presentationDetents([.fraction(0.4), .fraction(0.7)])
      .presentationBackground(Color(.surface))
      .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.7)))
      .interactiveDismissDisabled()
  }
}
