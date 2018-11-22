//
//  EditProfileVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 22/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase



class EditProfileVC: UIViewController {
    var talkId = ""
    var displayName = ""
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var talkIdLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        talkIdLabel.text = "TalkID: \(talkId)"
        textField.text = displayName
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func doneBtnPressed(_ sender: Any) {
        if(textField.text != "" && textField.text!.count <= 20){
            doneBtn.setTitle("Loading...", for: UIControl.State.normal)
        DataService.instance.setDisplayName(uid: (Auth.auth().currentUser?.uid)!, displayName: textField.text!) { (isDone) in
            if isDone{
                self.dismiss(animated: true, completion: nil)
                self.doneBtn.setTitle("Done", for: UIControl.State.normal)
            }else{
              print("WTF")
            }
            }
        }
        
    }
}
