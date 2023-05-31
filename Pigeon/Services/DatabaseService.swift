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
    func readUsers(completion: @escaping ([String]?, Error?) -> Void)
    func readConversationsForUser(completion: @escaping ([Conversation]?, Error?) -> Void)
    func createConversation(user: String, completion: @escaping (String?, Error?) -> Void)
    
}

final class DatabaseService: DatabaseServiceProtocol {
  
    // MARK: - Users
    
    var currentUser: String? {
        FirebaseAuthService().currentUser
    }
    
    func writeUserData(username: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        let userDocumentsPath = Firestore.firestore().document("Users/\(email)")
        let userData = ["username": username,
                        "email": email,
                        "password": password]
        
        userDocumentsPath.setData(userData) { error in
            completion(error)
        }
    }
    
    func readUsers(completion: @escaping ([String]?, Error?) -> Void) {
        let userDocumentsPath = Firestore.firestore().collection("Users")
        guard let currentUser else { return }
        userDocumentsPath.getDocuments { [weak self] querySnapshot, error in
            guard let self else { return }
            let users = self.getUsers(in: querySnapshot, for: currentUser)
            completion(users,error)
            
        }
    }
    
    // MARK: - Conversations
    
    func readConversationsForUser(completion: @escaping ([Conversation]?, Error?) -> Void) {
        guard let currentUser else { return }
        
        let userConversations = Firestore.firestore().collection("Users").document(currentUser).collection("conversations")
        
        userConversations.getDocuments { [weak self] querySnapshot, error in
            guard let self else { return }
            
            let conversations = self.getConversationsForRead(in: querySnapshot, user: currentUser)
            completion(conversations, error)
        }
    }
    
    func createConversation(user: String, completion: @escaping (String?, Error?) -> Void) {
        
        let conversation = Firestore.firestore().collection("conversations").document()
        let conversationId = conversation.documentID
        guard let currentUser else { return }
        writeConversationToUsers(conversation: conversation, conversationID: conversationId, users: [currentUser,user]) { error in
            completion(conversationId,error)
        }
    }
}

// MARK: - Private Methods

private extension DatabaseService {
    
    func getConversationsForRead(in snapshotDocument: QuerySnapshot?, user: String) -> [Conversation] {
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
    
    func getUsers(in snapshotDocument: QuerySnapshot?, for currentUser: String?) -> [String] {
        var users: [String] = []
        guard let snapshotDocument = snapshotDocument?.documents else { return [] }
        for document in snapshotDocument {
            if currentUser != document.documentID {
                let user = document.data()
                
                if let username = user["email"] as? String {
                    users.append(username)
                }
            }
        }
        return users
    }
    
    func writeConversationToUsers(conversation: DocumentReference, conversationID: String, users: [String], completion: @escaping (Error?) -> Void) {
        let conversationData: [String: Any] = [
            "id": conversationID,
            "users": users
        ]
        conversation.setData(conversationData) { error in
            completion(error)
        }
        
        for user in users {
            
            let userConversations = Firestore.firestore().collection("Users").document(user).collection("conversations")
            let conversationData: [String: Any] = [ "conversationId": conversationID,
                                                    "users": users]
            userConversations.document(conversationID).setData(conversationData) { error in
                completion(error)
            }
            
        }
    }
}


