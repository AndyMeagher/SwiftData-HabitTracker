//
//  ContentView.swift
//  HabitTracker
//
//  Created by Andy M on 12/15/25.
//

import SwiftUI
import SwiftData
import ConfettiSwiftUI

struct HomeView: View {
    
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    @State private var showConfirmUndo = false
    @State private var celebratedDates: [Date] = []
    
    private var daysHabits: [Habit] {
        return habits.filter{
            $0.createdAt <= selectedDate &&
            $0.assignedDays.contains(where: { dow in
                dow.id == Calendar.current.component(.weekday, from: selectedDate)
            })
        }
    }
    
    private var completedDayHabits: [Habit] {
        return daysHabits.filter{$0.isCompleted(on: selectedDate)}
    }
    
    private var pendingDayHabits: [Habit] {
        return daysHabits.filter{ !$0.isCompleted(on: selectedDate)}
    }
    
    var availableDates : [Date] {
        let oldestDate = habits.map{$0.createdAt}.min() ?? Calendar.current.startOfDay(for: Date())
        return Calendar.current.getDates(from: oldestDate)
    }
    
    func checkCelebration(date: Date) {
        if !self.celebratedDates.contains(date) && pendingDayHabits.isEmpty && !completedDayHabits.isEmpty{
            self.celebratedDates.append(date)
        }
    }
    
    var body: some View {
        
        VStack{
            Text("Habit Tracker").padding(.bottom)
            DateListView(availableDates: availableDates, selectedDate: $selectedDate)
            QuoteView(selectedDate: $selectedDate)
            if pendingDayHabits.isEmpty && completedDayHabits.isEmpty {
                Text("You haven't committed any habits for this date yet.").padding(50)
            }else{
                if pendingDayHabits.isEmpty  {
                    Text("Congrats!\nYou've Completed all your habits for this day 🎉")
                        .multilineTextAlignment(.center)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 50)
                        .padding(.horizontal, 20)
                        .listRowBackground(Color.clear)
                        .onChange(of: selectedDate){ _, newVal in
                            checkCelebration(date: newVal)
                        }
                        .onAppear{
                            checkCelebration(date: selectedDate)
                        }
                        .confettiCannon(trigger: $celebratedDates)
                }
                List {
                    if !pendingDayHabits.isEmpty {
                        Section(header:
                                    Text("To Do:")
                            .font(Font.custom("Copperplate", size: 20))
                        ) {
                            ForEach(pendingDayHabits) { habit in
                                RoundedCard(title: habit.name, color: habit.labelColor.color, showCheckmark: false).onTapGesture {
                                    let _ = habit.addEntry(on: self.selectedDate)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    
                    if !completedDayHabits.isEmpty {
                        Section(header: Text("Completed:").font(Font.custom("Copperplate", size: 20))) {
                            ForEach(completedDayHabits) { habit in
                                RoundedCard(title: habit.name, color: habit.labelColor.color, showCheckmark: true).onLongPressGesture {
                                    self.showConfirmUndo = true
                                }.swipeActions {
                                    Button(role: .destructive) {
                                        habit.entries.removeAll { entry in
                                            return entry.date == self.selectedDate
                                        }
                                        try? modelContext.save()
                                        celebratedDates.removeAll{ date in return date == self.selectedDate}
                                    } label: {
                                        Label("Undo", systemImage: "arrow.uturn.backward")
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color.clear)
            }
            Spacer()
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    return HomeView().modelContainer(container)
}

