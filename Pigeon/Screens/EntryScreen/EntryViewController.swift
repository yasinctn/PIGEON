//
//  EntryViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

protocol EntryViewInput: AnyObject { }

final class EntryViewController: UIViewController {
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    private var viewModel: EntryViewOutput?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EntryViewModel()
        setupUI()
    }
    
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        performSegue(identifier: "entryToLogin")
    }
    
    @IBAction private func registerButtonTapped(_ sender: UIButton) {
        performSegue(identifier: "entryToRegister")
    }
    

}
// MARK: - private methods

private extension EntryViewController {
    enum Constants{
        static let buttonCornerRadius: CGFloat = 20
    }
    
    func setupUI() {
        registerButton.layer.cornerRadius = Constants.buttonCornerRadius
        loginButton.layer.cornerRadius = Constants.buttonCornerRadius
    }
    
}

// MARK: - SeguePerformable
extension EntryViewController: SeguePerformable { }
