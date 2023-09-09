//
//  NewConversationViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

protocol NewConversationViewInput: AnyObject {
    func reloadData()
    func prepareTableView()
    func popViewController()
    func showAlert(_ message: String)
}

final class NewConversationViewController: UIViewController {

    @IBOutlet private weak var usersTableView: UITableView!
    private var viewModel: NewConversationViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        viewModel = NewConversationViewModel(view: self)
        viewModel?.getUsers()
    }
}

//MARK: - TableViewDataSource

extension NewConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.usersCount ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        if let user = viewModel?.getUser(indexPath.row) {
            cell.configure(for: UserCellPresenter(username: user))
        }
        return cell
    }
    
    
}

// MARK: - TableViewDelegate

extension NewConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setSelectedUser(by: indexPath.row)
        viewModel?.createNewConversation(selectedUser: viewModel?.selectedUser)
        
    }
    
}

//MARK: - NewConversationViewInput

extension NewConversationViewController: NewConversationViewInput, AlertPresentable {
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func prepareTableView() {
        usersTableView.dataSource = self
        usersTableView.delegate = self
    }
    
    func reloadData() {
        usersTableView.reloadData()
    }
    
    func showAlert(_ message: String) {
        presentAlert(message)
    }
    
}
