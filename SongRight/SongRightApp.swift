//
//  SongRightApp.swift
//  SongRight
//
//  Created by Caitlin Price on 4/24/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
@main
struct SongRightApp: App {
    @StateObject var songsVM = SongsViewModel()
    @StateObject var quoteVM = QuoteViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(songsVM)
                .environmentObject(quoteVM)
        }
    }
}
