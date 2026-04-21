//
//  Trip.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation

struct Trip: Codable, Identifiable {
  let id: String
  let deviceId: String
  let destination: String
  let duration: Int
  let preferences: Preferences
  let itinerary: [DayPlan]
  let createdAt: Double

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case deviceId
    case destination
    case duration
    case preferences
    case itinerary
    case createdAt
  }
}

struct GenerateTripRequest: Encodable {
  let deviceId: String
  let destination: String
  let duration: Int
  let preferences: Preferences
}
