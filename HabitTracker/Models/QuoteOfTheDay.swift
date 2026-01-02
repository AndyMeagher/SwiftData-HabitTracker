//
//  User.swift
//  HabitTracker
//
//  Created by Andy M on 12/29/25.
//


import Foundation
import SwiftData

@Model
class QuoteOfTheDay: Decodable {
    @Attribute(.unique) var id: UUID
    var text: String
    var author: String
    var date: Date? // set externally
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        text = try container.decode(String.self, forKey: .text)
        author = try container.decode(String.self, forKey: .author)
    }
    
    enum CodingKeys: String, CodingKey {
          case text = "q"
          case author = "a"
    }
}
