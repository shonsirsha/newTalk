//
//  FriendsCell.swift
//  NewTalk
//
//  Created by Sean Saoirse on 20/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {

    
    @IBOutlet weak var talkIdLabel: UILabel!
    
    func configureCell(talkId: String){
        self.talkIdLabel.text = talkId
    }
    
}
