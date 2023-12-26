import SwiftUI
import Firebase

class SessionStore: ObservableObject {
    @Published var user: User?
    
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        listenForAuthChanges()
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
