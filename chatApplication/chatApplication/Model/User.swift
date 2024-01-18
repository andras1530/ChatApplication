//
//  User.swift
//  chatApplication
//
//  Created by Nagy Andras on 17.01.2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER)
            {
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user from user defaults",error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    static func == (lhs : User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

//going to take the user object that we created, encode it to to json and save it to the UserDefaults with the key currentUser
func saveUserLocally(_ user: User) {
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: kCURRENTUSER)
    }catch {
        print("error saving user locally ", error.localizedDescription)
    }
    
}
