//
//  Activity.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation
import SwiftUI

struct Activity: Codable {
  let name: String
  let description: String
  let category: Category
  let address: String

  enum Category: String, Codable, CaseIterable {
    case culture, food, nature, entertainment, shopping

    var emoji: String {
      switch self {
      case .culture: "🏛️"
      case .food: "🍜"
      case .nature: "🌿"
      case .entertainment: "🍿"
      case .shopping: "🛍️"
      }
    }
    
    var icon: String {
      switch self {
      case .culture: "building.columns.fill"
      case .food: "takeoutbag.and.cup.and.straw.fill"
      case .nature: "leaf.fill"
      case .entertainment: "popcorn.fill"
      case .shopping: "bag.fill"
      }
    }

    var label: String {
      switch self {
      case .culture: "Culture"
      case .food: "Food"
      case .nature: "Nature"
      case .entertainment: "Entertainment"
      case .shopping: "Shopping"
      }
    }

    var color: Color {
      switch self {
      case .culture: Color(.systemPurple)
      case .food: Color(.systemOrange)
      case .nature: Color(.systemGreen)
      case .entertainment: Color(.systemRed)
      case .shopping: Color(.systemPink)
      }
    }
  }
}
