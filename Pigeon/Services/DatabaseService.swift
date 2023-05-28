//
//  DatabaseService.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation
import FirebaseFirestore

protocol DatabaseServiceProtocol {
    func writeUserData(username: String, email: String, password: String, completion: @escaping (Error?) -> Void)
    func getUsers(completion: @escaping (QuerySnapshot?, Error?) -> Void)
    func readConversationsForUser(completion: @escaping ([Conversation]?, Error?) -> Void)
    
}

final class DatabaseService: DatabaseServiceProtocol {
    
    var currentUser: String? {
        FirebaseAuthService().currentUser
    }
    
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
    
    func readConversationsForUser(completion: @escaping ([Conversation]?, Error?) -> Void) {
        guard let currentUser else { return }

        let userConversations = Firestore.firestore().collection("Users").document(currentUser).collection("conversations")
        
        userConversations.getDocuments { [weak self] querySnapshot, error in
            guard let self else { return }
            
            let conversations = self.createConversationsForRead(in: querySnapshot, user: currentUser)
            completion(conversations, error)
        }
    }
    
    
}

// MARK: - Private Methods

private extension DatabaseService {
    
    func createConversationsForRead(in snapshotDocument: QuerySnapshot?, user: String) -> [Conversation] {
        var conversations: [Conversation] = []
        guard let snapshotDocument = snapshotDocument?.documents else { return [] }
        
        for doc in snapshotDocument {
            let conversation = doc.data()
            
            guard let conversationId = conversation["conversationId"] as? String,
                  let users = conversation["users"] as? [String] else { return [] }
            
            for user in users {
                if user != currentUser {
                    let newConversation = Conversation(conversationID: conversationId, user: user, chatTo: user)
                    conversations.append(newConversation)
                }
            }
        }
        return conversations
    }
}


