//
//  HabitAgentCoordinator.swift
//  HabitTracker
//
//  Created by Andy M on 1/2/26.
//
import SwiftAI


@Generable
struct HabitSuggestion : Identifiable {
    var id: Int
    let name: String
    let category: HabitCategory
}

@Generable
enum HabitCategory: String, CaseIterable {
    case health, career, social, hobbies
}

final class HabitAgentCoordinator {
    
    let llm = SystemLLM()
    
    // Ensure it doesn't repeat Habits already saved
    func generateSuggestion(category: HabitCategory) async throws -> [HabitSuggestion] {
        let response = try await llm.reply(to: "What is a good habit I can start today that is in the category of \(category.rawValue)? Respond in a command and always return at least 3.", returning: [HabitSuggestion].self)
        return response.content
    }
}


