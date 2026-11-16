//
//  TheContent.swift
//  Planto
//
//  Created by Lamya on 11/11/2026.
//

import SwiftUI

// MARK: - Room
enum Room: String, CaseIterable, Identifiable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"

    var id: String { rawValue }
}

// MARK: - Light
enum Light: String, CaseIterable, Identifiable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"

    var id: String { rawValue }
}

// MARK: - Watering Days
enum WateringDays: String, CaseIterable, Identifiable {
    case everyDay = "Every day"
    case every2Days = "Every 2 days"
    case every3Days = "Every 3 days"
    case onceaWeek = "Once a week"
    case every10Days = "Every 10 days"
    case every2Weeks = "Every 2 weeks"

    var id: String { rawValue }

    // الفاصل بين كل إشعار بالثواني (اليوم = 86400 ثانية)
    var intervalSeconds: TimeInterval {
        switch self {
        case .everyDay: return 1 * 86400
        case .every2Days: return 2 * 86400
        case .every3Days: return 3 * 86400
        case .onceaWeek: return 7 * 86400
        case .every10Days: return 10 * 86400
        case .every2Weeks: return 14 * 86400
        }
    }
}

// MARK: - Water
enum Water: String, CaseIterable, Identifiable {
    case small = "20-50 ml"
    case medium = "50-100 ml"
    case large = "100-200 ml"
    case extralarge = "200-300 ml"

    var id: String { rawValue }
}

// MARK: - Plant
struct Plant: Identifiable {
    let id = UUID()
    var name: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var waterAmount: Water
    var isWatered: Bool = false
}
