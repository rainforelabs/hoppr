//
//  OnboardingView.swift
//  Hoppr
//
//  Created by Aditya Rohman on 27/04/26.
//

import SwiftUI

struct OnboardingView: View {
  let onGetStarted: () -> Void

  var body: some View {
    ZStack {
      Image(.onboardingBg)
        .resizable()
        .ignoresSafeArea()
      VStack(spacing: 20) {
        Spacer()
        Spacer()
        Image(.onboarding)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 300, height: 300)
        Spacer()

        VStack(spacing: 16) {
          Image(.appBrand)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 48)

          VStack(spacing: 8) {
            Text("Plan your next trip")
              .font(.title2)
              .fontWeight(.bold)
            Text("Personalized itinerary in seconds")
              .foregroundStyle(.secondary)
          }
        }
        .padding(20)

        Button(action: onGetStarted) {
          Text("Get Started")
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background {
              Capsule()
                .fill(
                  LinearGradient(
                    colors: [.appAsh, .appCharcoal],
                    startPoint: .top,
                    endPoint: .bottom
                  )
                )
            }
            .glassEffect(.regular.interactive())
        }
        .buttonStyle(.plain)
        .padding(20)
      }
    }
  }
}

#Preview {
  OnboardingView() {}
    .fontDesign(.rounded)
}
