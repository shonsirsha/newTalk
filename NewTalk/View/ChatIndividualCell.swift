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
    @IBOutlet weak var imagePeekLabelIncoming: PaddingLabel!
    @IBOutlet weak var imagePeekLabel: PaddingLabel!
    @IBOutlet weak var incomingTimeLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var outgoingTimeLabelForPeek: UILabel!
    @IBOutlet weak var incomingTimeLabelForPeek: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        var radius: CGFloat
        radius = (incomingLabel?.bounds.size.height)! / 3.5
        incomingLabel?.layer.cornerRadius = radius
        incomingLabel?.layer.masksToBounds = true
        
        radius = (outgoingLabel?.bounds.size.height)! / 3.5
        outgoingLabel?.layer.cornerRadius = radius
        outgoingLabel?.layer.masksToBounds = true
        
        radius = (imagePeekLabel?.bounds.size.height)! / 5
        imagePeekLabel?.layer.cornerRadius = radius
        imagePeekLabel?.layer.masksToBounds = true
        
        radius = (imagePeekLabelIncoming?.bounds.size.height)! / 5
        imagePeekLabelIncoming?.layer.cornerRadius = radius
        imagePeekLabelIncoming?.layer.masksToBounds = true
        

    }


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

