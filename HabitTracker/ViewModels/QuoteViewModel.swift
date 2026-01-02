//
//  QuoteViewModel.swift
//  HabitTracker
//
//  Created by Andy M on 12/29/25.
//
import Foundation
import SwiftData
import SwiftUI

@MainActor
class QuoteViewModel: ObservableObject {
    
    @Published var quoteOfTheDay: QuoteOfTheDay?
    @Published var errorMessage: String?
    
    // Fetch from saved quotes otherwise get new one
    func fetchTodayQuote(modelContext: ModelContext, date: Date = .now) async {
        guard let remoteUrl = URL(string: "https://zenquotes.io/api/random")  else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        do {
            let dateToFetch = Calendar.current.startOfDay(for: date)
            let descriptor = FetchDescriptor<QuoteOfTheDay>(
                predicate: #Predicate { $0.date == dateToFetch }
            )
            
            let result = try modelContext.fetch(descriptor)
            if !result.isEmpty{
                DispatchQueue.main.async {
                    self.quoteOfTheDay = result.first
                }
            }else{
                let (data, _) = try await URLSession.shared.data(from: remoteUrl)
                let decodedResponse = try JSONDecoder().decode([QuoteOfTheDay].self, from: data)

                DispatchQueue.main.async {
                    if let decodedQuote = decodedResponse.first {
                        decodedQuote.date = dateToFetch
                        modelContext.insert(decodedQuote)
                        self.quoteOfTheDay = decodedQuote
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            }
        }
    }
}
