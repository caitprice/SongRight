//
//  ListView.swift
//  SongRight
//
//  Created by Caitlin Price on 4/24/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "songs") var songs: [Song]
    @EnvironmentObject var songsVM: SongsViewModel
    @EnvironmentObject var quoteVM: QuoteViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var sheetIsPresented = false
    @State private var searchText = ""
    @State private var noSongs = "You haven't written any songs yet, click New Song!"
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(songs) { song in
                    LazyVStack {
                        NavigationLink {
                            SongDetailView(song: song)
                        } label: {
                            VStack {
                                Text(song.title)
                                    .foregroundColor(Color("Gray"))
                                    .font(Font.custom("TAN - SONGBIRD", size: 12))
                                Text(song.melody)
                                    .foregroundColor(.gray)
                                    .font(Font.custom("TAN - SONGBIRD", size: 10))
                            }
                        }
                        
                    }
                }
            }
            
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out successful!")
                            dismiss()
                        } catch {
                            print("😡ERROR: Could not sign out")
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        HStack {
                            Text("New Song")
                                .font(Font.custom("TAN - SONGBIRD", size: 15))
                            Image(systemName: "square.and.pencil.circle")
                                .font(.title)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            .font(Font.custom("TAN - SONGBIRD", size: 9))
            .searchable(text: $searchText)
            .fullScreenCover(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SongDetailView(song: Song())
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListView()
                .environmentObject(SongsViewModel())
                .environmentObject(QuoteViewModel())
        }
    }
}

