//
//  MsgForCell.swift
//  NewTalk
//
//  Created by Sean Saoirse on 21/11/18.
//  Copyright © 2018 Sean Saoirse. All rights reserved.
//

import Foundation

class MsgForCell{
    private var _talkWith: String
    private var _content: String
    private var _time: Double
    
    var content: String{
        return _content
    }
    
    var talkWith: String{
        return _talkWith
    }
    
    var time: Double{
        return _time
    }
    
    
    init(talkWith: String, content: String, time: Double){
        self._talkWith = talkWith
        self._content = content
        self._time = time
    }
}
