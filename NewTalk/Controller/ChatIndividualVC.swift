//
//  ChatIndividualVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 20/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class ChatIndividualVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
  
   /* var msgs = ["Hi", "Wassup","Yo", "Nuttin", "Nuttin Asd asd asd asd asd asd <3 hahahaha FUCK YOO BICHAS NIGGA MANE","Hi my name is sean saoirse loolll im from indonesia BRUDAA WOOOO asdasd asdasd asdasds asdasd asdas dasd asdasd", "hahahaha FUCK YOO BICHAS NIGGA MANE","Hi my name is sean saoirse loolll im from indonesia BRUDAA WOOOO asdasd asdasd asdasds asdasd asdas dasd asdasd"]
    
    var msgs2 = ["Hi", "Wassup","Yo", "Nuttin", "Nuttin Asd asd asd asd asd asd <3 hahahaha FUCK YOO BICHAS NIGGA MANE","Hi my name is sean saoirse loolll im from indonesia BRUDAA WOOOO asdasd asdasd asdasds asdasd asdas dasd asdasd", "hahahaha FUCK YOO BICHAS NIGGA MANE","Hi my name is sean saoirse loolll im from indonesia BRUDAA WOOOO asdasd asdasd asdasds asdasd asdas dasd asdasd"]*/
    
    
    var hisHerTalkId: String = ""
    var hisHerUid: String = ""

   
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btmConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    var messagesArr = [MsgForCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableView.automaticDimension
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatIndividualVC.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatIndividualVC.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if hisHerUid != ""{
            DataService.instance.getDisplayName(uid: hisHerUid) { (returnedDisplayName) in
                self.nameLabel.text = returnedDisplayName
            }
        }
        
        
        
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
                self.tableView.reloadData()
                self.scrollToBottom()

            }
        }
        

        
    }
    
   
    
    @IBAction func btnSendPressed(_ sender: Any) {
        if hisHerUid != ""{
            if textField.text != ""{
                DataService.instance.sendChat(uid: (Auth.auth().currentUser?.uid)!, hisHerUid: hisHerUid, message: textField.text!) { (sent) in
                    if sent{
                    }else{
                        print("Error")
                    }
                }
                textField.text = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bubbleCell") as? ChatIndividualCell else {return UITableViewCell()}
        
        let chatObj = messagesArr[indexPath.row]
        
        if chatObj.talkWith == (Auth.auth().currentUser?.uid)!{ //talkwith here is "from"
            
            cell.outgoingLabel.isHidden = false
            cell.incomingLabel.isHidden = true
            
            cell.outgoingLabel.text = chatObj.content
        }else{
            cell.outgoingLabel.isHidden = true
            cell.incomingLabel.isHidden = false
            
            cell.incomingLabel.text = chatObj.content
        }
       
        
        return cell
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        
        
        let duration = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = sender.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (sender.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.bottomView.frame.origin.y += deltaY
        }, completion: nil)
       
        btmConstraint.constant += deltaY
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        
       
        let duration = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = sender.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (sender.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.bottomView.frame.origin.y += deltaY
        }, completion: nil)
        
       
        
        btmConstraint.constant += deltaY
    }
    
   
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messagesArr.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatTextView.resignFirstResponder()
    }

}
