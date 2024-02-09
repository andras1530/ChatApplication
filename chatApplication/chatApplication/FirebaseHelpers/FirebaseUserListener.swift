//
//  FirebaseUserListener.swift
//  chatApplication
//
//  Created by Nagy Andras on 17.01.2024.
//

import Foundation
import Firebase

class FirebaseUserListener {
    static let shared = FirebaseUserListener()
    
    private init () {}
    
    //Mark: - Login
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (authDataResult,error) in
            
            if error == nil && authDataResult!.user.isEmailVerified {
                FirebaseUserListener.shared.downloadUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                
                completion(error, true)
            } else {
                print("Email is not verified!")
                completion(error, false)
            }
        }
    }
    
    //Mark: - Register
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (AuthDataResult, error) in
            
            completion(error)
            
            if error == nil {
                //send verification email
                AuthDataResult!.user.sendEmailVerification() {
                    (error) in print("auth email sent with error: ", error!.localizedDescription)
                }
                //create user and save it
                if AuthDataResult?.user != nil {
                    let user = User(id: AuthDataResult!.user.uid, username: email, email: email, pushId: "",avatarLink: "", status: "Hey there")
                    
                    saveUserLocally(user)
                    self.saveUserToFireStore(user)
                }
             
            }
        }
    }
    //Mark: - resend link methods
    func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: {(error) in
            completion(error)
            })
        })
    }
    
        // reset password
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) {
            (error) in completion(error)
        }
    }
    
    //Mark: - Logout
    func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)
        }catch let error as NSError {
            completion(error)
        }
        
    }
    
    //Mark: - save users in db
    func saveUserToFireStore(_ user: User){
        
        do {
            try FirebaseReference(collectionReference: .User).document(user.id).setData(from: user)
        } catch {
            print(error.localizedDescription,"adding user")
        }
    }
    
    //Mark: -downloadUserFromFirebase
    func downloadUserFromFirebase(userId: String, email: String? = nil) {
        
        FirebaseReference(collectionReference: .User).document(userId).getDocument {
            (QuerySnapshot, error) in
            
            guard let document = QuerySnapshot else {
                print("no document")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
                case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                }else {
                    print("Document does not exist")
                }
                case .failure(let error):
                    print("Error decoding user ",error)
            }
        }
        
    }
}
