//
//  DemoTextMessageModel.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import ChattoAdditions

public class DemoTextMessageModel: TextMessageModel<MessageModel>, DemoMessageModelProtocol {
    public override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }
    
    public var status: MessageStatus {
        get {
            return self._messageModel.status
        }
        set {
            self._messageModel.status = newValue
        }
    }
}
