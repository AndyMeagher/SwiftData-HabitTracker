//
//  CompletedDate.swift
//  HabitTracker
//
//  Created by Andy M on 12/21/25.
//

import Foundation
import SwiftData

@Model
class HabitEntry {
    var date: Date
    var completed: Bool
    var habit: Habit?

    init(date: Date, completed: Bool, habit: Habit?) {
        self.date = date
        self.completed = completed
        self.habit = habit
        
    }
}
