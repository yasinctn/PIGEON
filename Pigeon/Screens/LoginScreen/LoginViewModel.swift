//
//  LoginViewModel.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation

protocol LoginViewOutput: AnyObject {
    func login(email: String?, password: String?)
}

final class LoginViewModel {
    private weak var view: LoginViewInput?
    private let authService: AuthServiceProtocol?
    
    init(view: LoginViewInput) {
        self.view = view
        self.authService = FirebaseAuthService()
    }
    
}

// MARK: - LoginViewOutput

extension LoginViewModel: LoginViewOutput {
    
    func login(email: String?, password: String?) {
        let (isValid, warning) = checkValidation(email: email, password: password)
        guard let email, let password, isValid else {
            view?.showAlert(warning ?? "")
            return
        }
        
        authService?.login(email: email, password: password) { [weak self] authError in
            guard let self else { return }
            
            if let error = authError {
                self.view?.showAlert(error.localizedDescription)
            }else {
                self.view?.showAlert(with: "loginToChat", title: "Login Success", actionTitle: "Go To Conversations")
                
            }
        }
        
    }
    
    
}

// MARK: - Private Methods

private extension LoginViewModel {
    
    func checkValidation(email: String?,
                                 password: String?) -> (Bool, String?) {
        
        guard let email, let password else {
            return (false, "Please fill fields")
        }
        if email.isEmpty {
            return (false, "e mail empty \nPlease type an e mail")
        } else if password.isEmpty {
            return (false, "password empty \nPlease type a pasword")
        }
        return (true, nil)
    }
}

