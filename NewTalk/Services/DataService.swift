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
    
    func addFriend(hisHerUid: String, uid: String, userData: Dictionary<String, Any>){
    REF_USER.child(uid).child("friends").child(hisHerUid).updateChildValues(userData)
    }
    
    
    
    /*func checkIfFriends(username: String, itsFriend: @escaping(_ status: Bool)->()){
        REF_USER.queryOrdered(byChild: "friends").queryEqual(toValue: username)
    }*/
    
}
