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

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}
