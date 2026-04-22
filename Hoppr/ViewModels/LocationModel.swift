//
//  LocationModel.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import CoreLocation
import Foundation

@Observable
class LocationModel: NSObject, CLLocationManagerDelegate {
  let locationManager = CLLocationManager()
  var currentLocation: CLLocationCoordinate2D?

  override init() {
    super.init()
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.delegate = self
  }

  func getCurrentLocation() {
    if locationManager.authorizationStatus == .authorizedWhenInUse {
      currentLocation = nil
      locationManager.requestLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedWhenInUse {
      manager.requestLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard currentLocation == nil else { return }
    if let location = locations.last?.coordinate {
      currentLocation = location
    }

    locationManager.stopUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    print("Location error: \(error)")
  }
}
