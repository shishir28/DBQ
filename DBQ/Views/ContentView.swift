//
//  ConsentView.swift
//  DBQ
//
//  Created by Shishir Mishra on 22/12/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var showSurveyView = false
    @State private var showLoginView = false
    
    var body: some View {
        Group {
            if (showLoginView) {
                LoginView().environmentObject(sessionStore)
            } else {
                SurveyView()
            }
        }.onAppear(perform: {
            self.showLoginView = sessionStore.user == nil
        })
    }
}
