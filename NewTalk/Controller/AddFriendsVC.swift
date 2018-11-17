//
//  AddFriendsVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 17/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class AddFriendsVC: UIViewController {

    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unameField.attributedPlaceholder = NSAttributedString(string: "Enter your friend's username",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchBtn.bindToKeyboard()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        DataService.instance.checkUname(talkId: unameField.text!) { (doesntExist, hisHerUid) in
            if !doesntExist{
                let userData = ["talkId": self.unameField.text!, "uid": hisHerUid, "notif": 0] as [String:Any]
                DataService.instance.addFriend(hisHerUid: hisHerUid, uid: (Auth.auth().currentUser?.uid)!, userData: userData)
            }else{
                print("ERROR")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBtn.resignFirstResponder()
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
