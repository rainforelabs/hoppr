//
//  Activity.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation

struct Activity: Codable {
  let name: String
  let descritpion: String
  let category: Category

  enum Category: String, Codable, CaseIterable {
    case culture, food, nature, entertainment, shopping
  }
}
