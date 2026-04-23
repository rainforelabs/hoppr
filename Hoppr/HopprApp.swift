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

  var body: some Scene {
    WindowGroup {
      HomeView()
        .environment(locationModel)
        .environment(tripModel)
        .fontDesign(.rounded)
    }
  }
}
