//
//  HomeView.swift
//  HabitTracker
//
//  Created by Andy M on 12/22/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            HabitsView()
                .tabItem {
                    Image(systemName: "list.star")
                }
        }.tint(ColorPalette.navy.color)
    }
}

#Preview {
    MainView()
}
