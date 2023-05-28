//
//  Conversation.swift
//  Pigeon
//
//  Created by Yasin Cetin on 26.05.2023.
//

import Foundation

final class Conversation {
    let conversationID: String
    let user: String
    let chatTo: String
    let users: [String]
    
    init(conversationID: String, user: String, chatTo: String) {
        self.conversationID = conversationID
        self.chatTo = chatTo
        self.user = user
        self.users = [user,chatTo]
    }
}
