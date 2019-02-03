//
//  DemoPhotoMessageViewModelBuilder.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import ChattoAdditions
import Kingfisher

class DemoPhotoMessageViewModel: PhotoMessageViewModel<DemoPhotoMessageModel> {
    
    let fakeImage: UIImage
    let imageURL: String
    let loadImage: Bool
    public var isImage: Bool = false
    override init(photoMessage: DemoPhotoMessageModel, messageViewModel: MessageViewModelProtocol) {
        self.fakeImage = UIImage()
        self.imageURL = photoMessage.url
        self.loadImage = photoMessage.loadImage
        super.init(photoMessage: DemoPhotoMessageModel(messageModel: photoMessage.messageModel as! MessageModel, imageSize: photoMessage.imageSize, image: UIImage(), url: photoMessage.url, loadImage: false), messageViewModel: messageViewModel)
//        if photoMessage.isIncoming {
//            self.image.value = nil
//        }
        if loadImage {
            self.transferStatus.value = .transfering
            KingfisherManager.shared.retrieveImage(with: URL(string: imageURL)!, options: nil, progressBlock: nil) { (image, error, cache, url) in
                self.transferStatus.value = .success
                if error != nil {
                    self.image.value = photoMessage.image
                    self.isImage = false
                } else {
                    self.image.value = image
                    self.isImage = true
                }
                
            }
        } else {
            self.image.value = photoMessage.image
            isImage = false
        }
        
    }
    
    override func willBeShown() {
//        self.fakeProgress()
    }
    
    func fakeProgress() {
        if [TransferStatus.success, TransferStatus.failed].contains(self.transferStatus.value) {
            return
        }
        if self.transferProgress.value >= 1.0 {
            
            return
        }
        
        let delaySeconds: Double = Double(arc4random_uniform(600)) / 1000.0
        let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            guard let sSelf = self else { return }
            let deltaProgress = Double(arc4random_uniform(15)) / 100.0
            sSelf.transferProgress.value = min(sSelf.transferProgress.value + deltaProgress, 1)
            sSelf.fakeProgress()
        }
    }
}

extension DemoPhotoMessageViewModel: DemoMessageViewModelProtocol {
    var messageModel: DemoMessageModelProtocol {
        return self._photoMessage
    }
}

class DemoPhotoMessageViewModelBuilder: ViewModelBuilderProtocol {
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    func createViewModel(_ model: DemoPhotoMessageModel) -> DemoPhotoMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let photoMessageViewModel = DemoPhotoMessageViewModel(photoMessage: model, messageViewModel: messageViewModel)
        photoMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
        return photoMessageViewModel
    }
    
    func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is DemoPhotoMessageModel
    }
}
