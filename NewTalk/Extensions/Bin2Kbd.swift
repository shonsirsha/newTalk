//
//  Bin2Kbd.swift
//  NewTalk
//
//  Created by Sean Saoirse on 17/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
extension UIView{
    func bin2kbd(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillChange(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func unbin2kbd(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc
    func keyboardWillChange(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y+=deltaY
            
        },completion: nil)
        
    }
}
