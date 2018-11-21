//
//  ChatIndividualVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 20/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class ChatIndividualVC: UIViewController {
    var hisHerTalkId: String = ""
    var hisHerUid: String = ""

    @IBOutlet weak var btmConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatIndividualVC.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatIndividualVC.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        DataService.instance.checkUname(talkId: hisHerTalkId) { (isNotFound, returnedHisHerUid) in
            if !isNotFound{
                self.hisHerUid = returnedHisHerUid
            }else{
                print("tf!")
            }
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let duration = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = sender.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (sender.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.bottomView.frame.origin.y += deltaY
        }, completion: nil)
        btmConstraint.constant += deltaY
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let duration = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = sender.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (sender.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.bottomView.frame.origin.y += deltaY
        }, completion: nil)
        btmConstraint.constant += deltaY
    }
    
    @IBAction func btnSendPressed(_ sender: Any) {
        if hisHerUid != ""{
            if textField.text != ""{
                DataService.instance.sendChat(uid: (Auth.auth().currentUser?.uid)!, hisHerUid: hisHerUid, message: textField.text!) { (sent) in
                    if sent{
                    }else{
                        print("Error")
                    }
                }
                textField.text = ""
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatTextView.resignFirstResponder()
    }

}
