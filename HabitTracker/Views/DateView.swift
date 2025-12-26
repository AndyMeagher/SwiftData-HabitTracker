//
//  DateView.swift
//  HabitTracker
//
//  Created by Andy M on 12/21/25.
//

import SwiftUI


struct DateListView: View {
    let availableDates: [Date]
    @Binding var selectedDate: Date

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(availableDates, id: \.self) { date in
                        DateCell(date: date, isSelected: selectedDate == date){
                            selectedDate = date
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    proxy.scrollTo(date.hashValue, anchor: .center)
                                }
                            }
                        }.id(date.hashValue)
                    }
                }
            }
            .contentMargins(.trailing, 20, for: .scrollContent)
            .scrollIndicators(.hidden)
            .onAppear {
                proxy.scrollTo(selectedDate.hashValue)
            }
        }
    }
}

struct DateCell: View {
    let date: Date
    let isSelected: Bool
    let onSelect: () -> Void
    
    private var dateString: String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }
    
    var body: some View {
        Text(dateString)
            .id(date.hashValue)
            .padding()
            .foregroundStyle(isSelected ? Color.white : Color.black)
            .background(isSelected ? Color.indigo : Color.indigo.opacity(0.1))
            .cornerRadius(8)
            .onTapGesture(perform: onSelect)
    }
}


