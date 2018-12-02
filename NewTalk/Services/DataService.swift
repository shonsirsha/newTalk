//
//  DataService.swift
//  NewTalk
//
//  Created by Sean Saoirse on 17/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import Foundation
import Firebase
let DB_BASE = Database.database().reference()
class DataService{
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("users")
    
    
    var REF_BASE:DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USER:DatabaseReference{
        return _REF_USER
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
            guard let friendsObject = friendsObject.children.allObjects as? [DataSnapshot] else {return}
            
            for friendsUid in friendsObject{
                let theirUid = friendsUid.childSnapshot(forPath: "uid").value as! String
                
                friendsArr.insert(theirUid, at: 0)
            }
            
            
            handler(friendsArr)
            friendsArr = [String]()
           
        }
    }

    func sendChat(uid: String, hisHerUid: String, message: String , isSent: @escaping(_ status: Bool)->()){
        REF_USER.child(uid).child("chat").child(hisHerUid).childByAutoId().updateChildValues(["from":uid, "to":hisHerUid, "message": message,"time":NSDate().timeIntervalSince1970])
        
        REF_USER.child(uid).child("recentchat").child(hisHerUid).updateChildValues(["with":hisHerUid, "message": message , "time":NSDate().timeIntervalSince1970])
        
        REF_USER.child(hisHerUid).child("chat").child(uid).childByAutoId().updateChildValues(["from":uid, "to":hisHerUid, "message": message,"time":NSDate().timeIntervalSince1970])
        
        REF_USER.child(hisHerUid).child("recentchat").child(uid).updateChildValues(["with":uid, "message": message, "time":NSDate().timeIntervalSince1970])
    }
    
    func getAllMyChats(uid: String, handler: @escaping(_ chatObj: [MsgForCell])->()){
        var chatObjArr = [MsgForCell]()
        
        REF_USER.child(uid).child("recentchat").queryOrdered(byChild: "time").observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for chat in snapshot{
                let msg = chat.childSnapshot(forPath: "message").value as! String
                let time = chat.childSnapshot(forPath: "time").value as! Double
                let with = chat.childSnapshot(forPath: "with").value as! String
                
                
                let message = MsgForCell(talkWith: with, content: msg, time: time)
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
                
                let message = MsgForCell(talkWith: from, content: msg, time: time)
                chatObjArr.insert(message, at: 0)
            }
            
            handler(chatObjArr.reversed())
            chatObjArr = [MsgForCell]()
            
        }
    }
    
 
}
    
    
    
    /*func checkIfFriends(username: String, itsFriend: @escaping(_ status: Bool)->()){
        REF_USER.queryOrdered(byChild: "friends").queryEqual(toValue: username)
    }*/
    

