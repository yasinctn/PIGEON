//
//  ConversationsViewModel.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation

protocol ConversationsViewOutput {
    var conversationCount: Int { get }
    var selectedConversation: Conversation? { get }
    func getConversations()
    func getConversation(_ index: Int) -> Conversation?
    func setSelectedConversation(by index: Int)
    func logout()
}

final class ConversationsViewModel {
    
    weak var view: ConversationsViewInput?
    private var authService: AuthServiceProtocol?
    private var databaseService: DatabaseServiceProtocol?
    
    private(set) var conversations: [Conversation] = []
    private(set) var selectedConversation: Conversation?

    init(view: ConversationsViewInput,
         authService: AuthServiceProtocol = FirebaseAuthService(),
         databaseService: DatabaseServiceProtocol = DatabaseService()) {
        
        self.view = view
        self.authService = authService
        self.databaseService = databaseService
    }
    
}

extension ConversationsViewModel: ConversationsViewOutput {
    
    func setSelectedConversation(by index: Int) {
        selectedConversation = conversations[safe: index]
        
    }
    
    var conversationCount: Int {
        conversations.count
    }
    
    
    
    func logout() {
        authService?.logout { authError in
            if let error = authError {
                self.view?.showAlert(error.localizedDescription)
            } else {
                self.view?.goToEntryScreen()
            }
        }
    }
    
    func getConversations() {
        
        databaseService?.readConversationsForUser { [weak self] conversations, error in
            guard let self else { return }
            
            if let error = error {
                self.view?.showAlert(error.localizedDescription)
            }else if let conversations = conversations {
                
                self.conversations = []
                self.conversations = conversations
                
                DispatchQueue.main.async {
                    self.view?.reloadData()
                }
            }
        }
    }
    
    func getConversation(_ index: Int) -> Conversation? {
        conversations[safe: index]
    }
}
