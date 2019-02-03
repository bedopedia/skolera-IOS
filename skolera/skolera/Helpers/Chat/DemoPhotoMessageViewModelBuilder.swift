//
//  DemoPhotoMessageViewModelBuilder.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import ChattoAdditions

class DemoPhotoMessageViewModel: PhotoMessageViewModel<DemoPhotoMessageModel> {
    
    let fakeImage: UIImage
    let imageURL: String
    override init(photoMessage: DemoPhotoMessageModel, messageViewModel: MessageViewModelProtocol) {
        self.fakeImage = photoMessage.image
        self.imageURL = photoMessage.url
        super.init(photoMessage: photoMessage, messageViewModel: messageViewModel)
//        if photoMessage.isIncoming {
//            self.image.value = nil
//        }
        self.image.value = self.fakeImage
    }
    
    override func willBeShown() {
//        self.fakeProgress()
    }
    
//    func fakeProgress() {
//        if [TransferStatus.success, TransferStatus.failed].contains(self.transferStatus.value) {
//            return
//        }
//        if self.transferProgress.value >= 1.0 {
//            if arc4random_uniform(100) % 2 == 0 {
//                self.transferStatus.value = .success
//                self.image.value = self.fakeImage
//            } else {
//                self.transferStatus.value = .failed
//            }
//
//            return
//        }
//        self.transferStatus.value = .transfering
//        let delaySeconds: Double = Double(arc4random_uniform(600)) / 1000.0
//        let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
//            guard let sSelf = self else { return }
//            let deltaProgress = Double(arc4random_uniform(15)) / 100.0
//            sSelf.transferProgress.value = min(sSelf.transferProgress.value + deltaProgress, 1)
//            sSelf.fakeProgress()
//        }
//    }
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
