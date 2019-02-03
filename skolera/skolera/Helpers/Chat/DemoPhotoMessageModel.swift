//
//  DemoPhotoMessageModel.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public class DemoPhotoMessageModel: PhotoMessageModel<MessageModel>, DemoMessageModelProtocol {
    var url: String!
    var loadImage: Bool!
//    public override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
//        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
//    }
    
    public init(messageModel: MessageModel, imageSize: CGSize, image: UIImage, url: String, loadImage: Bool) {
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
        self.url = url
        self.loadImage = loadImage
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
