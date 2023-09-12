//
//  RegisterViewModel.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//
import Foundation

protocol RegisterViewOutput {
    func register(username: String?, email: String?, password: String?)
}

final class RegisterViewModel {
    
    weak var view: RegisterViewInput?
    private let databaseService: DatabaseServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(view: RegisterViewInput,
         databaseService: DatabaseServiceProtocol = DatabaseService(),
         authService: AuthServiceProtocol = FirebaseAuthService()) {
        
        self.view = view
        self.databaseService = databaseService
        self.authService = authService
    }
}

// MARK: - RegisterViewOutput

extension RegisterViewModel: RegisterViewOutput {
    
    func register(username: String?, email: String?, password: String?) {
        
        let (isValid, alertMessage) = checkValidation(username: username, email: email, password: password)
        
        if let email, let username, let password, isValid {
            authService.register(email: email, username: username, password: password) { [weak self] authError in
                guard let self else { return }
                
                if let error = authError {
                    self.view?.showAlert(error.localizedDescription)
                } else {
                    self.writeUserData(username: username, email: email, password: password)
                }
            }
        } else {
            view?.showAlert(alertMessage ?? "")
        }
    }
}

// MARK: - Private methods

private extension RegisterViewModel {
    
    func writeUserData(username: String, email: String, password: String) {
        
        databaseService.writeUserData(username: username, email: email) { [weak self] error in
            guard let self else { return }
            
            if let error = error {
                self.view?.showAlert(error.localizedDescription)
            } else {
                self.view?.showAlert(with: "registerToConversations", title: "Register Successfull", actionTitle: "Go To Conversations")
            }
        }
    }
    
    func checkValidation(username: String?, email: String?, password: String?) -> (Bool, String?) {
        
        guard let email, let password, let username else {
            return (false, "Please fill fields")
        }
        if email.isEmpty {
            return (false, "e mail empty \nPlease type an e mail")
        } else if password.isEmpty {
            return (false, "password empty \nPlease type a pasword")
        } else if username.isEmpty {
            return (false, "username empty \nPlease type a username")
        }
        return (true, nil)
    }
}
