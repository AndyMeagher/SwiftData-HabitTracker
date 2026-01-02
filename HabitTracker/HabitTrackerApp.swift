//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Andy M on 12/15/25.
//

import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {
   
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.font, Font.custom("AmericanTypewriter", size: 20))

        }
        .modelContainer(for: [Habit.self, QuoteOfTheDay.self])
    }
}
