//
//  SignUPView.swift
//  DBQ
//
//  Created by Shishir Mishra on 26/12/2023.
//

import SwiftUI
import Firebase

struct SignUPView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showLoginView = false
    
    var body: some View {
        VStack {
            if (showLoginView) {
                LoginView()
            }else {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: signup) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
            }            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func signup() {
        sessionStore.signUp(email: email, password: password) { error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else {
                sessionStore.signOut() // sign out so that user need to login
                self.showLoginView = true
            }
        }
    }
}

