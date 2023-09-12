//
//  ChatViewModel.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation

protocol ChatViewOutput {
    func getMessages(conversationId: String?)
    func getMessage(_ index: Int) -> Message?
    func sendMessages(message: String?, conversation: Conversation?)
    var messageCount: Int? { get }
    var currentUser: User? { get }
}

final class ChatViewModel {
    
    weak var view: ChatViewInput?
    private var databaseService: DatabaseServiceProtocol?
    private(set) var messageCount: Int?
    private var messages : [Message] = []
    private(set) var currentUser: User?
    
    init(view: ChatViewInput,
         databaseService: DatabaseServiceProtocol = DatabaseService()) {
        
        self.view = view
        self.databaseService = databaseService
    }
    
}

// MARK: - ChatViewOutput

extension ChatViewModel: ChatViewOutput {
    func getMessage(_ index: Int) -> Message? {
        self.messages[safe: index]
    }
    
    func getMessages(conversationId: String?) {
        if let conversationId {
            databaseService?.readMessageData(conversationId: conversationId, completion: { [weak self] allMessages, error, currentUser in
                guard let self else { return }
                
                if let error = error {
                    self.view?.showAlert(error.localizedDescription)
                    
                } else if let messages = allMessages {
                    self.messages = []
                    self.messages = messages
                    self.messageCount = messages.count
                    self.currentUser = currentUser
                    
                    DispatchQueue.main.async {
                        self.view?.reloadData()
                    }
                }
            })
        }
    }
    
    func sendMessages(message: String?, conversation: Conversation?) {
        
        let (isValid,warning) = checkValidation(message: message)
        
        if isValid {
            guard let conversation, let message else { return }
            databaseService?.writeMessageData(users: conversation.users,
                                              conversation: conversation,
                                              message: message) { [weak self] error in
                guard let self else { return }
                if let error = error {
                    self.view?.showAlert(error.localizedDescription)
                }else {
                    self.view?.clearMessageTextField()
                }
            }
        }else {
            view?.showAlert(warning ?? "please try again")
        }
        
    }
    
    
}

private extension ChatViewModel {
    
    func checkValidation(message: String?) -> (Bool, String?) {
        guard let message else {
            return (false, "please type a message")
        }
        if message == "" {
            return (false, "please type a message")
        }
        return (true, nil)
    }
}

