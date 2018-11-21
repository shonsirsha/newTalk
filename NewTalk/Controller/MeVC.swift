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
    
    var friendTalkIdsArray = [String]()
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
        DataService.instance.checkMyFriends(uid: (Auth.auth().currentUser?.uid)!) { (friendTalkIds) in
            self.friendTalkIdsArray = friendTalkIds
            self.tableView.reloadData()
            self.friendsLabel.text = "All friends (\(self.friendTalkIdsArray.count))"
            print(self.friendTalkIdsArray)
        }
    }
    
   
    
    @IBAction func unwindFromChatIndividualVC(unwindSegue: UIStoryboardSegue){
     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendTalkIdsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as? FriendsCell else{return UITableViewCell()}
        
        let talkId = friendTalkIdsArray[indexPath.row]
        
        cell.configureCell(talkId: talkId)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toChatIndividualVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ixPath = tableView.indexPathForSelectedRow{
            if segue.identifier == "toChatIndividualVC"{
                if let chatIndividualVC = segue.destination as? ChatIndividualVC {
                    chatIndividualVC.hisHerTalkId = friendTalkIdsArray[ixPath.row]
                }
            }
        }
    }
  
    
    
    

    
}
