//
//  FirebaseAuthService.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func register(email: String, username: String, password: String, completion: @escaping (Error?) -> Void)
    func logout(completion: @escaping (NSError?) -> Void)
}

final class FirebaseAuthService {
    
    var currentUser: User? {
        guard let email = Auth.auth().currentUser?.email,
           let username = Auth.auth().currentUser?.displayName else { return nil }
        return User(email: email ,username: username )
    }
}

extension FirebaseAuthService: AuthServiceProtocol {
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(error)
        }
    }
    
    func register(email: String, username: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
            
            let changeRequest = authResult?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges { profileError in
                if let profileError = profileError {
                    completion(profileError)
                } else {
                    completion(nil)
                }
            }
        }
        
    }
    
    func logout(completion: @escaping (NSError?) -> Void) {
        do{
            try Auth.auth().signOut()
            completion(nil)
        }
        catch let error as NSError{
            completion(error)
        }
        
    }
}
