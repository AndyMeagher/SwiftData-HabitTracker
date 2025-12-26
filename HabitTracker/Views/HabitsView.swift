//
//  HabitsView.swift
//  HabitTracker
//
//  Created by Andy M on 12/22/25.
//

import SwiftUI
import SwiftData

enum ActiveSheet: Identifiable {
    case create
    case edit(Habit)
    
    var id: Int {
        switch self {
        case .create: return 1
        case .edit(let habit): return habit.id.hashValue
        }
    }
}

struct HabitsView: View {
    @Query var habits: [Habit]
    @State private var activeSheet: ActiveSheet?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack{
            HStack{
                
                Text("My Habits:")
                    .font(Font.custom("Copperplate", size: 26))
                    .padding()
                Spacer()
            }
            List {
                ForEach(habits) { habit in
                    RoundedCard(title: habit.name, color: habit.labelColor.color, showCheckmark: true)
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(habit)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                               activeSheet = .edit(habit)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }.listRowSeparator(.hidden)
            }.listStyle(.plain)
            Spacer()
            Button(action: {
                activeSheet = .create
            }) {
                HStack{
                    Text("New")
                    Image(systemName: "plus")
                }
            }.buttonStyle(CustomButtonStyle())
        }.sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .create:
                CreateEditView{
                    activeSheet = nil
                }
            case .edit(let habit):
                CreateEditView(habit: habit){
                    activeSheet = nil
                }
            }
        }
    }
}

#Preview {
    HabitsView()
}
