//
//  DatabaseService.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation
import FirebaseFirestore

protocol DatabaseServiceProtocol {
    func writeUserData(username: String, email: String, completion: @escaping (Error?) -> Void)
    func readUsers(completion: @escaping ([User]?, Error?) -> Void)
    func readConversationsForUser(completion: @escaping ([Conversation]?, Error?) -> Void)
    func createConversation(selectedUser: User, completion: @escaping (Conversation, Error?) -> Void)
    func writeMessageData(users: [User], conversation: Conversation, message: String, completion: @escaping (Error?) -> Void)
    func readMessageData(conversationId: String, completion: @escaping([Message]?, Error?, User?) -> Void)
}

final class DatabaseService: DatabaseServiceProtocol {
    
    // MARK: - Users
    
    private var currentUser: User? {
        FirebaseAuthService().currentUser
    }
    
    func writeUserData(username: String, email: String, completion: @escaping (Error?) -> Void) {
        let userDocumentsPath = Firestore.firestore().document("Users/\(email)")
        let userData = ["username": username,
                        "email": email]
        
        userDocumentsPath.setData(userData) { error in
            completion(error)
        }
    }
    
    func readUsers(completion: @escaping ([User]?, Error?) -> Void) {
        guard let currentUser else {return}
        
        let userDocumentsPath = Firestore.firestore().collection("Users")
        userDocumentsPath.getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return }
            let users = self.getUsers(in: querySnapshot, for: currentUser)
            completion(users, error)
        }
    }
    
    // MARK: - Conversations
    
    func readConversationsForUser(completion: @escaping ([Conversation]?, Error?) -> Void) {
        guard let currentUser else { return }
        
        let userConversations = Firestore.firestore().collection("Users").document(currentUser.email).collection("conversations")
        
        userConversations.getDocuments { [weak self] querySnapshot, error in
            guard let self else { return }
            
            let conversations = self.getConversationsForRead(in: querySnapshot, currentUser: currentUser)
            completion(conversations, error)
        }
        
    }
    
    func createConversation(selectedUser: User, completion: @escaping (Conversation, Error?) -> Void) {
        
        let docRef = Firestore.firestore().collection("conversations").document()
        let conversationId = docRef.documentID
        guard let currentUser else { return }
        let createdConversation = Conversation(conversationID: conversationId, users: [currentUser,selectedUser], receiver: selectedUser, sender: currentUser)
        
        writeConversationToUsers(docRef: docRef, conversation: createdConversation) { error in
            completion(createdConversation,error)
        }
    }
    
    // MARK: - Messages
    
    func writeMessageData(users: [User], conversation: Conversation, message: String, completion: @escaping (Error?) -> Void) {
        
        for user in users {
            let userConversation = Firestore.firestore().collection("Users").document(user.email).collection("conversations").document(conversation.conversationID).collection("messages")
            
            userConversation.addDocument(data: ["sender": ["email": currentUser?.email, "username": currentUser?.username],
                                                "receiver": ["email": conversation.receiver.email, "username": conversation.receiver.username],
                                                "message": message,
                                                "date": Date().formatted(),
                                                "order": Date().timeIntervalSince1970] ) { error in
                completion(error)
            }
        }
    }
    
    func readMessageData(conversationId: String, completion: @escaping([Message]?, Error?, User?) -> Void) {
        
        guard let currentUser else { return }
        
        let userConversation = Firestore.firestore().collection("Users").document(currentUser.email).collection("conversations").document(conversationId).collection("messages")
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
    
    // MARK: User Methods
    
    func getUsers(in snapshotDocument: QuerySnapshot?, for currentUser: User) -> [User] {
        var users: [User] = []
        guard let snapshotDocument = snapshotDocument?.documents else { return [] }
        for document in snapshotDocument {
            if currentUser.email != document.documentID {
                let user = document.data()
                
                if let email = user["email"] as? String,
                   let username = user["username"] as? String {
                    
                    let newUser = User(email: email, username: username)
                    users.append(newUser)
                }
            }
        }
        return users
    }
    // MARK: Conversation Methods
    
    func writeConversationToUsers(docRef: DocumentReference, conversation: Conversation, completion: @escaping (Error?) -> Void) {
        
        let conversationData: [String: Any] = [
            "id": conversation.conversationID,
            "users": conversation.users.map { ["email": $0.email, "username": $0.username] } ]
        docRef.setData(conversationData) { error in
            completion(error)
        }
        
        for user in conversation.users {
            
            let userConversations = Firestore.firestore().collection("Users").document(user.email).collection("conversations")
            
            let conversationData: [String: Any] = [ "conversationId": conversation.conversationID,
                                                    "users": conversation.users.map { ["email": $0.email, "username": $0.username] },
                                                    "sender": ["email": conversation.sender.email, "username": conversation.sender.username],
                                                    "receiver": ["email": conversation.receiver.email, "username": conversation.receiver.username]]
            
            userConversations.document(conversation.conversationID).setData(conversationData) { error in
                completion(error)
            }
        }
    }
    
    func getConversationsForRead(in snapshotDocument: QuerySnapshot?, currentUser: User) -> [Conversation] {
        var conversations: [Conversation] = []
        var userArray: [User] = []
        
        guard let snapshotDocuments = snapshotDocument?.documents else { return [] }
        
        for doc in snapshotDocuments {
            let conversationData = doc.data()
            
            guard let fetchedConversationId = conversationData["conversationId"] as? String,
                  let fetchedUsers = conversationData["users"] as? [[String: Any]] else { continue }
            userArray = []
            for user in fetchedUsers {
                if let email = user["email"] as? String,
                   let username = user["username"] as? String {
                    let newUser = User(email: email, username: username)
                    userArray.append(newUser)
                }
                
            }
            
            
            for user in userArray {
                if user.email != currentUser.email {
                    let newConversation = Conversation(conversationID: fetchedConversationId, users: userArray, receiver: user, sender: currentUser)
                    conversations.append(newConversation)
                }
            }
        }
        
        return conversations
    }
    
    // MARK: Message Methods
    
    func getMessages(in querySnapshot: QuerySnapshot?) -> [Message]? {
        
        var messages: [Message]? = []
        
        if let snapshotDocument = querySnapshot?.documents {
            for document in snapshotDocument {
                let message = document.data()
                
                if let messageSender = message["sender"] as? [String: Any],
                   let messageReceiver = message["receiver"] as? [String: Any],
                   let messageBody = message["message"] as? String,
                   let messageDate = message["date"] as? String,
                   let senderEmail = messageSender["email"] as? String,
                   let senderUsername = messageSender["username"] as? String,
                   let receiverEmail = messageReceiver["email"] as? String,
                   let receiverUsername = messageReceiver["username"] as? String {
                    
                    let sender = User(email: senderEmail, username: senderUsername)
                    let receiver = User(email: receiverEmail, username: receiverUsername)
                    
                    let newMessage = Message(body: messageBody,
                                             sender: sender,
                                             date: messageDate,
                                             receiver: receiver)
                    
                    messages?.append(newMessage)
                }
            }
        }
        return messages
    }
}


