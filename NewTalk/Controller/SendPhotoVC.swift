//
//  SendPhotoVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 28/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
var myImage: UIImage!

class SendPhotoVC: UIViewController,UITextViewDelegate {
    @IBOutlet weak var imageViewHorizontal: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    var sendButton: UIButton!
    var addMediaButtom: UIButton!
    var customInputView: UIView!
    let textField = FlexibleTextView()
    
    override var inputAccessoryView: UIView?{
        if customInputView == nil{
            customInputView = CustomView()
            customInputView.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.0)
            textField.placeholder = "Add a caption..."
            textField.font = .systemFont(ofSize: 15)
            textField.layer.cornerRadius = 17
            
            customInputView.autoresizingMask = .flexibleHeight
            
            customInputView.addSubview(textField)
            
            sendButton = UIButton(type: .system)
            sendButton.isEnabled = true
            sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            sendButton.setImage(UIImage(imageLiteralResourceName: "send").withRenderingMode(.alwaysTemplate), for: .normal)
            sendButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
            sendButton.addTarget(self, action: #selector(handleSendPhoto), for: .touchUpInside)
            customInputView?.addSubview(sendButton)
            
            addMediaButtom = UIButton(type: .custom)
            addMediaButtom.setImage(UIImage(imageLiteralResourceName: "addImage").withRenderingMode(.alwaysTemplate), for: .normal)
            addMediaButtom.isEnabled = true
            //addMediaButtom.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            // addMediaButtom.setTitle("Media", for: .normal)
            addMediaButtom.contentEdgeInsets = UIEdgeInsets(top: 9, left: 0, bottom: 5, right: 0)
            addMediaButtom.addTarget(self, action: #selector(handleMultPhoto), for: .touchUpInside)
            customInputView?.addSubview(addMediaButtom)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            addMediaButtom.translatesAutoresizingMaskIntoConstraints = false
            sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            
            addMediaButtom.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            addMediaButtom.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            
            textField.maxHeight = 80
            
            addMediaButtom.leadingAnchor.constraint(
                equalTo: customInputView.leadingAnchor,
                constant: 8
                ).isActive = true
            
            addMediaButtom.trailingAnchor.constraint(
                equalTo: textField.leadingAnchor,
                constant: -8
                ).isActive = true
            
            /*  addMediaButtom.topAnchor.constraint(
             equalTo: customInputView.topAnchor,
             constant: 8
             ).isActive = true
             */
            addMediaButtom.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
            
            textField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor,
                constant: 0
                ).isActive = true
            
            textField.topAnchor.constraint(
                equalTo: customInputView.topAnchor,
                constant: 8
                ).isActive = true
            
            textField.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
            
            sendButton.leadingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: 0
                ).isActive = true
            
            sendButton.trailingAnchor.constraint(
                equalTo: customInputView.trailingAnchor,
                constant: -8
                ).isActive = true
            
            sendButton.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
        }
        return customInputView
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("AAAA")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resignFirstResponder()
        hasPicked = false
        imageViewHorizontal.image = myImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    @objc func handleSendPhoto() {
       print("SABIII")
    }
    
    @objc func handleMultPhoto() {
        print("SAdasdsd")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    class CustomView: UIView {
        // this is needed so that the inputAccesoryView is properly sized from the auto layout constraints
        // actual value is not important
        override var intrinsicContentSize: CGSize {
            return CGSize.zero
        }
    }

    
}
