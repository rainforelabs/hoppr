//
//  HomeView.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import MapKit
import SwiftUI

struct HomeView: View {
  @Environment(TripModel.self) private var tripModel
  @Environment(LocationModel.self) private var locationModel
  @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
  @State private var isSheetPresented = true

  var body: some View {
    ZStack(alignment: .top) {
      Map(position: $cameraPosition)
      Rectangle()
        .fill(.ultraThinMaterial)
        .frame(height: 150)
        .mask(
          LinearGradient(
            stops: [
              Gradient.Stop(color: .black, location: 0.0),
              Gradient.Stop(color: .clear, location: 0.8),
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .ignoresSafeArea()
    }
    .sheet(isPresented: $isSheetPresented) {
      HomeSheetContent(tripModel: tripModel)
    }
    .ignoresSafeArea(.keyboard)
    .onAppear {
      locationModel.getCurrentLocation()
      tripModel.fetchTrips()
    }
  }
}

private struct HomeSheetContent: View {
  let tripModel: TripModel

  var body: some View {
    ZStack {
      switch tripModel.status {
      case .generating:
        LoadingAnimation()
          .transition(.blurReplace)
      case .generated(let trip):
        TripDetailView(trip: trip) {
          tripModel.status = .idle
          tripModel.fetchTrips()
        }
        .transition(
          .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
          )
        )
      case .failure(let error):
        VStack {
          Text(error.localizedDescription)
        }
      default:
        TripListView(trips: tripModel.trips) { trip in
          tripModel.status = .generated(trip)
        }
        .transition(
          .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
          )
        )
      }
    }
    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: tripModel.status)
    .presentationDetents([.fraction(0.4), .fraction(0.7)])
    .presentationBackground(Color(.surface))
    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.7)))
    .interactiveDismissDisabled()
  }
}

#Preview {
  HomeView()
    .environment(LocationModel())
    .environment(TripModel())
    .fontDesign(.rounded)
}
