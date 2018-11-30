//
//  BaseTableView.swift
//  NewTalk
//
//  Created by Sean Saoirse on 24/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.endEditing(true)
    }
}
