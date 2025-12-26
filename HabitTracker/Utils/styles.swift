//
//  theme.swift
//  HabitTracker
//
//  Created by Andy M on 12/24/25.
//

import SwiftUI

enum ColorPalette: String, CaseIterable, Codable {
    
    case vermillion
    case seafoam
    case robinEgg
    case brightBlue
    case eucalyptus
    case navy
    case purple
    case gray
    case indigo
    case pink

    var id: String { rawValue }

    var color: Color {
        switch self {
  
        case .purple: return Color(hex: 0x857eb1)
        case .vermillion: return Color(hex: 0xd4493f)
        case .gray: return Color(hex: 0x7f7376)
        case .seafoam: return Color(hex: 0x95d0ac)
        case .robinEgg: return Color(hex: 0x7ed7dc)
        case .brightBlue: return Color(hex: 0x0096ec)
        case .eucalyptus: return Color(hex: 0x5e7f62)
        case .navy: return Color(red: 0, green: 0, blue: 0.5)
        case .pink: return Color(hex: 0xfcf8f8)
        case .indigo: return .indigo
        }
    }
    
    static let labelColors: [ColorPalette] = [.vermillion, .seafoam, .robinEgg, .brightBlue, .eucalyptus, .gray]
    
    var displayName: String {
        rawValue.capitalized
    }
}

struct OutlinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(ColorPalette.navy.color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RoundedCard: View {
    let title: String
    let color: Color
    let showCheckmark: Bool
 
    var body: some View {
        HStack {
            ZStack{
                Circle().fill(color).brightness(-0.2)
                if showCheckmark {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }.frame(width: 50, height: 50)
                .padding(8)
            Text(title)
                .foregroundStyle(.white)
            
        }
     
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(color))
        )
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}
