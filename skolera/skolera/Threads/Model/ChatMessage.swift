//
//  ChatMessage.swift
//  skolera
//
//  Created by Salma Medhat on 6/30/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class ChatMessage {
    
    var content: String
    let messageTime: Int
    let senderId: String
    let type: String
    
    
    init(_ dic: [String: Any]) {
        content = dic["content"] as! String
        messageTime = dic["message_time"] as! Int
        senderId = dic["sender_id"] as! String
        type = dic["type"] as! String
    }    
}
