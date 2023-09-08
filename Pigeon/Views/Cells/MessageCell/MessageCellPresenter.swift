//
//  MessageCellPresenter.swift
//  Pigeon
//
//  Created by Yasin Cetin on 9.07.2023.
//

import Foundation

struct MessageCellPresenter {
    var messageLabel: String
    var date: String
    var receiver: String
    var sender: String
    
    init(messageLabel: String, date: String, receiver: String, sender: String) {
        self.messageLabel = messageLabel
        self.date = date
        self.receiver = receiver
        self.sender = sender
    }
}
