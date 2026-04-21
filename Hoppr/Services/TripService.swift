//
//  TripService.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation
import UIKit

enum TripServiceError: LocalizedError {
  case rateLimitExceeded(retryAfter: Double?)
  case networkError(Int)
  case decodingError

  var errorDescription: String? {
    switch self {
    case .rateLimitExceeded(let retryAfter):
      if let seconds = retryAfter {
        let minutes = Int(ceil(seconds / 60))
        return "Generation limit reached. Try again in \(minutes) minutes."
      }
      return "Generation limit reached. Try again later."
    case .networkError(let code):
      return "Network error \(code)"
    case .decodingError:
      return "Failed to parse server response"
    }
  }
}

struct TripService {
  static let shared = TripService()

  private let baseUrl = "https://determined-bobcat-581.convex.site"
  private var devideId: String {
    UIDevice.current.identifierForVendor?.uuidString ?? "N/A"
  }

  func generateTrip(
    destination: String,
    duration: Int,
    preferences: Preferences
  ) async throws -> Trip {
    let url = URL(string: "\(baseUrl)/generate")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(
      GenerateTripRequest(
        deviceId: devideId,
        destination: destination,
        duration: duration,
        preferences: preferences
      )
    )

    let (data, response) = try await URLSession.shared.data(for: request)
    try handleStatus(response, data)
    return try JSONDecoder().decode(Trip.self, from: data)
  }

  func fetchTrips() async throws -> [Trip] {
    var urlComponents = URLComponents(string: "\(baseUrl)/trips")!
    urlComponents.queryItems = [URLQueryItem(name: "deviceId", value: devideId)]

    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    try handleStatus(response, data)
    return try JSONDecoder().decode([Trip].self, from: data)
  }

  private func handleStatus(_ response: URLResponse, _ data: Data) throws {
    guard let http = response as? HTTPURLResponse else { return }
    switch http.statusCode {
    case 200...299: return
    case 429:
      let body = try? JSONDecoder().decode([String: Double].self, from: data)
      throw TripServiceError.rateLimitExceeded(retryAfter: body?["retryAfter"])
    default:
      throw TripServiceError.networkError(http.statusCode)
    }
  }
}
