//
//  utils.swift
//  HabitTracker
//
//  Created by Andy M on 12/21/25.
//

import Foundation
import SwiftUI

extension Calendar {
    func getDates(from startDate: Date, to endDate: Date = Date.now) -> [Date] {
        guard startDate <= endDate else {
            print("Invalid parameters: Start date must be before or equal to end date.")
            return []
        }

        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextDate = self.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return dates
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
