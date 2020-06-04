//
//  Message.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Message: Hashable {
   // var id : String
    var fromId: String?
    var text : String?
    var timestamp : Int?
    var toId : String?
    
    var id : String {
        if fromId == getUID(){
            return toId!
        } else {
            return fromId!
        }
    }
        
    func chatPatnerId() -> String? {
        return fromId == getUID() ? toId : fromId
    }
}
