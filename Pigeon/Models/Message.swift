//
//  Message.swift
//  Pigeon
//
//  Created by Yasin Cetin on 1.06.2023.
//

import Foundation

struct Message {
    let sender: String
    let body: String
    let date: String
    let receiver: String
    
    
    init(body: String, sender: String, date: String, receiver: String) {
        self.sender = sender
        self.body = body
        self.date = date
        self.receiver = receiver
    }
}
