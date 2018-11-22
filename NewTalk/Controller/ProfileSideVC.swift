//
//  ProfileSideVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 20/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class ProfileSideVC: UIViewController {
    @IBOutlet weak var myProfileBtn: UIButton!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var talkIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
                
        myProfileBtn.backgroundColor = #colorLiteral(red: 0, green: 0.6666666667, blue: 0.7764705882, alpha: 1)
        myProfileBtn.layer.cornerRadius = 20
        myProfileBtn.layer.borderWidth = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            DataService.instance.getTalkId(uid: (Auth.auth().currentUser?.uid)!) { (returnedTalkId) in
                self.talkIdLabel.text = returnedTalkId
            }
            
            DataService.instance.getDisplayName(uid: (Auth.auth().currentUser?.uid)!) { (returnedDisplayName) in
                self.displayNameLabel.text = returnedDisplayName
            }

        }
    }

    @IBAction func logOutBtnPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
            self.present(authVC!, animated: true, completion: nil)
        }catch{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProfile"{
            if let editProfileVC = segue.destination as? EditProfileVC{
                editProfileVC.displayName = displayNameLabel.text!
                editProfileVC.talkId = talkIdLabel.text!
            }
        }
    }
    
    
    
    @IBAction func toProfileBtnPressed(_ sender: Any) {
        if(displayNameLabel.text != "" && talkIdLabel.text != ""){
            performSegue(withIdentifier: "toEditProfile", sender: self)
        }
    }
    
    
    
    
}
