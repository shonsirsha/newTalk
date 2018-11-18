//
//  AddFriendsVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 17/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//
import UIKit
import Firebase
class AddFriendsVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var friendStatusLabel: UILabel!
    @IBOutlet weak var bottomNibba: NSLayoutConstraint!
    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    var goingToAddUserId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        unameField.attributedPlaceholder = NSAttributedString(string: "Enter your friend's username",
                                                              attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)])
        addBtn.isHidden = true
        usernameLabel.isHidden = true
        friendStatusLabel.isHidden = true
        
        addBtn.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.768627451, blue: 0.4235294118, alpha: 1)
        addBtn.layer.cornerRadius = 20
        addBtn.layer.borderWidth = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddFriendsVC.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddFriendsVC.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
 
        // Do any additional setup after loading the view.
    }
  
    @objc func keyboardWillShow(sender: NSNotification) {
        let duration = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = sender.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (sender.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.searchBtn.frame.origin.y += deltaY
        }, completion: nil)
        bottomNibba.constant += deltaY
        print(deltaY)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let duration = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = sender.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (sender.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.searchBtn.frame.origin.y += deltaY
        }, completion: nil)
        bottomNibba.constant += deltaY
        print(deltaY)
    }
    @IBAction func searchBtnPressed(_ sender: Any) {
        self.addBtn.isHidden = true
        self.usernameLabel.text = "Searching..."
        self.usernameLabel.isHidden = false
        self.friendStatusLabel.isHidden = true
        DataService.instance.checkUname(talkId: unameField.text!) { (doesntExist, hisHerUid) in
            if !doesntExist{
                self.usernameLabel.text = self.unameField.text!
                DataService.instance.checkIfFriends(uid: (Auth.auth().currentUser?.uid)!, hisHerUid: hisHerUid, isFriend: { (isFriend) in
                    if isFriend{
                        self.friendStatusLabel.isHidden = false
                        self.friendStatusLabel.text = "is already your friend"
                    }else{
                        self.friendStatusLabel.isHighlighted = false
                        self.goingToAddUserId = hisHerUid
                        self.addBtn.isHidden = false
                    }
                })
            }else{
                self.usernameLabel.isHidden = true
                
                self.friendStatusLabel.isHidden = false
                self.friendStatusLabel.text = "TalkID can't be found"
            }
        }
    }
    @IBAction func addBtnPressed(_ sender: Any) {
        let userData = ["talkId": unameField.text!, "uid": goingToAddUserId, "notif": 0] as [String:Any]
        
        DataService.instance.addFriend(hisHerUid: goingToAddUserId, uid: (Auth.auth().currentUser?.uid)!, userData: userData)
        
        self.addBtn.isHidden = true
        friendStatusLabel.isHidden = false
        friendStatusLabel.text = "Added"

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unameField.resignFirstResponder()
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 
}



