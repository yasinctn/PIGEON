//
//  NewConversationViewModel.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation

protocol NewConversationViewOutput {
    var usersCount: Int { get }
    var selectedUser: String? { get }
    func setSelectedUser(by index: Int)
    func getUsers()
    func getUser(_ index: Int) -> String?
    func createNewConversation(selectedUser: String?)
}

final class NewConversationViewModel {
    
    weak var view: NewConversationViewInput?
    private var databaseService: DatabaseServiceProtocol?
    private var users: [String] = []
    private(set) var selectedUser: String?
    
    init(view: NewConversationViewInput,
         databaseService: DatabaseServiceProtocol? = DatabaseService()) {
        
        self.view = view
        self.databaseService = databaseService
    }
}

// MARK: - NewConversationViewOutput

extension NewConversationViewModel: NewConversationViewOutput {

    
    func createNewConversation(selectedUser: String?) {
        guard let selectedUser else { return }
        databaseService?.createConversation(selectedUser: selectedUser ) { [weak self] conversation, error in
            guard let self else { return }
            if let error = error {
                self.view?.showAlert(error.localizedDescription)
            }else {
                self.view?.popViewController()
                self.view?.showAlert("Conversation Created")
            }
        }
    }
    
    
    func getUsers() {
        
        databaseService?.readUsers { [weak self] users, error in
            guard let self else { return }
            if let error = error {
                self.view?.showAlert(error.localizedDescription)
            }else if let users = users {
                self.users = []
                self.users = users
                
                DispatchQueue.main.async {
                    self.view?.reloadData()
                }
            }
        }
    }
    
    
    func setSelectedUser(by index: Int) {
         guard let user = users[safe: index] else { return }
         selectedUser = user
     }
     
     
    func getUser(_ index: Int) -> String? {
        self.users[safe: index]
    }
    
    var usersCount: Int {
        users.count
    }
    
}
