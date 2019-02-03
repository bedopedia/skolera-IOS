//
//  BaseMessagesSelector.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public class BaseMessagesSelector: MessagesSelectorProtocol {
    
    public weak var delegate: MessagesSelectorDelegate?
    
    public var isActive = false {
        didSet {
            guard oldValue != self.isActive else { return }
            if self.isActive {
                self.selectedMessagesDictionary.removeAll()
            }
        }
    }
    
    public func canSelectMessage(_ message: MessageModelProtocol) -> Bool {
        return true
    }
    
    public func isMessageSelected(_ message: MessageModelProtocol) -> Bool {
        return self.selectedMessagesDictionary[message.uid] != nil
    }
    
    public func selectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = message
        self.delegate?.messagesSelector(self, didSelectMessage: message)
    }
    
    public func deselectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = nil
        self.delegate?.messagesSelector(self, didDeselectMessage: message)
    }
    
    public func selectedMessages() -> [MessageModelProtocol] {
        return Array(self.selectedMessagesDictionary.values)
    }
    
    // MARK: - Private
    
    private var selectedMessagesDictionary = [String: MessageModelProtocol]()
}
