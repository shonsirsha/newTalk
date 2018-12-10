//
//  DataService.swift
//  NewTalk
//
//  Created by Sean Saoirse on 17/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

let DB_BASE = Database.database().reference()
let STORAGE = Storage.storage().reference()
class DataService{
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("users")
    private var _REF_STORAGE = STORAGE
    
    var REF_BASE:DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USER:DatabaseReference{
        return _REF_USER
    }
    
    var REF_STORAGE: StorageReference{
        return _REF_STORAGE
    }

    
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USER.child(uid).updateChildValues(userData)
    }
    
    func checkUname(talkId: String, unameAvail: @escaping(_ status: Bool, _ hisHerUid: String)->()){
        REF_USER.queryOrdered(byChild: "talkId").queryEqual(toValue: talkId).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                var hisHerUid = ""
                guard let zx = snapshot.children.allObjects as? [DataSnapshot] else{return}
                for user in zx{
                    hisHerUid = user.childSnapshot(forPath: "uid").value as! String
                }
                unameAvail(false,hisHerUid)
            }else{
                unameAvail(true,"")
            }
        }
    }
    
    func addFriend(hisHerUid: String, uid: String, userData: Dictionary<String, Any>, myData: Dictionary<String, Any>){
    REF_USER.child(uid).child("friends").child(hisHerUid).updateChildValues(userData)
        
    REF_USER.child(hisHerUid).child("friends").child(uid).updateChildValues(myData)
    }
    
    func checkIfFriends(uid: String, hisHerUid: String, isFriend: @escaping(_ status: Bool)->()){
        REF_USER.child(uid).child("friends").queryOrdered(byChild: "uid").queryEqual(toValue: hisHerUid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                isFriend(true)
            }else{
                isFriend(false)
            }
        }
    }
    
    func checkMyFriends(uid: String, handler: @escaping(_ friends: [String])->()){
        var friendsArr = [String]()
        REF_USER.child(uid).child("friends").observe(DataEventType.value) { (friendsObject) in
            if friendsObject.exists(){
                guard let friendsObject = friendsObject.children.allObjects as? [DataSnapshot] else {return}
                
                for friendsUid in friendsObject{
                    let theirUid = friendsUid.childSnapshot(forPath: "uid").value as! String
                    
                    friendsArr.insert(theirUid, at: 0)
                }
                
                
                handler(friendsArr)
                friendsArr = [String]()
            }else{
                return
            }
           
        }
    }

    func sendChat(uid: String, hisHerUid: String, message: String , isSent: @escaping(_ status: Bool)->()){
        REF_USER.child(uid).child("chat").child(hisHerUid).childByAutoId().updateChildValues(["from":uid, "to":hisHerUid, "message": message,"isPic": "false", "title":"" ,"time":NSDate().timeIntervalSince1970])
        
        REF_USER.child(uid).child("recentchat").child(hisHerUid).updateChildValues(["with":hisHerUid, "message": message ,"isPic": "false", "title":"" ,"time":NSDate().timeIntervalSince1970])
        
        REF_USER.child(hisHerUid).child("chat").child(uid).childByAutoId().updateChildValues(["from":uid, "to":hisHerUid, "message": message,"isPic": "false", "title":"" ,"time":NSDate().timeIntervalSince1970])
        
        REF_USER.child(hisHerUid).child("recentchat").child(uid).updateChildValues(["with":uid, "message": message,"isPic": "false", "title": "" ,"time":NSDate().timeIntervalSince1970])
        
        REF_USER.child(hisHerUid).child("friends").child(uid).queryOrdered(byChild: "notif").observeSingleEvent(of: DataEventType.value, with: { (userObj) in
            guard let me = userObj.children.allObjects as? [DataSnapshot] else {return}
            var myNotif = 0
            for x in me{
                if x.key == "notif"{
                    myNotif = x.value as! Int
                }
            }
            self.REF_USER.child(hisHerUid).child("friends").child(uid).updateChildValues(["notif":myNotif+1])
        })
    }
    
    func getAllMyChats(uid: String, handler: @escaping(_ chatObj: [MsgForCell])->()){
        var chatObjArr = [MsgForCell]()
        
        REF_USER.child(uid).child("recentchat").queryOrdered(byChild: "time").observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for chat in snapshot{
                let msg = chat.childSnapshot(forPath: "message").value as! String
                let time = chat.childSnapshot(forPath: "time").value as! Double
                let with = chat.childSnapshot(forPath: "with").value as! String
                let isPic = chat.childSnapshot(forPath: "isPic").value as! String
                let title = chat.childSnapshot(forPath: "title").value as! String
                
                let message = MsgForCell(talkWith: with, content: msg, time: time, isPic: isPic, title: title)
                chatObjArr.insert(message, at: 0)
            }
           
            handler(chatObjArr)
            chatObjArr = [MsgForCell]()
            
        }
    }
    
    func getTalkId(uid: String, myTalkId: @escaping(_ talkId: String)->()){
        REF_USER.observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else{return}
            for user in snapshot{
                if user.key == uid{
                    myTalkId(user.childSnapshot(forPath: "talkId").value as! String)
                }
            }
            
        }
        }
    
    func getDisplayName(uid: String, myDisplayName: @escaping(_ displayName: String)->()){
        REF_USER.observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else{return}
            for user in snapshot{
                if user.key == uid{
                    myDisplayName(user.childSnapshot(forPath: "displayName").value as! String)
                }
            }
            
        }
    }
    
    func setDisplayName(uid: String, displayName: String,isDone: @escaping(_ status: Bool)->()){
        REF_USER.child(uid).updateChildValues(["displayName": displayName]) { (err, DatabaseReference) in
            if err==nil{
                isDone(true)
            }else{
                isDone(false)
                print(String(describing:err))
            }
        }
    }
    
    func getFullChat(uid: String, hisHerUid: String, handler: @escaping(_ chatObj: [MsgForCell])->()){
        
        var chatObjArr = [MsgForCell]()
        REF_USER.child(uid).child("chat").child(hisHerUid).queryOrdered(byChild: "time").observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for chat in snapshot{
                let from = chat.childSnapshot(forPath: "from").value as! String
                let msg = chat.childSnapshot(forPath: "message").value as! String
                let time = chat.childSnapshot(forPath: "time").value as! Double
                let isPic = chat.childSnapshot(forPath: "isPic").value as! String
                let title = chat.childSnapshot(forPath: "title").value as! String
                
                let message = MsgForCell(talkWith: from, content: msg, time: time, isPic: isPic, title: title)
                chatObjArr.insert(message, at: 0)
            }
            
            handler(chatObjArr)
            chatObjArr = [MsgForCell]()
            
        }
    }
    
    func uploadImageChat(uid: String, hisHerUid: String, image: NSData, caption: String, handler: @escaping(_ status: Bool)->()){
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        let title = "\(NSDate().timeIntervalSince1970)"
        let uploadTask = REF_STORAGE.child("chat").child(title).putData(image as Data, metadata: uploadMetaData) { (metadata, error) in
            if error != nil{
                print("Error \(String(describing: error?.localizedDescription))")
                handler(false)
            }else{
                print("Upload complete! Here's some metadata \(String(describing: metadata))")
                self.REF_USER.child(uid).child("chat").child(hisHerUid).childByAutoId().updateChildValues(["from":uid, "to":hisHerUid, "title": title, "isPic": "true", "message": caption ,"time":NSDate().timeIntervalSince1970])
                
                self.REF_USER.child(uid).child("recentchat").child(hisHerUid).updateChildValues(["with":hisHerUid, "title": title, "isPic": "true","message": caption,"time":NSDate().timeIntervalSince1970])
                
                self.REF_USER.child(hisHerUid).child("chat").child(uid).childByAutoId().updateChildValues(["from":uid, "to":hisHerUid, "title": title, "isPic": "true","message": caption,"time":NSDate().timeIntervalSince1970])
                
                self.REF_USER.child(hisHerUid).child("recentchat").child(uid).updateChildValues(["with":uid,"title": title,"isPic": "true","message": caption,"time":NSDate().timeIntervalSince1970])
                
                
                    self.REF_USER.child(hisHerUid).child("friends").child(uid).queryOrdered(byChild: "notif").observeSingleEvent(of: DataEventType.value, with: { (userObj) in
                    guard let me = userObj.children.allObjects as? [DataSnapshot] else {return}
                    var myNotif = 0
                    for x in me{
                        if x.key == "notif"{
                            myNotif = x.value as! Int
                        }
                    }
                    self.REF_USER.child(hisHerUid).child("friends").child(uid).updateChildValues(["notif":myNotif+1])
                    })
                handler(true)
            }
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else {return}
            print(Float(progress.fractionCompleted))
        }
 
}
    /*func checkIfFriends(username: String, itsFriend: @escaping(_ status: Bool)->()){
     REF_USER.queryOrdered(byChild: "friends").queryEqual(toValue: username)
     }*/
    
}
    
    
    


