//
//  ChannelsTableViewCell.swift
//  DB2-chat
//
//  Created by Alexander Slobodjanjuk on 01.07.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import UIKit
import SWTableViewCell

class ChannelsTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var unreadMessagesCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.size.height)!/2
        avatarImageView?.layer.masksToBounds = true

        unreadMessagesCountLabel.layer.masksToBounds = true
        unreadMessagesCountLabel.layer.cornerRadius = 11
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}
