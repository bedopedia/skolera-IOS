//
//  DemoTextMessageHandler.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import ChattoAdditions

class DemoTextMessageHandler: BaseMessageInteractionHandlerProtocol {
    private let baseHandler: BaseMessageHandler
    init (baseHandler: BaseMessageHandler) {
        self.baseHandler = baseHandler
    }
    
    func userDidTapOnFailIcon(viewModel: DemoTextMessageViewModel, failIconView: UIView) {
        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }
    
    func userDidTapOnAvatar(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }
    
    func userDidTapOnBubble(viewModel: DemoTextMessageViewModel) {
//        self.baseHandler.userDidTapOnBubble(viewModel: viewModel)
    }
    
    func userDidBeginLongPressOnBubble(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidEndLongPressOnBubble(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidSelectMessage(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidSelectMessage(viewModel: viewModel)
    }
    
    func userDidDeselectMessage(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidDeselectMessage(viewModel: viewModel)
    }
}
