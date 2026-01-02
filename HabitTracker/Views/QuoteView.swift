//
//  QuoteView.swift
//  HabitTracker
//
//  Created by Andy M on 12/29/25.
//

import SwiftUI


struct QuoteView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: QuoteViewModel = QuoteViewModel()
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack{
            if let quote = viewModel.quoteOfTheDay{
                Text(quote.text)
                    .font(Font.custom("Copperplate", size: 26))
                Text("-\(quote.author)")
            }else if let errorMessage = viewModel.errorMessage{
                Text(errorMessage)
            }
        }
        .padding()
        .onChange(of: selectedDate) { _, _ in
            Task{
                await viewModel.fetchTodayQuote(modelContext: modelContext, date: selectedDate)
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchTodayQuote(modelContext: modelContext, date: selectedDate)
            }
        }
    }
}
