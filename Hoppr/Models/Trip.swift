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
  
  var activityCount: Int {
    itinerary.reduce(0) { result, activity in
      result + activity.activities.count
    }
  }
}

struct GenerateTripRequest: Encodable {
  let deviceId: String
  let destination: String
  let duration: Int
  let preferences: Preferences
}

extension Trip {
  static let preview = Trip(
    id: "j973ntxrjpa8wgd2pqqpabhfss85ac2e",
    deviceId: "D5553FFA-0DC6-48DD-820C-AB094BDFF287",
    destination: "Osaka",
    duration: 3,
    preferences: Preferences(
      style: .cultural,
      budget: .moderate,
      group: .friends,
      pace: .moderate
    ),
    itinerary: [
      DayPlan(
        day: 1,
        morning: Activity(
          name: "Osaka Castle & Park",
          description:
            "Visit Osaka Castle and explore its surrounding park (Osaka Castle Park) for cultural context and city views.",
          category: .culture
        ),
        afternoon: Activity(
          name: "Shinsekai & Tsutenkaku Tower",
          description:
            "Walk the historic Shinsekai district, explore the lively streets and the iconic Tsutenkaku Tower (observation deck).",
          category: .culture
        ),
        evening: Activity(
          name: "Shinsekai dinner: kushikatsu and kushiage",
          description:
            "Dinner in Shinsekai: try classic Kansai street eats—kushikatsu at Daruma (Shinsekai) and kushiage at Men’s Teppanyaki (Shinsekai).",
          category: .food
        )
      ),
      DayPlan(
        day: 2,
        morning: Activity(
          name: "Osaka Castle Park / Nanko Bird Sanctuary walk",
          description:
            "Relax at Osaka Castle Park or take a quiet walk along the canal paths near Nanko Bird Sanctuary for morning greenery.",
          category: .nature
        ),
        afternoon: Activity(
          name: "National Museum of Art, Osaka (NMAO)",
          description:
            "Explore the National Museum of Art, Osaka (NMAO), focusing on its collection of international modern art and architecture.",
          category: .culture
        ),
        evening: Activity(
          name: "Dotonbori food crawl: Mizuno and Kuromon Ichiba Market",
          description:
            "Dine in the Dotonbori area: dinner at Mizuno for takoyaki and okonomiyaki, plus Kuromon Ichiba Market for fresh seafood snacks.",
          category: .food
        )
      ),
      DayPlan(
        day: 3,
        morning: Activity(
          name: "Kuromon Ichiba Market breakfast",
          description:
            "Breakfast and market stroll at Kuromon Ichiba Market, sampling local produce and street bites.",
          category: .food
        ),
        afternoon: Activity(
          name: "Amerikamura (Amemura) & Midosuji-dori",
          description:
            "Discover unique boutiques and vintage finds in the Amerikamura (Amemura) area and along Midosuji-dori.",
          category: .shopping
        ),
        evening: Activity(
          name: "Bunraku puppet show or Umeda Arts Theater performance",
          description:
            "Attend a traditional Bunraku puppet show at the National Bunraku Theatre (book in advance) or see a contemporary performance at Umeda Arts Theater.",
          category: .entertainment
        )
      ),
    ],
    createdAt: 1_700_000_000
  )
}
