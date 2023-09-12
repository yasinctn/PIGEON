//
//  Message.swift
//  Pigeon
//
//  Created by Yasin Cetin on 1.06.2023.
//

import Foundation

struct Message {
    let sender: User
    let receiver: User
    let body: String
    let date: String
    
    
    
    init(body: String, sender: User, date: String, receiver: User) {
        self.sender = sender
        self.body = body
        self.date = date
        self.receiver = receiver
    }
}
