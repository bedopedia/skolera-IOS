//
//  ChatViewController.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Chatto
import ChattoAdditions

class OldChatViewController: BaseChatViewController, NVActivityIndicatorViewable {
    
    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()
    
    var chatName: String = "Chat"
    var thread: Threads!
    var canSendMessage: Bool = true
    var newThread:Bool = false
    var courseId: Int = -1
    var teacherId: Int = -1
    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }
    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false    //contact teacher nvc
        self.title = chatName
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false    //contact teacher nvc
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setThreadSeen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if Language.language == .arabic {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
    }
    
    
    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        if canSendMessage {
            let chatInputView = ChatInputBar.loadNib()
            var appearance = ChatInputBarAppearance()
            appearance.sendButtonAppearance.title = "Send".localized
            appearance.textInputAppearance.placeholderText = "Type a message".localized
            self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
            chatInputView.maxCharactersCount = 1000
            return chatInputView
        } else {
            return UIView.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
        }
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let chatColor = BaseMessageCollectionViewCellDefaultStyle.Colors(
            incoming: UIColor.appColors.progressBarBackgroundColor, // white background for incoming
            outgoing: UIColor.appColors.green // black background for outgoing
        )
        // used for base message background + text background
        let baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle(colors: chatColor)
        
        let textStyle = TextMessageCollectionViewCellDefaultStyle.TextStyle(
            font: UIFont.systemFont(ofSize: 13),
            incomingColor: UIColor.black, // black text for incoming
            outgoingColor: UIColor.white, // white text for outgoing
            incomingInsets: UIEdgeInsets(top: 10, left: 19, bottom: 10, right: 15),
            outgoingInsets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 19)
        )
        
        
        let textCellStyle: TextMessageCollectionViewCellDefaultStyle = TextMessageCollectionViewCellDefaultStyle(
            textStyle: textStyle,
            baseStyle: baseMessageStyle) // without baseStyle, you won't have the right background
        
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        //        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        textMessagePresenter.baseMessageStyle = baseMessageStyle
        textMessagePresenter.textCellStyle = textCellStyle
        
        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler, viewController: self)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter]
        ]
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.send(message: text)
            self?.collectionView.scrollToLast()
        }
        return item
    }
    
    private func createPhotoInputItem() -> PhotosChatInputItem {
        
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
            self?.scaleImage(image: image)
            self?.collectionView.scrollToLast()
        }
        return item
    }
    
    func setThreadSeen() {
        if !newThread {
            startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
            debugPrint(self.thread.id!)
            let parameters : Parameters = ["thread_ids": [self.thread.id!]]
            setThreadSeenApi(parameters: parameters) { (isSuccess, statusCode, response, error) in
                self.stopAnimating()
                if isSuccess {
                    debugPrint(response)
                } else {
                    //                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                        showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                    } else if statusCode == 401 || statusCode == 500 {
                        showReauthenticateAlert(viewController: self)
                    } else {
                        debugPrint(error)
                    }
                }
            }
        }
    }
    
    func send(message: String) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        if newThread {
            let parameters : Parameters = [
                "message_thread": [
                    "course_id": courseId,
                    "tag": ".",
                    "name": ".",
                    "messages_attributes": [[
                        "body": message.encode(),
                        "user_id": userId()
                        ]]
                ],
                "user_ids": ["\(teacherId)", "\(userId())"]
            ]
            sendMessageApi(parameters: parameters) { (isSuccess, statusCode, response, error) in
                self.stopAnimating()
                if isSuccess {
                    self.dataSource.addTextMessage(message)
                    self.newThread = false
                } else {
                    print(error!.localizedDescription)
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
        } else {
            let parameters : Parameters = [
                "message_thread": [
                    "Id": "\(thread.id!)",
                    "title": "\(thread.name!)",
                    "messages_attributes": [[
                        "body": message.encode(),
                        "messageThreadId": "\(thread.id!)",
                        "user_id": userId()
                        ]]
                ]
            ]
            replyToMessageApi(threadId: thread.id, parameters: parameters) { (isSuccess, statusCode, error) in
                self.stopAnimating()
                if isSuccess {
                    debugPrint("success")
                    self.dataSource.addTextMessage(message)
                } else {
                    self.dataSource.addTextMessage(message)
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
        }
    }
    
    private func scaleImage(image: UIImage) {
        let newWidth:CGFloat = 400.0
        let scale = newWidth / (image.size.width)
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height:newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageData = NSData(data:scaledImage!.pngData()!)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs: String = paths[0]
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddhhmmssSSSS"
        df.string(from: d)
        let fileName = df.string(from: d) + ".jpg"
        let fullPath = docs.appendingFormat("/%@", fileName)
        
        _ = imageData.write(toFile: fullPath, atomically: true)
        uploadImage(imageData: imageData as Data, imageName: fileName)
        debugPrint(fullPath)
        //        if let key = sendPhotoMessage() {
        //            // 4
        //            let imageFileURL = URL(string: "file://\(fullPath)")
        //
        //            // 5
        ////            let path = "\(self.channel!.threadId)/\(fileName)"
        //
        //            // 6
        //            DispatchQueue.global().async(execute: {
        //
        //                DispatchQueue.main.sync{
        //                    print("main thread")
        //
        //                }
        //            })
        //
        //        }
        //
    }
    
    private func uploadImage(imageData: Data, imageName: String) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        if !newThread {
            uploadImageApi(threadId: thread.id, imageData: imageData, imageName: imageName) { (isSuccess, statusCode, error) in
                self.stopAnimating()
                if isSuccess {
                    debugPrint(statusCode)
                } else {
                    debugPrint(error!)
                }
            }
        }
    }
}

extension OldChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
    
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}