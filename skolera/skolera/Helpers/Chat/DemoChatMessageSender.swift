//
//  DemoChatMessageSender.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public protocol DemoMessageModelProtocol: MessageModelProtocol {
    var status: MessageStatus { get set }
}

public class DemoChatMessageSender {
    
    public var onMessageChanged: ((_ message: DemoMessageModelProtocol) -> Void)?
    
    public func sendMessages(_ messages: [DemoMessageModelProtocol]) {
        for message in messages {
            self.fakeMessageStatus(message)
        }
    }
    
    public func sendMessage(_ message: DemoMessageModelProtocol) {
        self.updateMessage(message, status: .success)
//        self.fakeMessageStatus(message)
    }
    
    private func fakeMessageStatus(_ message: DemoMessageModelProtocol) {
        switch message.status {
        case .success:
            break
        case .failed:
            self.updateMessage(message, status: .sending)
            self.fakeMessageStatus(message)
        case .sending:
            switch arc4random_uniform(100) % 5 {
            case 0:
                if arc4random_uniform(100) % 2 == 0 {
                    self.updateMessage(message, status: .failed)
                } else {
                    self.updateMessage(message, status: .success)
                }
            default:
                let delaySeconds: Double = Double(arc4random_uniform(1200)) / 1000.0
                let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.fakeMessageStatus(message)
                }
            }
        }
    }
    
    private func updateMessage(_ message: DemoMessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }
    
    private func notifyMessageChanged(_ message: DemoMessageModelProtocol) {
        self.onMessageChanged?(message)
    }
}
