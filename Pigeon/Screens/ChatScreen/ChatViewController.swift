//
//  ChatViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

final class ChatViewController: UIViewController {

    @IBOutlet private weak var messagesTableView: UITableView!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func sendButtonTapped(_ sender: UIButton) {
    }
}
