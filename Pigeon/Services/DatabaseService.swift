//
//  DatabaseService.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

protocol DatabaseServiceProtocol {
    func writeUserData(username: String, email: String, password: String, completion: @escaping (Error?) -> Void)
    func getUsers(completion: @escaping (QuerySnapshot?, Error?) -> Void)
}

final class DatabaseService: DatabaseServiceProtocol {
    
    // MARK: - USERS
    
    func writeUserData(username: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        let userDocumentsPath = Firestore.firestore().document("Users/\(email)")
        let userData = ["username": username,
                        "email": email,
                        "password": password]
        
        userDocumentsPath.setData(userData) { error in
            completion(error)
        }
    }
    
    func getUsers(completion: @escaping(QuerySnapshot?, Error?) -> Void) {
        let userDocumentsPath = Firestore.firestore().collection("Users")
        userDocumentsPath.getDocuments { querySnapshot, error in
            completion(querySnapshot, error)
        }
    }
    
    
}


