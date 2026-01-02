//
//  SuggestionPicker.swift
//  HabitTracker
//
//  Created by Andy M on 1/2/26.
//

import SwiftUI

struct SuggestionPicker: View {
    @State var selectedCategory: HabitCategory?
    @State var suggestions: [HabitSuggestion] = []
    @State var loading: Bool = false
    var onSelect: (HabitSuggestion) -> Void
    @Environment(\.dismiss) var dismiss 

    var body: some View {
        Text("Select a category to retreive some Habit suggestions:")
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(HabitCategory.allCases, id: \.self) { cat in
                let catSelected = selectedCategory?.rawValue == cat.rawValue
                HStack{
                    Text(cat.rawValue).frame(maxWidth: .infinity, alignment: .center)
                    if catSelected{
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }.foregroundStyle(catSelected ? Color.white : Color.gray)
                    .padding()
                    .background(catSelected ? Color.indigo : Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .onTapGesture{
                        
                        if catSelected {
                            selectedCategory = nil
                        }else{
                            loading = true
                            selectedCategory = cat
                            Task{
                                if let selectedCat = selectedCategory{
                                    suggestions = try! await HabitAgentCoordinator().generateSuggestion(category: selectedCat)
                                    loading = false
                                }
                            }
                        }
                    }
            }
        }
        if loading{
            Spacer()
            Text("Loading...")
            Spacer()
        }else{
            List{
                ForEach(suggestions) { suggestion in
                    Text(suggestion.name).onTapGesture {
                        onSelect(suggestion)
                        dismiss()
                    }
                }
            }
        }
    }
}
