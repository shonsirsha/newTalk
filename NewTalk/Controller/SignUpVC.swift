//
//  SignUpVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 16/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var unameStatusLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpBtn: RoundedRectBtn!

      let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._")
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.isHidden = true

        signUpBtn.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.768627451, blue: 0.4235294118, alpha: 1)
        signUpBtn.layer.cornerRadius = 25
        signUpBtn.layer.borderWidth = 0
        //signUpBtn.layer.borderColor = UIColor.black.cgColor
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                              attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.677764118, green: 0.677764118, blue: 0.677764118, alpha: 1)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)])
        unameField.attributedPlaceholder = NSAttributedString(string: "TalkID (only alphanumerics, . , and _)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.677764118, green: 0.677764118, blue: 0.677764118, alpha: 1)])
        

    }
    
    @IBAction func unameFieldChanged(_ sender: Any) {
        if (unameField.text?.count)! >= 4{
          
            if unameField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                signUpBtn.isHidden = true
                unameStatusLabel.text = "TalkID can't contain special character(s)"
                unameStatusLabel.textColor = #colorLiteral(red: 1, green: 0.150029252, blue: 0, alpha: 1)
            }else{
                signUpBtn.isHidden = false
                unameStatusLabel.text = "TalkID is valid"
                unameStatusLabel.textColor = #colorLiteral(red: 0.09620451182, green: 0.7700600028, blue: 0.4234673679, alpha: 1)
            }
        }else{
            signUpBtn.isHidden = true
            unameStatusLabel.text = "TalkID must at least be 4 characters long"
            unameStatusLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        unameStatusLabel.text = "Checking..."
        unameStatusLabel.textColor = #colorLiteral(red: 0.09620451182, green: 0.7700600028, blue: 0.4234673679, alpha: 1)
        DataService.instance.checkUname(talkId: unameField.text!) { (avail,_) in
            if avail{
                AuthService.instance.registerUser(email: self.emailField.text!, password: self.passwordField.text!, talkId: self.unameField.text!) { (success, signUpErr) in
                    if success{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print(String(describing: signUpErr?.localizedDescription))
                    }
                }
            }else{
                self.unameStatusLabel.text = "TalkID is already taken."
                self.unameStatusLabel.textColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
            }
        }
       /* */
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        unameField.resignFirstResponder()
    }
    
}
