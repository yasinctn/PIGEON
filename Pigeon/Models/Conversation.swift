//
//  Conversation.swift
//  Pigeon
//
//  Created by Yasin Cetin on 26.05.2023.
//

import Foundation

final class Conversation {
    let conversationID: String
    let users: [User]
    let receiver: User
    let sender: User
    
    
    init(conversationID: String, users: [User], receiver: User, sender: User) {
        self.conversationID = conversationID
        self.users = users
        self.receiver = receiver
        self.sender = sender
    }
}
