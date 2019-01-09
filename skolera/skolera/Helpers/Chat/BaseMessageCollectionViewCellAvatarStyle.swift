//
//  BaseMessageCollectionViewCellAvatarStyle.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import ChattoAdditions

class BaseMessageCollectionViewCellAvatarStyle: BaseMessageCollectionViewCellDefaultStyle {
    
    override func avatarSize(viewModel: MessageViewModelProtocol) -> CGSize {
        // Display avatar for both incoming and outgoing messages for demo purpose
        return CGSize(width: 0, height: 0)
    }
}
