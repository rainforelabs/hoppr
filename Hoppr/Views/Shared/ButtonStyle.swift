//
//  ButtonStyle.swift
//  Hoppr
//
//  Created by Aditya Rohman on 23/04/26.
//

import SwiftUI

struct BouncyHapticButtonStyle: ButtonStyle {
  var scale: CGFloat = 0.94

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? scale : 1)
      .opacity(configuration.isPressed ? 0.80 : 1)
      .animation(
        .spring(response: 0.25, dampingFraction: 0.6),
        value: configuration.isPressed
      )
      .onChange(of: configuration.isPressed) { _, newValue in
        if newValue {
          UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
      }
  }
}

extension View {
  func bouncyHapticButtonStyle() -> some View {
    self.buttonStyle(BouncyHapticButtonStyle())
  }
}
