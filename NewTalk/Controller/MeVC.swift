//
//  MeVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 17/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class MeVC: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer()) // to slide close open
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
            self.present(authVC!, animated: true, completion: nil)
        }catch{
            print(error)
        }
    }
    

    
}
