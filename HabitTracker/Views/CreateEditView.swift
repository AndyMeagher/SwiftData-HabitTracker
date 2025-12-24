//
//  CreateView.swift
//  HabitTracker
//
//  Created by Andy M on 12/16/25.
//

import SwiftUI
import SwiftData


struct CreateEditView: View {
    
    @Environment(\.modelContext) private var modelContext
    var habit: Habit?
    var onDismiss: (() -> Void)?
    @State var name: String = ""
    @State var selectedDays: Set<DayOfWeek> =  Set(DayOfWeek.allCases)
    @State var selectedColor: ColorPalette = ColorPalette.labelColors.randomElement() ?? .brightBlue
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                onDismiss?()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .tint(.black)
            }.padding()
        }
        VStack(alignment: .leading) {
            Text("I will,")
            TextField("Name your habit", text: $name)
                .padding()
                .textFieldStyle(OutlinedTextFieldStyle())
            Spacer()
            Text("on the following days:")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                
                ForEach(DayOfWeek.allCases, id: \.self) { day in
                    let daySelected = selectedDays.contains(day)
                    HStack{
                        Text(day.displayName).frame(maxWidth: .infinity, alignment: .center)
                        if daySelected{
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }else{
                            
                        }
                    }.foregroundStyle(daySelected ? Color.white : Color.gray)
                        .padding()
                        .background(daySelected ? Color.indigo : Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .onTapGesture{
                            if daySelected{
                                selectedDays.remove(day)
                                return
                            }
                            selectedDays.insert(day)
                        }
                }
            }
            
            Spacer()
            Text("select color:")
            HStack{
                ForEach(ColorPalette.allCases, id: \.self) { labelColor in
                    ZStack{
                        Circle().fill(labelColor.color).onTapGesture{
                            selectedColor = labelColor
                        }
                        if selectedColor.id == labelColor.id{
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                    }.onTapGesture{
                        selectedColor = labelColor
                    }
                }
            }
            Spacer()
            HStack{
                Spacer()
                Button("Commit") {
                    if let _ = habit{
                        habit?.name = name
                        habit?.assignedDays = Array(selectedDays)
                        habit?.labelColor = selectedColor
                    }else{
                        let habit = Habit(name: name, labelColor: selectedColor, assignedDays: Array(selectedDays))
                        modelContext.insert(habit)
                    }
                    onDismiss?()
                }
                .disabled(name.isEmpty)
                .buttonStyle(CustomButtonStyle())
                Spacer()
            }
            
        }
        .onAppear{
            if let habitToEdit = habit{
                name = habitToEdit.name
                selectedDays = Set(habitToEdit.assignedDays)
                selectedColor = habitToEdit.labelColor
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    CreateEditView().modelContainer(container)
}
