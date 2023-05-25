//
//  LoginViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

protocol LoginViewInput: AnyObject {
    func showAlert(_ message: String)
    func showAlert(with identifier: String, title: String, actionTitle: String)
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private var viewModel: LoginViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(view: self)
        setupUI()
        
    }
    
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        viewModel?.login(email: emailTextField.text, password: passwordTextField.text)
    }
    
    
}
// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput, AlertPresentable {
    func showAlert(_ message: String) {
        presentAlert(message)
    }
    
    func showAlert(with identifier: String, title: String, actionTitle: String) {
        presentAlertWithAction(identifier: identifier, alertTitle: title, actionTitle: actionTitle)
    }
}

// MARK: - Private Methods

private extension LoginViewController {
    
    func setupUI() {
        loginButton.layer.cornerRadius = 20
    }
}
