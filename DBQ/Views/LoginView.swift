import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSurveyView = false
    @State private var showSignUpView = false
    @State private var showForgotPassword = false
    
    var body: some View {
        
        VStack {
            if (showSurveyView) {
                SurveyView()
            } else if (showSignUpView) {
                SignUPView()
            }else if (showForgotPassword) {
                ForgotPasswordView()
            }
            else {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button(action: signIn) {
                        Text("Login")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                    }.padding()
                    
                    Group {
                        Button("Sign Up"){
                            self.showSurveyView = false
                            self.showForgotPassword = false
                            self.showSignUpView = true
                        }.padding()
                        
                        Button("Forgot Password"){
                            self.showSurveyView = false
                            self.showSignUpView  = false
                            self.showForgotPassword = true
                        }.padding()
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear(perform: {
            //            sessionStore.signOut()
            self.showSurveyView = sessionStore.user != nil
        })
    }
    
    func signIn() {
        sessionStore.signIn(email: email, password: password){ error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else {
                self.showSurveyView = true;
            }
        }
    }
}
