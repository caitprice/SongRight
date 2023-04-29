//
//  RandomWord.swift
//  SongRight
//
//  Created by Caitlin Price on 4/28/23.
//

import Foundation

struct Quote: Codable, Identifiable {
    let id = UUID().uuidString
    var content: String
    var author: String
    
    enum CodingKeys: CodingKey {
        case content, author
    }
}
