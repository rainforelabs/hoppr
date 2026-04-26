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
    id: "j972b0kbfcpfwrjjf0gwtk2bb985jjtd",
    deviceId: "D5553FFA-0DC6-48DD-820C-AB094BDFF287",
    destination: "Japan",
    duration: 5,
    preferences: Preferences(
      style: .cultural,
      budget: .moderate,
      group: .couple,
      pace: .moderate
    ),
    itinerary: [
      DayPlan(
        day: 1,
        morning: Activity(
          name: "Senso-ji Temple Asakusa",
          description:
            "Walk through the Kaminarimon Gate and explore the historic stalls of Nakamise-dori before reaching Tokyo's oldest temple.",
          category: .culture,
          address: "2 Chome-3-1 Asakusa, Taito City, Tokyo 111-0032, Japan"
        ),
        afternoon: Activity(
          name: "Imperial Palace East Garden Tokyo",
          description:
            "Stroll through the meticulously manicured Honmaru and Ninomaru gardens located on the former site of Edo Castle.",
          category: .nature,
          address: "1-1 Chiyoda, Chiyoda City, Tokyo 100-8111, Japan"
        ),
        evening: Activity(
          name: "Ginza Kojyu Tokyo",
          description:
            "Experience an exquisite multi-course kaiseki dinner prepared by Chef Toru Okuda in an intimate, luxury setting.",
          category: .food,
          address: "5-4-8 Ginza, Chuo City, Tokyo 104-0061, Japan"
        )
      ),
      DayPlan(
        day: 2,
        morning: Activity(
          name: "Meiji Jingu Shrine Shibuya",
          description:
            "Walk through the towering torii gates and serene forest to reach this Shinto shrine dedicated to Emperor Meiji.",
          category: .culture,
          address: "1-1 Yoyogikamizonocho, Shibuya City, Tokyo 151-8557, Japan"
        ),
        afternoon: Activity(
          name: "Nezu Museum Minato",
          description:
            "Admire a private collection of pre-modern Japanese and East Asian art before wandering through the stunning private garden.",
          category: .culture,
          address: "6 Chome-5-1 Minamiaoyama, Minato City, Tokyo 107-0062, Japan"
        ),
        evening: Activity(
          name: "New York Bar at Park Hyatt Tokyo",
          description:
            "Enjoy live jazz and panoramic city views while sipping premium cocktails in the iconic setting from the film Lost in Translation.",
          category: .entertainment,
          address: "3-7-1-2 Nishi-Shinjuku, Shinjuku City, Tokyo 163-1055, Japan"
        )
      ),
      DayPlan(
        day: 3,
        morning: Activity(
          name: "Tenryu-ji Temple Kyoto",
          description:
            "Explore this head temple of the Tenryu branch of Rinzai Zen Buddhism, famous for its 14th-century Sogenchi Garden.",
          category: .culture,
          address: "68 Sagatenryuji Susukinobabacho, Ukyo Ward, Kyoto 616-8385, Japan"
        ),
        afternoon: Activity(
          name: "Arashiyama Bamboo Grove Kyoto",
          description:
            "Take a slow walk through the towering green stalks for a meditative experience in one of Japan's most photographed natural spots.",
          category: .nature,
          address: "Sagatenryuji Susukinobabacho, Ukyo Ward, Kyoto 616-8385, Japan"
        ),
        evening: Activity(
          name: "Hyotei Kyoto",
          description:
            "Indulge in a legendary kaiseki meal at this three-Michelin-starred restaurant that has been serving guests for over 400 years.",
          category: .food,
          address: "35 Nanzenji Kusakawacho, Sakyo Ward, Kyoto 606-8437, Japan"
        )
      ),
      DayPlan(
        day: 4,
        morning: Activity(
          name: "Kiyomizu-dera Temple Kyoto",
          description:
            "Visit the massive wooden stage for breathtaking views of Kyoto and drink from the Otowa Waterfall for health and longevity.",
          category: .culture,
          address: "1 Chome-294 Kiyomizu, Higashiyama Ward, Kyoto 605-0862, Japan"
        ),
        afternoon: Activity(
          name: "Gion District Kyoto",
          description:
            "Wander the preserved streets of Hanami-koji to spot geiko and maiko heading to their evening appointments in traditional teahouses.",
          category: .culture,
          address: "Gionmachi Minamigawa, Higashiyama Ward, Kyoto 605-0074, Japan"
        ),
        evening: Activity(
          name: "Gion Sasaki Kyoto",
          description:
            "Enjoy a dynamic and innovative Michelin-starred dining experience where the chef prepares seasonal dishes right before your eyes.",
          category: .food,
          address: "566-27 Komatsucho, Higashiyama Ward, Kyoto 605-0811, Japan"
        )
      ),
      DayPlan(
        day: 5,
        morning: Activity(
          name: "Fushimi Inari Taisha Kyoto",
          description:
            "Hike through the thousands of vermilion torii gates that wind up the wooded mountain for a spiritual and scenic journey.",
          category: .culture,
          address: "68 Fukakusa Yabunouchicho, Fushimi Ward, Kyoto 612-0882, Japan"
        ),
        afternoon: Activity(
          name: "Camellia Garden Teahouse Kyoto",
          description:
            "Participate in a private, authentic tea ceremony led by a tea master to learn the intricate rituals of Japanese hospitality.",
          category: .culture,
          address: "349-12 Masuyacho, Higashiyama Ward, Kyoto 605-0826, Japan"
        ),
        evening: Activity(
          name: "Kyogoku Kane-yo Kyoto",
          description:
            "Savor the restaurant's signature Kinshi-don, a grilled eel bowl topped with a thick Japanese omelet, in a historic Taisho-era building.",
          category: .food,
          address: "406 Rokkakucho, Nakagyo Ward, Kyoto 604-8034, Japan"
        )
      ),
    ],
    createdAt: 1_700_000_000
  )
}
