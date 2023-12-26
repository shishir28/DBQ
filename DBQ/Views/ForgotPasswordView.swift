//
//  SignUPView.swift
//  DBQ
//
//  Created by Shishir Mishra on 26/12/2023.
//

import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var email = ""
    
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
                                
                HStack {
                    Button(action: resetPassword) {
                        Text("Reset Password")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                    }
                    Button(action: backToLogin) {
                        Text("Back to Login")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                    }
                }.padding()                
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func resetPassword() {
        sessionStore.resetPassword(email: email) { error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else {
                sessionStore.signOut() // sign out so that user need to login
                self.showLoginView = true
            }
        }
    }
    
    func backToLogin() {
        sessionStore.signOut()
        self.showLoginView = true
    }
}
