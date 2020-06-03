//
//  Message.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    
    
    var fromId: String?
    var text : String?
    var timestamp : Int?
    var toId : String?
        
    func chatPatnerId() -> String? {
        return fromId == getUID() ? toId : fromId
    }
}
