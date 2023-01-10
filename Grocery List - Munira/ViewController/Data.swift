//
//  Data.swift
//  Grocery List - Munira
//
//  Created by Munira on 08/01/2023.
//

import Foundation
import FirebaseDatabase

struct GroceryLists : Codable {
    let item: Items
    let email : Users
    let id : String
}
struct Users : Codable {
    let email : String
    let password: String
    let id : String
}
struct Items : Codable {
    let id: String?
    let name : String
    let addedByUser: Users
}
struct UsersItems : Codable {
    let email : String
    let id : String
}

struct GroceryItems : Codable {
    let items : Items
}

class UserData {
   static var currentUser: UsersItems?
    static func observeUsers(_ id: String, completion: @escaping ((_ users: UsersItems?) -> ())) {
        let userRef = Database.database().reference().child("users/\(id)")
        userRef.observe(.value, with: { snapshot in
            var users: UsersItems?
            if let dict = snapshot.value as? [String: Any],
                let email = dict["email"] as? String {
                users = UsersItems(email: email, id: snapshot.key)
            }
                completion(users)
        })
    }
}
