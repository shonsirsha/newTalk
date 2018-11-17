//
//  LoginVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 16/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginStatusLabel: UILabel!
    @IBOutlet weak var loginBtn: RoundedRectBtn!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
       loginStatusLabel.isHidden = true
        loginBtn.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.768627451, blue: 0.4235294118, alpha: 1)
        loginBtn.layer.cornerRadius = 25
        loginBtn.layer.borderWidth = 0
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        AuthService.instance.loginUser(email: emailField.text!, password: passwordField.text!) { (success, loginErr) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }else{
                self.loginStatusLabel.isHidden = false
                print(String(describing: loginErr?.localizedDescription))
            }
        }
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    
    @IBAction func passwordFieldwasClicked(_ sender: Any) {
    }

    
}
