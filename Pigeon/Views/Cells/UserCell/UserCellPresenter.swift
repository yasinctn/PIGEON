//
//  UserCellPresenter.swift
//  Pigeon
//
//  Created by Yasin Cetin on 27.05.2023.
//

import Foundation

struct UserCellPresenter {
    var conversationID: String
    var username: String
    
    init(conversationID: String, username: String) {
        self.conversationID = conversationID
        self.username = username
    }
}
