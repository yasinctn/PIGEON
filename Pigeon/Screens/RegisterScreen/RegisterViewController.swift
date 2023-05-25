//
//  RegisterViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

protocol RegisterViewInput: AnyObject {
    func showAlert(_ message: String)
    func showAlert(with identifier: String, title: String, actionTitle: String)
}

final class RegisterViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    
    private var viewModel: RegisterViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegisterViewModel(view: self)
        setupUI()
    }
    
    @IBAction private func registerButtonTapped(_ sender: UIButton) {
        viewModel?.register(username: usernameTextField.text,
                            email: emailTextField.text,
                            password: passwordTextField.text)
    }
}

// MARK: - private methods

private extension RegisterViewController {
    
    func setupUI() {
        registerButton.layer.cornerRadius = 15
    }
}

// MARK: - RegisterViewInput

extension RegisterViewController: RegisterViewInput, AlertPresentable {
    
    func showAlert(_ message: String) {
        presentAlert(message)
    }
    
    func showAlert(with identifier: String, title: String, actionTitle: String) {
        presentAlertWithAction(identifier: identifier, alertTitle: title, actionTitle: actionTitle)
    }
}
