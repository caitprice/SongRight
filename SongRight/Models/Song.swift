//
//  Song.swift
//  SongRight
//
//  Created by Caitlin Price on 4/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Song: Codable, Identifiable {
    @DocumentID var id: String?
    var title = ""
    var lyrics = ""
    var melody = ""
    var quote = ""
    
    var dictionary: [String: Any] {
        return ["title": title, "lyrics": lyrics, "melody": melody, "quote": quote]
    }
    
}
