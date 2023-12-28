import SwiftUI
import Firebase
import SwiftyJSON

class SessionStore: ObservableObject {
    @Published var user: User?
    @Published var sessionId: String = ""
    // To do : Should have session Id
 
    
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        listenForAuthChanges()
        let newUUID = UUID()
        sessionId = newUUID.uuidString
    }
    
    func listenForAuthChanges() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { (_, user) in
            if let user = user {
                self.user = user
            } else {
                self.user = nil
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func saveQuestionnaireResult (_ questionnaireResult: QuestionnaireResult){
        
        do {
           
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(questionnaireResult)
            
           
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
//                db.collection("questionnaireResults").document(sessionId).setData([
//                    "data": jsonString
//                ]) { error in
//                    if let error = error {
//                        print("Error storing data: \(error.localizedDescription)")
//                    } else {
//                        print("Data stored successfully!")
//                    }
//                }
            }
        } catch {
            print("Error encoding object: \(error.localizedDescription)")
        }
        
    }
    
    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

struct SessionStoreEnvironmentKey: EnvironmentKey {
    static var defaultValue: SessionStore = SessionStore()
}

extension EnvironmentValues {
    var sessionStore: SessionStore {
        get { self[SessionStoreEnvironmentKey.self] }
        set { self[SessionStoreEnvironmentKey.self] = newValue }
    }
}
