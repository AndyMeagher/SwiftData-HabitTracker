//
//  Habit.swift
//  HabitTracker
//
//  Created by Andy M on 12/16/25.
//
import SwiftData
import Foundation
import SwiftUI

@Model
class Habit : Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var labelColor: ColorPalette
    var assignedDays: [DayOfWeek]
    var createdAt: Date
    var entries: [HabitEntry] = []
    
    init(name: String, labelColor: ColorPalette = .brightBlue, assignedDays: [DayOfWeek] = []) {
        self.name = name
        self.labelColor = labelColor
        self.assignedDays = assignedDays
        self.createdAt = Calendar.current.startOfDay(for: .now)
    }
}

extension Habit {
    func addEntry(
        on date: Date = .now,
        completed: Bool = true
    ) -> HabitEntry {
        let day = Calendar.current.startOfDay(for: date)
        
        if let entry = entry(for: day) {
            entry.completed.toggle()
            return entry
        }
        
        let entry = HabitEntry(
            date: day,
            completed: true,
            habit: self
        )
        entries.append(entry)
        
        return entry
    }
    
    func entry(for date: Date = .now) -> HabitEntry? {
        let day = Calendar.current.startOfDay(for: date)
        return entries.first { $0.date == day }
    }
    
    func isCompleted(on date: Date = .now) -> Bool {
        entry(for: date)?.completed == true
    }
}

enum DayOfWeek: Int, CaseIterable, Codable {
    
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
     
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        case .sunday:
            return "Sun"
        }
    }
}



