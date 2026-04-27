//
//  HopprApp.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import SwiftUI

@main
struct HopprApp: App {
  @State private var locationModel = LocationModel()
  @State private var tripModel = TripModel()
  @AppStorage("onboarding") var showOnboarding = true

  var body: some Scene {
    WindowGroup {
      if showOnboarding {
        OnboardingView {
          locationModel.getCurrentLocation()
          showOnboarding = false
        }
        .fontDesign(.rounded)
      } else {
        HomeView()
          .environment(locationModel)
          .environment(tripModel)
          .fontDesign(.rounded)
      }
    }
  }
}
