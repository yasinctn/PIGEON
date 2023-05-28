//
//  ConversationsViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

protocol ConversationsViewInput: AnyObject {
    func prepareTableView()
    func reloadData()
    func showAlert(_ message: String)
    func goToEntryScreen()
}

final class ConversationsViewController: UIViewController {

    @IBOutlet private weak var conversationsTableView: UITableView!
    
    private var viewModel: ConversationsViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ConversationsViewModel(view: self)
        prepareTableView()
        viewModel?.getConversations()
    }
    
    @IBAction private func logoutButtonTapped(_ sender: UIBarButtonItem) {
        viewModel?.logout()
    }
    
    @IBAction private func newConversationButtonTapped(_ sender: UIBarButtonItem) {
    }
}

// MARK: - TableViewDataSource

extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.conversationCount ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
        if let conversation = viewModel?.getConversation(indexPath.row) {
            cell.configure(for: ConversationCellPresenter(conversationID: conversation.conversationID, username: conversation.chatTo))
        }
        return cell
    }
}

// MARK: - TableViewDelegate

extension ConversationsViewController: UITableViewDelegate { }

// MARK: - ConversationViewInput

extension ConversationsViewController: ConversationsViewInput, AlertPresentable {
    func prepareTableView() {
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
    func reloadData() {
        conversationsTableView.reloadData()
    }
    
    func showAlert(_ message: String) {
        presentAlert(message)
    }
    
    func goToEntryScreen() {
        popToRootViewControllerWithAlert(alertTitle: "Logout Success", actionTitle: "Close")
    }
}


