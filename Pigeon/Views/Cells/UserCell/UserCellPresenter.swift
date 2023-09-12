//
//  UserCellPresenter.swift
//  Pigeon
//
//  Created by Yasin Cetin on 27.05.2023.
//

import Foundation

struct UserCellPresenter {
    var conversationID: String
    var user: User
    
    init(conversationID: String = "" , user: User) {
        self.conversationID = conversationID
        self.user = user
    }
}
