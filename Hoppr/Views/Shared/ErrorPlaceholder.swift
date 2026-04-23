//
//  ErrorPlaceholder.swift
//  Hoppr
//
//  Created by Aditya Rohman on 23/04/26.
//

import SwiftUI

struct ErrorPlaceholder: View {
  let message: String
  let onRetry: () -> Void
  let onBack: () -> Void

  var body: some View {
    VStack {
      Spacer()
      Image(.lifebuoy)
        .resizable()
        .frame(width: 80, height: 80)
        .padding(.bottom, 8)
      Text(message)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Button(action: onRetry) {
        Text("Try Again")
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .fontWeight(.medium)
          .foregroundStyle(.appCharcoal)
      }
      .buttonStyle(.bordered)
      Spacer()
    }
    .padding(20)
    .safeAreaBar(edge: .top) {
      HStack(spacing: 16) {
        Button(action: onBack) {
          Image(systemName: "chevron.left")
            .frame(width: 44, height: 44)
            .glassEffect(.regular.interactive())
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
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
    ErrorPlaceholder(message: "Something went wrong", onRetry: {}, onBack: {})
      .presentationDetents([.fraction(0.4), .fraction(0.7)])
      .presentationBackground(Color(.surface))
      .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.7)))
      .interactiveDismissDisabled()
  }
}
