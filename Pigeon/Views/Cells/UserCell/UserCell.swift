//
//  UserCell.swift
//  Pigeon
//
//  Created by Yasin Cetin on 27.05.2023.
//

import UIKit

final class UserCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    static let identifier = "UserCell"
    private(set) var conversationId: String?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(for presentedCell: UserCellPresenter) {
        conversationId = presentedCell.conversationID
        usernameLabel.text = presentedCell.username
    }
    
    func getUsername() -> String? {
        usernameLabel.text
    }
}
