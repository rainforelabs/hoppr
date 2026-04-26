//
//  GeocodeService.swift
//  Hoppr
//
//  Created by Aditya Rohman on 26/04/26.
//

import CoreLocation
import Foundation
import MapKit

struct MapData {
  let items: [MKMapItem]
  let routes: [MKRoute]
}

struct MapService {
  func buildMapData(for trip: Trip) async -> [MapData] {
    var data = [MapData]()

    for day in trip.itinerary {
      var items = [MKMapItem]()
      var routes = [MKRoute]()

      for activity in day.activities {
        do {
          if let mapItem = try await search(by: "\(activity.name), \(trip.destination)") {
            items.append(mapItem)
          } else if let mapItem = try await search(by: activity.address) {
            items.append(mapItem)
          } else if let mapItem = try await geocode(by: activity.address) {
            items.append(mapItem)
          }
        } catch {
          continue
        }
      }

      for i in 0..<(items.count - 1) {
        do {
          let request = MKDirections.Request()
          request.source = items[i]
          request.destination = items[i + 1]
          request.transportType = .automobile

          let directions = MKDirections(request: request)
          let response = try await directions.calculate()
          if let route = response.routes.first {
            routes.append(route)
          }
        } catch {
          continue
        }
      }

      data.append(MapData(items: items, routes: routes))
    }

    return data
  }

  private func search(by query: String) async throws -> MKMapItem? {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.resultTypes = .pointOfInterest

    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    return response.mapItems.first
  }

  private func geocode(by address: String) async throws -> MKMapItem? {
    guard let request = MKGeocodingRequest(addressString: address) else { return nil }

    let mapItems = try await request.mapItems
    return mapItems.first
  }
}
