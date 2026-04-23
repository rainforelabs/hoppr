//
//  Preference.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation

struct Preferences: Codable {
  var style: TravelStyle = .adventure
  var budget: Budget = .moderate
  var group: TravelGroup = .solo
  var pace: Pace = .moderate

  enum TravelStyle: String, Codable, CaseIterable {
    case adventure, cultural, relaxation, nature, nightlife

    var label: String {
      switch self {
      case .adventure: "Adventure"
      case .cultural: "Cultural"
      case .relaxation: "Relaxation"
      case .nature: "Nature"
      case .nightlife: "Nightlife"
      }
    }
  }

  enum Budget: String, Codable, CaseIterable {
    case budget, moderate, luxury

    var label: String {
      switch self {
      case .budget: "Budget-friendly"
      case .moderate: "Mid-range"
      case .luxury: "Premium"
      }
    }
  }

  enum TravelGroup: String, Codable, CaseIterable {
    case solo, couple, family, friends

    var label: String {
      switch self {
      case .solo: "Solo"
      case .couple: "Partner"
      case .family: "Family"
      case .friends: "Friends"
      }
    }
  }

  enum Pace: String, Codable, CaseIterable {
    case slow, moderate, packed

    var label: String {
      switch self {
      case .slow: "Slow"
      case .moderate: "Balanced"
      case .packed: "Packed"
      }
    }
  }

  var icons: [String] { ["mappin.and.ellipse", "dollarsign", "person", "figure.run"] }
  var labels: [String] { [style.label, budget.label, group.label, pace.label] }
}
