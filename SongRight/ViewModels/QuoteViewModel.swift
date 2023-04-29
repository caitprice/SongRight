//
//  QuoteViewModel.swift
//  SongRight
//
//  Created by Caitlin Price on 4/28/23.
//

import Foundation
@MainActor

class QuoteViewModel: ObservableObject {
    struct Result: Codable {
        let id: String?
        var content: String?
        var author: String?
        
//        enum CodingKeys: CodingKey {
//            case content, author
//        }
    }
    var urlString = "https://api.quotable.io/quotes/random"
    
    private var outer: [Result] = []
    @Published var content = ""
    @Published var author = ""
    
    func getData() async {
        print("🕸️We are accessing the the url \(urlString)")
        //convert URL to special type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let result = try? JSONDecoder().decode([Result].self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data from \(urlString)")
                return
            }
            self.outer = result
            self.content = (self.outer)[0].content!
            
        } catch {
            print("😡 ERROR: Could not use URL at \(urlString) to get data & response")
        }
    }
}

