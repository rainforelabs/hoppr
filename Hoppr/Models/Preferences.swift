//
//  Preference.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation

struct Preferences: Codable {
  let style: TravelStyle
  let budget: Budget
  let group: TravelGroup
  let pace: Pace

  enum TravelStyle: String, Codable, CaseIterable {
    case adventure, cultural, relaxation, nature, nightlife
  }

  enum Budget: String, Codable, CaseIterable {
    case budget, moderate, luxury
  }

  enum TravelGroup: String, Codable, CaseIterable {
    case solo, couple, family, friends
  }

  enum Pace: String, Codable, CaseIterable {
    case slow, moderate, packed
  }
}
