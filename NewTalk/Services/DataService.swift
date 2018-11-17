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
    
    func checkUname(username: String, unameAvail: @escaping(_ status: Bool)->()){
        REF_USER.queryOrdered(byChild: "talkId").queryEqual(toValue: username).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                unameAvail(false)
            }else{
                unameAvail(true)
            }
        }
    }
    
}
