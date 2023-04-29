//
//  SongDetailView.swift
//  SongRight
//
//  Created by Caitlin Price on 4/25/23.
//

import SwiftUI
import AVFAudio
import FirebaseFirestoreSwift

struct SongDetailView: View {
    @EnvironmentObject var songsVM: SongsViewModel
    @EnvironmentObject var quoteVM: QuoteViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var audioPlayer: AVAudioPlayer!
    @State var song: Song
    @State var randomQuote = ""
    @State var melody = ""
    @State private var notes = ["A", "B", "C", "D", "E", "F", "G"]
    @State private var noteArray = ""
    @State private var note = ""
    @State private var buttonDisabled = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Button("\(Image(systemName: "music.note")) Random Note:") {
                    note = notes.randomElement()!
                    playSound(soundName: "\(note)")
                    noteArray.append(note)
                    if noteArray.count == 5 {
                        buttonDisabled = true
                        song.melody = noteArray
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .disabled(buttonDisabled)
                
                Spacer()
                
                Text(String("\(song.melody == "" ? noteArray : song.melody)"))
                    .foregroundColor(Color("Gray"))
                
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            HStack {
                Text("Song Title:")
                    .bold()
                    .foregroundColor(.gray)
                TextField("title", text: $song.title, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(Color("Gray"))
                    .font(Font.custom("TAN - SONGBIRD", size: 15))
                    .autocorrectionDisabled()
                    .keyboardType(.default)
            }
            
            Group {
                Text("Lyrics:")
                    .bold()
                    .foregroundColor(.gray)
                    .font(Font.custom("TAN - SONGBIRD", size: 12))
                
                ScrollView {
                    TextField("lyrics", text: $song.lyrics, axis: .vertical)
                        .foregroundColor(Color("Gray"))
                        .font(Font.custom("TAN - SONGBIRD", size: 10))
                        .multilineTextAlignment(.leading)
                        .autocorrectionDisabled()
                        .keyboardType(.default)
                        .fixedSize(horizontal: false, vertical: false)
                }
            }
            .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            VStack {
                Text("\(song.quote != "" ? song.quote : randomQuote)")
                    .foregroundColor(Color("Gray"))
                    .padding()
            }
        }
        .padding()
        .navigationBarBackButtonHidden(song.id == nil)
        .navigationBarTitleDisplayMode(.inline)
        .font(Font.custom("TAN - SONGBIRD", size: 10))
        
        .toolbar {
            if song.id == nil {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await songsVM.saveSong(song: song)
                            if success {
                                dismiss()
                                
                            } else{
                                print("😡 Error saving song")
                            }
                        }
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("New Random Quote") {
                        Task {
                            await quoteVM.getData()
                            randomQuote = quoteVM.content
                            song.quote = randomQuote
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    
                }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    Task {
                        let success = await songsVM.deleteSong(song: song)
                        if success {
                            dismiss()
                        }
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                }
                .disabled(song.id == nil)
            }
        }
        .font(Font.custom("TAN - SONGBIRD", size: 13))
        
        .onAppear {
            if song.melody != "" {
                buttonDisabled = true
            }
        }
        
    }
    func playSound(soundName: String) {
        guard let audioFile = NSDataAsset(name: soundName) else {
            print("Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: audioFile.data)
            audioPlayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription) creating audioplayer")
        }
    }
}
struct SongDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SongDetailView(song: Song())
                .environmentObject(SongsViewModel())
                .environmentObject(QuoteViewModel())
        }
    }
}
