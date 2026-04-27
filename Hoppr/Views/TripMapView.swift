//
//  TripMapView.swift
//  Hoppr
//
//  Created by Aditya Rohman on 26/04/26.
//

import CoreLocation
import MapKit
import SwiftUI

struct TripMapView: View {
  let trip: Trip
  let selectedDay: Int

  private let mapService = MapService()

  @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
  @State private var isLoading: Bool = false
  @State private var mapData: [MapData] = []
  @State private var dayItems: [MKMapItem] = []
  @State private var dayRoutes: [MKRoute] = []
  @State private var selectedItem: MKMapItem?
  @State private var lookAroundScene: MKLookAroundScene?

  var body: some View {
    ZStack {
      Map(position: $cameraPosition, selection: $selectedItem) {
        ForEach(dayItems, id: \.self) { item in
          let idx = dayItems.firstIndex(of: item) ?? 0
          let activity = trip.itinerary[selectedDay].activities[idx]

          Marker(
            activity.name,
            systemImage: activity.category.icon,
            coordinate: item.location.coordinate
          )
          .mapItemDetailSelectionAccessory(.callout)
          .tint(activity.category.color)
        }
        ForEach(dayRoutes, id: \.self) { item in
          MapPolyline(item)
            .stroke(
              Color.orange,
              style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
            )
        }
      }
      .contentMargins(.horizontal, 20)
      .overlay(alignment: .bottomLeading) {
        if lookAroundScene != nil {
          LookAroundPreview(scene: $lookAroundScene)
            .frame(width: 230, height: 140)
            .cornerRadius(16)
            .padding(8)
        }
      }

      if isLoading {
        ZStack {
          Rectangle()
            .fill(.ultraThickMaterial)
            .ignoresSafeArea()
          MapLoadingIndicator()
        }
        .transition(.blurReplace)
      }
    }
    .onChange(of: selectedItem) { loadLookAroundScene() }
    .onChange(of: selectedDay) {
      dayItems = mapData[selectedDay].items
      dayRoutes = mapData[selectedDay].routes

      withAnimation(.easeInOut(duration: 0.5)) { centerRoute() }
    }
    .task { await loadMapData() }
  }

  private func loadMapData() async {
    dayItems = []
    dayRoutes = []
    isLoading = true

    mapData = await mapService.buildMapData(for: trip)
    dayItems = mapData[selectedDay].items
    dayRoutes = mapData[selectedDay].routes
    isLoading = false

    withAnimation(.easeInOut(duration: 0.5)) { centerRoute() }
  }

  private func centerRoute() {
    guard dayItems.count > 1 else {
      if let firstCoord = dayItems.first {
        cameraPosition =
          .region(
            MKCoordinateRegion(
              center: firstCoord.location.coordinate,
              span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
          )
      }
      return
    }

    var mutableCoords = dayItems.map(\.location.coordinate)
    let polyline = MKPolyline(coordinates: &mutableCoords, count: mutableCoords.count)
    let rect = polyline.boundingMapRect

    cameraPosition = .rect(rect.insetBy(dx: -rect.width * 0.2, dy: -rect.height * 0.2))
  }

  private func loadLookAroundScene() {
    if let selectedItem {
      Task {
        let request = MKLookAroundSceneRequest(mapItem: selectedItem)
        lookAroundScene = try? await request.scene
      }
    } else {
      lookAroundScene = nil
    }
  }
}

private struct MapLoadingIndicator: View {
  @State private var isAnimating: Bool = false

  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "map")
        .font(.title)
        .symbolEffect(.breathe, options: .repeat(.continuous))
      Text("Preparing your trip map")
        .font(.subheadline)
        .opacity(isAnimating ? 0.3 : 1.0)
        .onAppear {
          withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            isAnimating = true
          }
        }
    }
    .foregroundStyle(Color(.appBlue))
  }
}

#Preview {
  TripMapView(trip: .preview, selectedDay: 0)
}
