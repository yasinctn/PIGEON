//
//  Conversation.swift
//  Pigeon
//
//  Created by Yasin Cetin on 26.05.2023.
//

import Foundation

final class Conversation {
    let conversationID: String
    let users: [String]
    let receiver: String
    let sender: String
    
    
    init(conversationID: String, users: [String], receiver: String, sender: String) {
        self.conversationID = conversationID
        self.users = users
        self.receiver = receiver
        self.sender = sender
    }
}
