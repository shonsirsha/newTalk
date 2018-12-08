//
//  ChatIndividualCell.swift
//  NewTalk
//
//  Created by Sean Saoirse on 23/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit

class ChatIndividualCell: UITableViewCell {

    @IBOutlet weak var outgoingLabel: PaddingLabel!
    @IBOutlet weak var incomingLabel: PaddingLabel!
    @IBOutlet weak var incomingTimeLabel: UILabel!
    @IBOutlet weak var outgoingTimeLabel: UILabel!
    @IBOutlet weak var outgoingImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var radius: CGFloat
        radius = (incomingLabel?.bounds.size.height)! / 3.5
        incomingLabel?.layer.cornerRadius = radius
        incomingLabel?.layer.masksToBounds = true
        
        radius = (outgoingLabel?.bounds.size.height)! / 3.5
        outgoingLabel?.layer.cornerRadius = radius
        outgoingLabel?.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
