//
//  File.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import ChattoAdditions

public class DemoTextMessageViewModel: TextMessageViewModel<DemoTextMessageModel>, DemoMessageViewModelProtocol {
    
    public override init(textMessage: DemoTextMessageModel, messageViewModel: MessageViewModelProtocol) {
        super.init(textMessage: textMessage, messageViewModel: messageViewModel)
    }
    
    public var messageModel: DemoMessageModelProtocol {
        return self.textMessage
    }
}

public class DemoTextMessageViewModelBuilder: ViewModelBuilderProtocol {
    public init() {}
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    public func createViewModel(_ textMessage: DemoTextMessageModel) -> DemoTextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
        let textMessageViewModel = DemoTextMessageViewModel(textMessage: textMessage, messageViewModel: messageViewModel)
        textMessageViewModel.avatarImage.value = UIImage(named: "")
        return textMessageViewModel
    }
    
    public func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is DemoTextMessageModel
    }
}
