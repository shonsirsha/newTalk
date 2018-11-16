//
//  SignUpVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 16/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var signUpBtn: RoundedRectBtn!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.backgroundColor = #colorLiteral(red: 0.09997562319, green: 0.7700644732, blue: 0.4234674573, alpha: 1)
    signUpBtn.layer.cornerRadius = 25
        signUpBtn.layer.borderWidth = 0
        //signUpBtn.layer.borderColor = UIColor.black.cgColor


        // Do any additional setup after loading the view.
    }

}
