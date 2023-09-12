//
//  MessageCell.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var leftTopLabel: UILabel!
    @IBOutlet private weak var rightTopLabel: UILabel!
    
    static let identifier = "MessageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(for presentedCell: MessageCellPresenter, currentUser: User?) {
        
        messageLabel.text = presentedCell.messageLabel
        messageView.layer.cornerRadius = 20
        if currentUser?.email == presentedCell.sender.email {
            messageLabel.textAlignment = .right
            rightTopLabel.text = presentedCell.sender.username
            rightTopLabel.textAlignment = .right
            leftTopLabel.text = presentedCell.date
            rightImageView.isHidden = true
            messageView.backgroundColor = UIColor(named: "BrandLightBlue")
        }else {
            messageLabel.textAlignment = .left
            rightTopLabel.textAlignment = .right
            leftTopLabel.text = presentedCell.sender.username
            rightTopLabel.text = presentedCell.date
            leftImageView.isHidden = true
            messageView.backgroundColor = UIColor(named: "BrandLightPurple")
        }
    }
}
