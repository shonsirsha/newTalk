//
//  ChatIndividualVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 20/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase


var hasPicked = false
var currentVC = "chatIndividual"
class ChatIndividualVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    var hasOpened = false
    
    var hisHerTalkId: String = ""
    var hisHerUid: String = ""
    override var canBecomeFirstResponder: Bool{
        return true
    }
   var control = false
    @IBOutlet weak var btc: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    var customInputViewChat: UIView!

    var messagesArr = [MsgForCell]()
    var sendButton: UIButton!
    var addMediaButtom: UIButton!
    let textField = FlexibleTextView()
    override var inputAccessoryView: UIView?{
        if customInputViewChat == nil{
            customInputViewChat = CustomView()
            customInputViewChat.backgroundColor = UIColor.groupTableViewBackground
            textField.placeholder = "Type your message..."
            textField.font = .systemFont(ofSize: 15)
            textField.layer.cornerRadius = 17
            
            customInputViewChat.autoresizingMask = .flexibleHeight
            
            customInputViewChat.addSubview(textField)
            
            sendButton = UIButton(type: .system)
            sendButton.isEnabled = true
            sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            sendButton.setImage(UIImage(imageLiteralResourceName: "send").withRenderingMode(.alwaysTemplate), for: .normal)
            sendButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
            sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            customInputViewChat?.addSubview(sendButton)
            
            addMediaButtom = UIButton(type: .custom)
            addMediaButtom.setImage(UIImage(imageLiteralResourceName: "addImage").withRenderingMode(.alwaysTemplate), for: .normal)
            addMediaButtom.isEnabled = true
            //addMediaButtom.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            // addMediaButtom.setTitle("Media", for: .normal)
            addMediaButtom.contentEdgeInsets = UIEdgeInsets(top: 9, left: 0, bottom: 5, right: 0)
            addMediaButtom.addTarget(self, action: #selector(handleMediaSend), for: .touchUpInside)
            customInputViewChat?.addSubview(addMediaButtom)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            addMediaButtom.translatesAutoresizingMaskIntoConstraints = false
            sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            
            addMediaButtom.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            addMediaButtom.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            
            textField.maxHeight = 80
            
            addMediaButtom.leadingAnchor.constraint(
                equalTo: customInputViewChat.leadingAnchor,
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
                equalTo: customInputViewChat.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
            
            textField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor,
                constant: 0
                ).isActive = true
            
            textField.topAnchor.constraint(
                equalTo: customInputViewChat.topAnchor,
                constant: 8
                ).isActive = true
            
            textField.bottomAnchor.constraint(
                equalTo: customInputViewChat.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
            
            sendButton.leadingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: 0
                ).isActive = true
            
            sendButton.trailingAnchor.constraint(
                equalTo: customInputViewChat.trailingAnchor,
                constant: -8
                ).isActive = true
            
            sendButton.bottomAnchor.constraint(
                equalTo: customInputViewChat.layoutMarginsGuide.bottomAnchor,
                constant: -8
                ).isActive = true
            

        }
        
        return customInputViewChat
       
    }
    
 
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
       
        myTableView.estimatedRowHeight = 36
        myTableView.rowHeight = UITableView.automaticDimension
  
       myTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI));
        
        if hisHerUid != ""{
            DataService.instance.getDisplayName(uid: hisHerUid) { (returnedDisplayName) in
                self.nameLabel.text = returnedDisplayName
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatIndividualVC.keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatIndividualVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if hisHerTalkId != ""{
            DataService.instance.checkUname(talkId: hisHerTalkId) { (isNotFound, returnedHisHerUid) in
                if !isNotFound{
                    self.hisHerUid = returnedHisHerUid
                }else{
                    print("tf!")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if hisHerUid != ""{
            DataService.instance.getFullChat(uid: (Auth.auth().currentUser?.uid)!, hisHerUid: hisHerUid) { (returnedChatObj) in
                self.messagesArr = returnedChatObj
                self.myTableView.reloadData()
                        /*let lastSectionIndex = self.myTableView.numberOfSections - 1 // last section
                        let lastRowIndex = self.myTableView.numberOfRows(inSection: lastSectionIndex) - 1 // last row
                        self.myTableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: true)
                        self.myTableView.scrollIndicatorInsets = self.myTableView.contentInset*/
                
                
            }
            
            if hasPicked == true{
         
                performSegue(withIdentifier: "toSendPhotoVC", sender: Any?.self)
            }
        }
    }
    
    @IBAction func testBtn(_ sender: ChatIndividualVC) {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sendPhotoVC = segue.destination as? SendPhotoVC{
            sendPhotoVC.hisHerUid = hisHerUid
        }
    }
    
    @objc func handleSend() {
        if hisHerUid != ""{
            if self.textField.text != ""{
                DataService.instance.sendChat(uid: (Auth.auth().currentUser?.uid)!, hisHerUid: hisHerUid, message: textField.text!) { (sent) in
                    if sent{
                    }else{
                        print("Error")
                    }
                }
                self.textField.text = ""
            }
        }
    }
    
    @objc func handleMediaSend() {
        if hisHerUid != ""{
            let sourcePicker = UIAlertController()
            let takePhoto = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.presentPhotoPicker(sourceType: .camera)
                
            })
            
            let choosePhoto = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                self.presentPhotoPicker(sourceType: .photoLibrary)
            })
            
            sourcePicker.addAction(takePhoto)
            sourcePicker.addAction(choosePhoto)
            
            sourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(sourcePicker, animated: true, completion: nil)
        }
    }
    
    
 
  @objc func keyboardWillShow(_ notification:Notification) {
    
    var contentInsets:UIEdgeInsets
    print("FIRST!!!")
    print(myTableView.contentInset)
    var kbdHeight = 0.0
    
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            contentInsets = UIEdgeInsets(top: keyboardSize.height-10, left: 0.0, bottom: 0.0, right: 0.0);
            myTableView.contentInset = contentInsets
            kbdHeight = Double(keyboardSize.height-10)
            print(contentInsets)
            print(myTableView.contentInset)
            
            if messagesArr.count > 0{
                let topIndex = IndexPath(row: 0, section: 0)
                
                if (myTableView.contentOffset.y < 90){
                    myTableView.scrollToRow(at: topIndex, at: .top, animated: true)
                    myTableView.scrollIndicatorInsets = myTableView.contentInset
                }
            }
           
        }
    
    
    
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        var contentInsets:UIEdgeInsets
        print("FIRST!!!")
        print(myTableView.contentInset)
        
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0);
                myTableView.contentInset = contentInsets
                print(contentInsets)
                print(myTableView.contentInset)
                
                
                if messagesArr.count > 0 {
                    let topIndex = IndexPath(row: 0, section: 0)
                    myTableView.scrollIndicatorInsets = myTableView.contentInset
                }
                
                
            }
        
        

    }
    
 

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bubbleCell") as? ChatIndividualCell else {return UITableViewCell()}

        let chatObj = messagesArr[indexPath.row]

        let checkYear = DateFormatter()
        checkYear.dateFormat = "Y"
        
        let checkMonthYear = DateFormatter()
        checkMonthYear.dateFormat = "MMM Y"
        
        let checkDay = DateFormatter()
        checkDay.dateFormat = "EE dd M yy"
        
        let checkDateOfDay = DateFormatter()
        checkDateOfDay.dateFormat = "dd"
        
        let todayEpoch = NSDate().timeIntervalSince1970
        let todayEpochAsDate = NSDate(timeIntervalSince1970: todayEpoch)
        let todayYear = checkYear.string(from: todayEpochAsDate as Date)
        let todayMonthYear = checkMonthYear.string(from: todayEpochAsDate as Date)
        let todayDate = checkDay.string(from: todayEpochAsDate as Date)
        let todayDateOfDay = Int(checkDateOfDay.string(from: todayEpochAsDate as Date))
        
        let date = NSDate(timeIntervalSince1970: chatObj.time)
        let chatTimeFormat = DateFormatter()
        let chatYear = checkYear.string(from: date as Date)
        let chatMonthYear = checkMonthYear.string(from: date as Date)
        let chatDay = checkDay.string(from: date as Date)
        let chatDateOfDay = Int(checkDateOfDay.string(from: date as Date))
        
        if chatObj.talkWith == (Auth.auth().currentUser?.uid)!{ //talkwith here is "from"
        
            
            cell.outgoingLabel.isHidden = false
            cell.outgoingTimeLabel.isHidden = false
            
            cell.incomingTimeLabel.isHidden = true
            cell.incomingLabel.isHidden = true
            
            cell.outgoingLabel.text = chatObj.content
            
            if chatYear == todayYear{//this year
                if chatMonthYear == todayMonthYear { // this month
                    chatTimeFormat.dateFormat = "HH:mm"
                    cell.outgoingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
                    if chatDay == todayDate{ // today
                        
                    }else if todayDateOfDay! - chatDateOfDay! == 1{ // yesterday
                        chatTimeFormat.dateFormat = "HH:mm"
                        cell.outgoingTimeLabel.text = "Yesterday, \(chatTimeFormat.string(from: date as Date))"

                    }else{ // any other day
                        chatTimeFormat.dateFormat = "dd MMM, HH:mm"
                        cell.outgoingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
                    }
                }else{ // different month
                    chatTimeFormat.dateFormat = "EE dd MMM, HH:mm"
                    cell.outgoingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
                }
            }else{//different year
                chatTimeFormat.dateFormat = "EE dd MMM, HH:mm yyyy"
                cell.outgoingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
            }
            
            
        }else{
            
            cell.incomingTimeLabel.isHidden = false
            cell.incomingLabel.isHidden = false
            
            cell.outgoingTimeLabel.isHidden = true
            cell.outgoingLabel.isHidden = true

            cell.incomingLabel.text = chatObj.content
            
            
            if chatYear == todayYear{//this year
                if chatMonthYear == todayMonthYear { // this month
                    chatTimeFormat.dateFormat = "HH:mm"
                    cell.incomingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
                    if chatDay == todayDate{ // today
                        
                    }else if todayDateOfDay! - chatDateOfDay! == 1{ // yesterday
                        chatTimeFormat.dateFormat = "HH:mm"
                        cell.incomingTimeLabel.text = "Yesterday, \(chatTimeFormat.string(from: date as Date))"
                        
                    }else{ // any other day
                        chatTimeFormat.dateFormat = "dd MMM, HH:mm"
                        cell.incomingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
                    }
                }else{ // different month
                    chatTimeFormat.dateFormat = "EE dd MMM, HH:mm"
                    cell.incomingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
                }
            }else{//different year
                chatTimeFormat.dateFormat = "EE dd MMM, HH:mm yyyy"
                cell.incomingTimeLabel.text = "\(chatTimeFormat.string(from: date as Date))"
            }

        }
        
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        
        return cell
        
    }
    @IBAction func backBtnPRessed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        myTableView.setContentOffset(CGPoint(x:0, y:textField.center.y-50), animated: true)
    }
    
    class CustomView: UIView {
        
        // this is needed so that the inputAccesoryView is properly sized from the auto layout constraints
        // actual value is not important
        
        override var intrinsicContentSize: CGSize {
            return CGSize.zero
        }
    }
    
    
    
}

extension ChatIndividualVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {fatalError("No image returned...")}

        myImage = image
    
        picker.dismiss(animated: true, completion: nil)

        hasPicked = true
    
    if hasPicked == true{
        performSegue(withIdentifier: "toSendPhotoVC", sender: self)
        print("AAAA")

    }

    
    }
}

