//
//  RoundView.swift
//  NewTalk
//
//  Created by Sean Saoirse on 10/12/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

@IBDesignable
class RoundView: UIView {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
