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
            print(self.friendTalkIdsArray)
        }
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
    
    
    @IBAction func testZ(_ sender: Any) {
        DataService.instance.checkMyFriends(uid: (Auth.auth().currentUser?.uid)!) { (friendTalkIds) in
            self.friendTalkIdsArray = friendTalkIds
            print(self.friendTalkIdsArray)
        }
    }
    
    

    
}
