//
//  TripModel.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation

enum TaskStatus {
  case idle
  case generating
  case fetching
  case generated(Trip)
  case fetched
  case failure(Error)
}

extension TaskStatus: Equatable {
  static func == (lhs: TaskStatus, rhs: TaskStatus) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle),
      (.generating, .generating),
      (.fetching, .fetching),
      (.failure, .failure):
      return true
    case (.generated(let a), .generated(let b)): return a.id == b.id
    default: return false
    }
  }
}

@MainActor
@Observable
class TripModel {
  var trips = [Trip]()
  var trip: Trip? {
    if case .generated(let trip) = status { return trip }
    return nil
  }

  var destination: String = ""
  var duration: String = ""
  var preferences: Preferences = Preferences()

  var isValidInput: Bool { !destination.isEmpty && Int(duration) ?? 0 > 0 }

  var status: TaskStatus = .idle

  func generateTrip() {
    guard !destination.isEmpty,
      let parsedDuration = Int(duration),
      parsedDuration > 0
    else { return }

    Task {
      do {
        status = .generating
        let result = try await TripService.shared.generateTrip(
          destination: destination,
          duration: parsedDuration,
          preferences: preferences
        )
        status = .generated(result)
        invalidateInput()
      } catch {
        status = .failure(error)
        invalidateInput()
      }
    }
  }

  func fetchTrips() {
    Task {
      do {
        status = .fetching
        trips = try await TripService.shared.fetchTrips()
        status = .fetched
      } catch {
        status = .failure(error)
      }
    }
  }

  private func invalidateInput() {
    destination = ""
    duration = ""
    preferences = Preferences()
  }
}
