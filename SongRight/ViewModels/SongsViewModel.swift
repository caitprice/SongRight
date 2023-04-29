//
//  SongsViewModel.swift
//  SongRight
//
//  Created by Caitlin Price on 4/25/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

class SongsViewModel: ObservableObject {
    @Published var song = Song()
    
    func saveSong(song: Song) async -> Bool {
        let db = Firestore.firestore()
        if let id = song.id {
            do {
                try await db.collection("songs").document(id).setData(song.dictionary)
                print("😎Data updated successfully!")
                return true
            } catch {
                print("😡 Could not update data in songs \(error.localizedDescription)")
                return false
            }
        } else { // must have new song to add
            do {
                try await db.collection("songs").addDocument(data: song.dictionary)
                print("🐣Data added successfully!")
                return true
                
            } catch {
                print("😡 Could not create new song in songs \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func deleteSong(song: Song) async -> Bool {
        let db = Firestore.firestore() // database
        guard let songID = song.id else {
            print("😡 ERROR: song.id = \(song.id ?? "nil"). This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("songs").document(songID).delete()
            print("🗑️ Document successfully deleted!")
            return true
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
            return false
            
        }
    }
    
//        func deleteSong(atOffsets: IndexSet) {
//            song.remove(atOffsets: atOffsets)
//        }
//        func moveSong(fromOffsets: IndexSet, toOffset: Int) {
//            song.move(fromOffsets: fromOffsets, toOffset: toOffset)
//        }

}
