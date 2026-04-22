//
//  Stickered.swift
//  Hoppr
//
//  Created by Aditya Rohman on 22/04/26.
//

import Foundation
import SwiftUI

extension View {
  func stroke(color: some ShapeStyle, width: CGFloat = 1) -> some View {
    modifier(StrokeModifier(strokeSize: width, strokeColor: AnyShapeStyle(color)))
  }

  func stickered(color: Color = .white, width: CGFloat = 1) -> some View {
    self
      .stroke(color: color, width: width)
      .shadow(color: .gray.opacity(0.4), radius: 1, y: 1)
  }
}

struct StrokeModifier: ViewModifier {
  private let id = UUID()
  var strokeSize: CGFloat = 1
  var strokeColor: AnyShapeStyle = AnyShapeStyle(Color.white)

  func body(content: Content) -> some View {
    if strokeSize > 0 {
      appliedStrokeBackground(content: content)
    } else {
      content
    }
  }

  private func appliedStrokeBackground(content: Content) -> some View {
    content
      .padding(strokeSize)
      .background(
        Rectangle()
          .foregroundStyle(strokeColor)
          .mask(alignment: .center) {
            mask(content: content)
          }
      )
      .padding(-strokeSize)
  }

  func mask(content: Content) -> some View {
    Canvas { context, size in
      context.addFilter(.alphaThreshold(min: 0.01))
      if let resolvedView = context.resolveSymbol(id: id) {
        context.draw(resolvedView, at: .init(x: size.width / 2, y: size.height / 2))
      }
    } symbols: {
      content
        .tag(id)
        .padding(strokeSize)
        .blur(radius: strokeSize)
    }
  }
}
