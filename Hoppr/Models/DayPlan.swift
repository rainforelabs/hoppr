//
//  DayPlan.swift
//  Hoppr
//
//  Created by Aditya Rohman on 21/04/26.
//

import Foundation

struct DayPlan: Codable {
  let day: Int
  let morning: Activity
  let afternoon: Activity
  let evening: Activity

  var activities: [Activity] { [morning, afternoon, evening] }
  var slotLabels: [String] { ["Morning", "Afternoon", "Evening"] }
}
