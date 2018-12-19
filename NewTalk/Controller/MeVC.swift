//
//  MeVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 17/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class MeVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var friendsUidArr = [String]()
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var friendsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer()) // to slide close open
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            DataService.instance.checkMyFriends(uid: (Auth.auth().currentUser?.uid)!) { (friendTalkIds) in
                self.friendsUidArr = friendTalkIds
                self.tableView.reloadData()
                self.friendsLabel.text = "All friends (\(self.friendsUidArr.count))"
                print("THIS IS \(friendTalkIds)")
                print(self.friendsUidArr)
            }
        }
    }
    
   
    
    @IBAction func unwindFromChatIndividualVC(unwindSegue: UIStoryboardSegue){
     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsUidArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as? FriendsCell else{return UITableViewCell()}
        
        let uid = friendsUidArr[indexPath.row]
        DataService.instance.getTalkId(uid: uid) { (returnedTalkId) in
            cell.configureCell(talkId: returnedTalkId)

        }

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toChatIndividualVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ixPath = tableView.indexPathForSelectedRow{
            if segue.identifier == "toChatIndividualVC"{
                if let chatIndividualVC = segue.destination as? ChatIndividualVC {
                    chatIndividualVC.hisHerUid = friendsUidArr[ixPath.row]
                }
            }
        }
    }
  
    
    
    

    
}
