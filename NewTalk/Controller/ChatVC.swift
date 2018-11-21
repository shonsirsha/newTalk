//
//  ChatVC.swift
//  NewTalk
//
//  Created by Sean Saoirse on 20/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class ChatVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
 
    
    var messagesArr = [MsgForCell]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
   

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllMyChats(uid: (Auth.auth().currentUser?.uid)!) { (returnedArr) in
            self.messagesArr = returnedArr
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as? ChatCell else {return UITableViewCell()}


        let recentChatsObj = messagesArr[indexPath.row]
        cell.configureCell(name: recentChatsObj.talkWith, message: recentChatsObj.content)
        return cell
    }
    
    


}
