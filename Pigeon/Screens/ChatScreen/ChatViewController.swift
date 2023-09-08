//
//  ChatViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

protocol ChatViewInput: AnyObject {
    func reloadData()
    func showAlert(_ message: String)
    func clearMessageTextField()
}

final class ChatViewController: UIViewController {

    @IBOutlet private weak var messagesTableView: UITableView!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    
    private var viewModel: ChatViewOutput?
    var currentConversation: Conversation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChatViewModel(view: self)
        prepareTableView()
        viewModel?.getMessages(conversationId: currentConversation?.conversationID)
    }
    
    @IBAction private func sendButtonTapped(_ sender: UIButton) {
        viewModel?.sendMessages(message: messageTextField.text, conversation: currentConversation)
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.messageCount ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        if let message = viewModel?.getMessage(indexPath.row) {
            cell.configure(for: MessageCellPresenter(messageLabel: message.body, date: message.date, receiver: message.receiver, sender: message.sender), currentUser: viewModel?.currentUser)
        }
        return cell
    }
    
    
}
// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
}

// MARK: - ChatViewInput

extension ChatViewController: ChatViewInput, AlertPresentable {
    func clearMessageTextField() {
        messageTextField.text = nil
    }
    
    
    func showAlert(_ message: String) {
        presentAlert(message)
    }
    
    
    func reloadData() {
        messagesTableView.reloadData()
    }
}

private extension ChatViewController {
    
    func prepareTableView() {
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.separatorStyle = .none
        messagesTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
    }
}
