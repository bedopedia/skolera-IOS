//
//  ChatViewController.swift
//  skolera
//
//  Created by Yehia Beram on 5/23/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Chatto
import ChattoAdditions

class ChatViewController: BaseChatViewController {
    
    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()
    
    var chatName: String = "Chat"
    var thread: Threads!
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
//        self.navigationController?.isNavigationBarHidden = false
        self.title = chatName
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        setThreadSeen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = "Send".localized
        appearance.textInputAppearance.placeholderText = "Type a message".localized
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
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
    
    func setThreadSeen(){
        if !newThread {
            SVProgressHUD.show(withStatus: "Loading".localized)
            let parameters : Parameters? = ["thread_ids": [self.thread.id]]
            let headers : HTTPHeaders? = getHeaders()
            let url = String(format: SET_THREAD_IS_SEEN())
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.result{
                    
                case .success(_):
                    debugPrint(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                    {
                        showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                    }
                    else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                    {
                        showReauthenticateAlert(viewController: self)
                    }
                    else
                    {
                        debugPrint(error)
                    }
                }
            }
        }
    }
    
    
    func send(message: String)
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let headers : HTTPHeaders? = getHeaders()
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
            debugPrint(parameters)
            let url = String(format: GET_THREADS())
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.result{
                    
                case .success(_):
                    debugPrint(response)
                    self.dataSource.addTextMessage(message)
                    self.newThread = false
                case .failure(let error):
                    print(error.localizedDescription)
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                    {
                        showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                        })
                    }
                    else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                    {
                        showReauthenticateAlert(viewController: self)
                    }
                    else
                    {
                        showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        })
                    }
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
            debugPrint(parameters)
            let url = String(format: SEND_MESSAGE(),thread.id)
            Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.result{
                    
                case .success(_):
                    debugPrint("success")
                     self.dataSource.addTextMessage(message)
                case .failure(let error):
                    print(error.localizedDescription)
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                    {
                        showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                        })
                    }
                    else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                    {
                        showReauthenticateAlert(viewController: self)
                    }
                    else
                    {
                        showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        })
                    }
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
        let imageData = NSData(data:UIImagePNGRepresentation(scaledImage!)!)
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
        SVProgressHUD.show(withStatus: "Loading".localized)
        if !newThread {
            let url = "\(String(format: SEND_MESSAGE(),thread.id))/messages"
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append("file attached".data(using: .utf8)!, withName: "body")
                    multipartFormData.append("\(imageName)".data(using: .utf8)!, withName: "filename")
                    multipartFormData.append(imageData, withName: "attachment", fileName: imageName, mimeType: "image/jpeg")
            },
                to: url, method: .post, headers: getHeaders(),
                encodingCompletion: { encodingResult in
                    SVProgressHUD.dismiss()
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
        }
    }
    
    
}

extension ChatViewController: MessagesSelectorDelegate {
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
