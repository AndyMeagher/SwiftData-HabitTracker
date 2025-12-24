//
//  ContentView.swift
//  HabitTracker
//
//  Created by Andy M on 12/15/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    @State private var showConfirmUndo = false

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
        let oldestDate = habits.map{$0.createdAt}.min() ?? Date()
        return Calendar.current.getDates(from: oldestDate)
    }
    
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Habit Tracker:")
                    .font(Font.custom("Copperplate", size: 26))
                    .padding()
                Spacer()
            }
            DateListView(availableDates: availableDates, selectedDate: $selectedDate)
            if pendingDayHabits.isEmpty && completedDayHabits.isEmpty {
                Spacer()
                Text("You haven't committed any habits for this date yet.").padding()
                Spacer()
            }else{
                List {
                    Section(header: Text("To Do:")) {
                        ForEach(pendingDayHabits) { habit in
                            RoundedCard(title: habit.name, color: habit.labelColor.color, showCheckmark: false).onTapGesture {
                                let _ = habit.addEntry(on: self.selectedDate)
                            }
                        }
                    }
                    Section(header: Text("Completed:")) {
                        ForEach(completedDayHabits) { habit in
                            RoundedCard(title: habit.name, color: habit.labelColor.color, showCheckmark: true).onLongPressGesture {
                                self.showConfirmUndo = true
                            }.confirmationDialog(
                                "Habit options",
                                isPresented: $showConfirmUndo
                            ) {
                                Button("Undo Complete", role: .destructive) {
                                    habit.entries.removeAll { entry in
                                        entry.date == self.selectedDate
                                    }
                                    self.showConfirmUndo = false
                                }

                                Button("Cancel", role: .cancel) {
                                    self.showConfirmUndo = false
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    return HomeView().modelContainer(container)
}

