//
//  BaseMessageHandler.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public protocol DemoMessageViewModelProtocol {
    var messageModel: DemoMessageModelProtocol { get }
}

class BaseMessageHandler {
    
    private let messageSender: DemoChatMessageSender
    private let messagesSelector: MessagesSelectorProtocol
    
    init(messageSender: DemoChatMessageSender, messagesSelector: MessagesSelectorProtocol) {
        self.messageSender = messageSender
        self.messagesSelector = messagesSelector
    }
    func userDidTapOnFailIcon(viewModel: DemoMessageViewModelProtocol) {
        print("userDidTapOnFailIcon")
        self.messageSender.sendMessage(viewModel.messageModel)
    }
    
    func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
        print("userDidTapOnAvatar")
    }
    
    func userDidTapOnBubble(viewModel: DemoMessageViewModelProtocol) {
        
        print("userDidTapOnBubble")
       
    }
    
    func userDidBeginLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
        print("userDidBeginLongPressOnBubble")
    }
    
    func userDidEndLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
        print("userDidEndLongPressOnBubble")
    }
    
    func userDidSelectMessage(viewModel: DemoMessageViewModelProtocol) {
        print("userDidSelectMessage")
        self.messagesSelector.selectMessage(viewModel.messageModel)
    }
    
    func userDidDeselectMessage(viewModel: DemoMessageViewModelProtocol) {
        print("userDidDeselectMessage")
        self.messagesSelector.deselectMessage(viewModel.messageModel)
    }
}
