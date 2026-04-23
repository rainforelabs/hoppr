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

private enum ContentState {
  case list, generating
  case detail(Trip)
  case failure(Error)
}

extension ContentState: Equatable {
  static func == (lhs: ContentState, rhs: ContentState) -> Bool {
    switch (lhs, rhs) {
    case (.list, .list), (.generating, .generating), (.failure, .failure): return true
    case (.detail(let a), .detail(let b)): return a.id == b.id
    default: return false
    }
  }
}

private struct HomeSheetContent: View {
  let tripModel: TripModel

  private var contentState: ContentState {
    switch tripModel.status {
    case .generating: return .generating
    case .generated(let trip): return .detail(trip)
    case .failure(let error): return .failure(error)
    default: return .list
    }
  }

  private var generationSucceeded: Bool {
    if case .detail = contentState { return true }
    return false
  }

  var body: some View {
    ZStack {
      switch contentState {
      case .generating:
        LoadingAnimation()
          .transition(
            .asymmetric(
              insertion: .move(edge: .trailing).combined(with: .opacity),
              removal: .move(edge: .trailing).combined(with: .opacity)
            )
          )
      case .detail(let trip):
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
        ErrorPlaceholder(message: error.localizedDescription) {
          tripModel.generateTrip()
        } onBack: {
          tripModel.status = .idle
          tripModel.fetchTrips()
        }
        .transition(
          .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
          )
        )
      default:
        TripListView(
          trips: tripModel.trips,
          isLoading: tripModel.status == .fetching
        ) { trip in
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
    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: contentState)
    .sensoryFeedback(.success, trigger: generationSucceeded)
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
