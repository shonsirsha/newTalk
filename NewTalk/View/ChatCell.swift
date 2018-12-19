//
//  ChatCell.swift
//  NewTalk
//
//  Created by Sean Saoirse on 20/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var notifBullet: RoundView!
    
    func configureCell(name: String, message: String, numOfNotif: Int){
        self.nameLabel.text = name
        self.chatLabel.text = message
        
        if numOfNotif > 0 {
            notifBullet.isHidden = false
        }else{
            notifBullet.isHidden = true
        }
        
        
    }
    
}
