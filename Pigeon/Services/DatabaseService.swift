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
    func createConversation(selectedUser: String, completion: @escaping (Conversation, Error?) -> Void)
    func writeMessageData(users: [String], conversation: Conversation, message: String, completion: @escaping (Error?) -> Void)
    func readMessageData(conversationId: String, completion: @escaping([Message]?, Error?, String?) -> Void)
    
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
    
    func createConversation(selectedUser: String, completion: @escaping (Conversation, Error?) -> Void) {
        
        let docRef = Firestore.firestore().collection("conversations").document()
        let conversationId = docRef.documentID
        guard let currentUser else { return }
        let createdConversation = Conversation(conversationID: conversationId, users: [currentUser,selectedUser], receiver: selectedUser, sender: currentUser)

        writeConversationToUsers(docRef: docRef, conversation: createdConversation) { error in
            completion(createdConversation,error)
        }
    }
    
    // MARK: - Messages
    
    func writeMessageData(users: [String], conversation: Conversation, message: String, completion: @escaping (Error?) -> Void) {
        
        for user in users {
            let userConversation = Firestore.firestore().collection("Users").document(user).collection("conversations").document(conversation.conversationID).collection("messages")
            
            userConversation.addDocument(data: ["sender": currentUser!,
                                                "receiver": conversation.receiver,
                                                "message": message,
                                                "date": Date().formatted(),
                                                "order": Date().timeIntervalSince1970] ) { error in
                completion(error)
            }
        }
    }
    
    func readMessageData(conversationId: String, completion: @escaping([Message]?, Error?, String?) -> Void) {
        
        guard let currentUser else { return }
        
        let userConversation = Firestore.firestore().collection("Users").document(currentUser).collection("conversations").document(conversationId).collection("messages")
        let query = userConversation.order(by: "order")
        
        query.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self else { return }
            
            if let messages = self.getMessages(in: querySnapshot) {
                completion(messages,error,currentUser)
            }
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
            
            // buraya bi bak yeeenim
            guard let conversationId = conversation["conversationId"] as? String,
                  let users = conversation["users"] as? [String] else { return [] }
            
            for user in users {
                if user != currentUser {
                    let newConversation = Conversation(conversationID: conversationId, users: users, receiver: user, sender: currentUser!)
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
    
    func writeConversationToUsers(docRef: DocumentReference, conversation: Conversation, completion: @escaping (Error?) -> Void) {
        let conversationData: [String: Any] = [
            "id": conversation.conversationID,
            "users": conversation.users
        ]
        docRef.setData(conversationData) { error in
            completion(error)
        }
        
        for user in conversation.users {
            
            let userConversations = Firestore.firestore().collection("Users").document(user).collection("conversations")
            let conversationData: [String: Any] = [ "conversationId": conversation.conversationID,
                                                    "users": conversation.users,
                                                    "sender": conversation.sender,
                                                    "receiver": conversation.receiver]
            userConversations.document(conversation.conversationID).setData(conversationData) { error in
                completion(error)
            }
            
        }
    }
    
    func getMessages(in querySnapshot: QuerySnapshot?) -> [Message]? {
        
        var messages: [Message]? = []
        
        if let snapshotDocument = querySnapshot?.documents {
            for document in snapshotDocument {
                let message = document.data()
                
                if let messageSender = message["sender"] as? String,
                   let messageReceiver = message["receiver"] as? String,
                   let messageBody = message["message"] as? String,
                   let messageDate = message["date"] as? String {
                    
                    let newMessage = Message(body: messageBody,
                                             sender: messageSender,
                                             date: messageDate,
                                             receiver: messageReceiver)
                    
                    messages?.append(newMessage)
                }
            }
            return messages
        }
        return messages
    }
}


