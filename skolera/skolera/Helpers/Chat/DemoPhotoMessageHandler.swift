//
//  DemoPhotoMessageHandler.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import ChattoAdditions
import Lightbox

class DemoPhotoMessageHandler: BaseMessageInteractionHandlerProtocol {
    private let baseHandler: BaseMessageHandler
    private let viewController: ChatViewController
    init (baseHandler: BaseMessageHandler, viewController: ChatViewController) {
        self.baseHandler = baseHandler
        self.viewController = viewController
    }
    
    func userDidTapOnFailIcon(viewModel: DemoPhotoMessageViewModel, failIconView: UIView) {
        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }
    
    func userDidTapOnAvatar(viewModel: DemoPhotoMessageViewModel) {
        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }
    
    func userDidTapOnBubble(viewModel: DemoPhotoMessageViewModel) {
        if !viewModel.isImage {
            if let url = URL(string: viewModel.imageURL) {
               UIApplication.shared.openURL(url)
            } else {
                // do nothing
//                let images = [
//                    LightboxImage(image: viewModel._photoMessage.image)
//                ]
//                let controller = LightboxController(images: images)
//                controller.dynamicBackground = true
//                viewController.present(controller, animated: true, completion: nil)
            }
            
        } else {
            let images = [
                LightboxImage(imageURL: URL(string: viewModel.imageURL)!)

            ]
            let controller = LightboxController(images: images)
            controller.dynamicBackground = true
            viewController.present(controller, animated: true, completion: nil)
        }
        self.baseHandler.userDidTapOnBubble(viewModel: viewModel)
    }
    
    func userDidBeginLongPressOnBubble(viewModel: DemoPhotoMessageViewModel) {
        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidEndLongPressOnBubble(viewModel: DemoPhotoMessageViewModel) {
        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidSelectMessage(viewModel: DemoPhotoMessageViewModel) {
        self.baseHandler.userDidSelectMessage(viewModel: viewModel)
    }
    
    func userDidDeselectMessage(viewModel: DemoPhotoMessageViewModel) {
        self.baseHandler.userDidDeselectMessage(viewModel: viewModel)
    }
}
