//
//  DBQApp.swift
//  DBQ
//
//  Created by Shishir Mishra on 20/12/2023.
//

import SwiftUI
import Firebase 

@main
struct DBQApp: App {
    var  sessionStore:SessionStore
    init() {
        // Initialize ResearchKit
        FirebaseApp.configure()
        sessionStore = SessionStore()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(sessionStore)
        }
    }
}
