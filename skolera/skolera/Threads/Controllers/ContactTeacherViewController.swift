//
//  ContactTeacherViewController.swift
//  skolera
//
//  Created by Yehia Beram on 5/20/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Chatto
import ChattoAdditions
import AlamofireImage
import SkeletonView

class ContactTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource, NVActivityIndicatorViewable {
    @IBOutlet weak var threadsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newThreadButton: UIBarButtonItem!
    @IBOutlet weak var leftHeaderButton: UIButton!
    @IBOutlet weak var rightHeaderButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    var threads: [Threads]!
    var child: Actor!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        threadsTableView.delegate = self
        threadsTableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        if child == nil {
            titleLabel.text = "Messages".localized
            newThreadButton.tintColor = UIColor.clear
            newThreadButton.isEnabled = false
        }
        let userType = getUserType()
        if (userType == UserType.teacher) || (userType == UserType.hod) || (userType == UserType.admin) {
            leftHeaderButton.isHidden = true
        } else if userType == UserType.parent {
            leftHeaderButton.setImage(UIImage.init(named: "chevronLeft"), for: .normal)
            leftHeaderButton.setImage(leftHeaderButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
            rightHeaderButton.setImage(UIImage.init(named: "plusIcon"), for: .normal)
        }
        threadsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        fixTableViewHeight()
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopAnimating()
    }
    
    @objc private func refreshData() {
        fixTableViewHeight()
        threadsTableView.showAnimatedSkeleton()
        getThreads()
        refreshControl.endRefreshing()
    }
    func fixTableViewHeight() {
        threadsTableView.estimatedRowHeight = 96
        threadsTableView.rowHeight = 96
    }
    func getThreads() {
        if threads == nil {
            threads = []
        }
        getThreadsApi { (isSuccess, statusCode, response, error) in
            self.threads = []
            self.threadsTableView.hideSkeleton()
            if isSuccess {
                if let result = response as? [String: AnyObject] {
                    debugPrint(result)
                    if let threadsJson = result["message_threads"] as? [[String : AnyObject]] {
                        for thread in threadsJson {
                            self.threads.append(Threads.init(fromDictionary: thread))
                        }
                        self.threadsTableView.reloadData()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.threadsTableView, dataSource: self.threads ?? [], imageName: "messagesplaceholder", placeholderText: "You don't have any messages for now".localized)
        }
    }
    
    @IBAction func rightHeaderButtonClicked() {
        if getUserType() == UserType.parent {
            let newMessageVC = NewMessageViewController.instantiate(fromAppStoryboard: .Threads)
            if let _ = parent as? ContactTeacherNVC, let student = self.child {
                newMessageVC.child = student
                self.navigationController?.pushViewController(newMessageVC, animated: true)
            }
        } else {
            let settingsVC = SettingsViewController.instantiate(fromAppStoryboard: .HomeScreen)
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    @IBAction func leftHeaderButtonClicked() {
        if getUserType() == UserType.parent {
            self.navigationController?.navigationController?.popViewController(animated: true)
        } else {
            let newMessageVC = NewMessageViewController.instantiate(fromAppStoryboard: .Threads)
            if let _ = parent as? ContactTeacherNVC, let student = self.child {
                newMessageVC.child = student
                self.navigationController?.pushViewController(newMessageVC, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if threads != nil {
            return threads.count
        } else {
            return 6
        }
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ThreadTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadTableViewCell", for: indexPath) as! ThreadTableViewCell
        cell.selectionStyle = .none
        if threads != nil {
            cell.hideSkeleton()
            cell.imageBackgroundView.isHidden = false
            let fullName = self.threads[indexPath.row].name ?? self.threads[indexPath.row].othersNames ?? "Deleted user"
            let fullNameArr = fullName.components(separatedBy: " ")
            cell.threadTitle.text = "\(fullNameArr[0]) \(fullNameArr.last ?? "")"
            
            
            if self.threads[indexPath.row].courseName != nil {
                cell.threadLatestMessage.text = self.threads[indexPath.row].courseName
            } else {
                if self.threads[indexPath.row].messages.count == 0 {
                    cell.threadLatestMessage.text = ""
                } else {
                    if let user = self.threads[indexPath.row].messages.first!.user {
                        cell.threadLatestMessage.text = "\(user.name!): \(self.threads[indexPath.row].messages.first!.body!.htmlToString.trimmingCharacters(in: .whitespacesAndNewlines))"
                    } else {
                        cell.threadLatestMessage.text = "\(self.threads[indexPath.row].othersNames ?? "Deleted user"): \(self.threads[indexPath.row].messages.first!.body!.htmlToString.trimmingCharacters(in: .whitespacesAndNewlines))"
                    }
                }
            }
            cell.threadImage.childImageView(url: (self.threads[indexPath.row].othersAvatars ?? [""]).last ?? "" , placeholder: "\(fullNameArr[0].first ?? Character(" "))\((fullNameArr.last ?? " ").first ?? Character(" "))", textSize: 20)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let date = dateFormatter.date(from: self.threads[indexPath.row].lastAddedDate)!
            if Calendar.current.isDateInToday(date){
                
                if Locale.current.languageCode!.elementsEqual("ar") {
                    cell.threadDate.text = "اليوم"
                } else {
                    cell.threadDate.text = "Today"
                }
            } else if Calendar.current.isDateInYesterday(date){
                if Locale.current.languageCode!.elementsEqual("ar") {
                    cell.threadDate.text = "الامس"
                } else {
                    cell.threadDate.text = "Yesterday"
                }
            } else {
                let formatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                formatter.dateFormat = "dd/MM/yyyy"
                cell.threadDate.text = formatter.string(from: date)
            }
        }
        return cell
    }
    
    private func getMessages(thread: Threads) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        //            let parameters : Parameters = ["course_id" : grade.courseId]
        getMessagesApi(threadId: thread.id!) { (isSuccess, statusCode, response, error) in
            if isSuccess {
                DispatchQueue.global(qos: .userInitiated).async {
                    // Bounce back to the main thread to update the UI
                    if let result = response as? [String: Any], let messagesJsonArray = result["messages"] as? [[String: Any]] {
                        let messages = messagesJsonArray.map{Message(fromDictionary: $0)}
                        thread.messages = messages
                    }
                    //////////////////////////////////////////
                    let chatVC = ChatViewController.instantiate(fromAppStoryboard: .Threads)
                    var messages: [ChatItemProtocol] = []
                    let threadsMessages = thread.messages.sorted(by: { self.getMessage(time: $0.createdAt).compare(self.getMessage(time: $1.createdAt)) == .orderedAscending })
                    
                    for item in threadsMessages {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en")
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                        let date = dateFormatter.date(from: item.createdAt)!
                        if item.attachmentUrl == nil || item.attachmentUrl.isEmpty {
                            if "\(item.user?.id ?? -1)".elementsEqual(userId()){
                                let messageModel: MessageModel = MessageModel.init(uid: NSUUID().uuidString, senderId: "\(item.user?.id ?? -1)", type: TextMessageModel<MessageModel>.chatItemType, isIncoming: false, date: date, status: .success)
                                let textModel: DemoTextMessageModel = DemoTextMessageModel(messageModel: messageModel, text: item.body.htmlToString.decode())
                                messages.append(textModel)
                            } else {
                                let messageModel: MessageModel = MessageModel.init(uid: NSUUID().uuidString, senderId: "\(item.user?.id ?? -1)", type: TextMessageModel<MessageModel>.chatItemType, isIncoming: true, date: date, status: .success)
                                let textModel: DemoTextMessageModel = DemoTextMessageModel(messageModel: messageModel, text: item.body.htmlToString.decode())
                                
                                messages.append(textModel)
                            }
                        } else {
                            let messageModel: MessageModel = MessageModel.init(uid: NSUUID().uuidString, senderId: "\(item.user?.id ?? -1)", type: PhotoMessageModel<MessageModel>.chatItemType, isIncoming: !"\(item.user?.id ?? -1)".elementsEqual(userId()), date: date, status: .success)
                            let size = CGSize(width: 2000.0, height: 1000.0)
                            if item.ext == nil {
                                let image = UIImage(named: "file_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: true)
                                messages.append(photoModel)
                            } else if item.ext.elementsEqual("pdf") {
                                let image = UIImage(named: "pdf_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: false)
                                messages.append(photoModel)
                            } else if item.ext.contains("doc") || item.ext.contains("rtf") {
                                let image = UIImage(named: "doc_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: false)
                                messages.append(photoModel)
                            } else if item.ext.contains("pp") {
                                let image = UIImage(named: "ppt_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: false)
                                messages.append(photoModel)
                            } else if item.ext.contains("xl") {
                                let image = UIImage(named: "xlsx_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: false)
                                messages.append(photoModel)
                            } else if item.ext.elementsEqual("rar") || item.ext.elementsEqual("zip") {
                                let image = UIImage(named: "zip_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: false)
                                messages.append(photoModel)
                            } else if item.ext.elementsEqual("mp3") || item.ext.elementsEqual("wav") {
                                let image = UIImage(named: "audio_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: false)
                                messages.append(photoModel)
                            } else if item.ext.elementsEqual("mp4") || item.ext.elementsEqual("3gp") {
                                let image = UIImage(named: "video_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: false)
                                messages.append(photoModel)
                            } else if item.ext.elementsEqual("jpg") || item.ext.elementsEqual("jpeg") || item.ext.elementsEqual("png") {
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: CGSize(width: 1000, height: 1000), image: UIImage(), url: item.attachmentUrl, loadImage: true)
                                messages.append(photoModel)
                            } else {
                                let image = UIImage(named: "file_icon")!.af_imageAspectScaled(toFit: size)
                                let photoModel: DemoPhotoMessageModel = DemoPhotoMessageModel(messageModel: messageModel, imageSize: image.size, image: image, url: item.attachmentUrl, loadImage: true)
                                messages.append(photoModel)
                            }
                        }
                    }
                    
                    //        let sortedMessages = messages.sorted(by: { $0.messageModel.date.compare($1.messageModel.date) == .orderedAscending })
                    
                    let dataSource = DemoChatDataSource(messages: messages, pageSize: 50)
                    chatVC.dataSource = dataSource
                    let fullName = thread.othersNames ?? thread.name
                    var fullNameArr = fullName?.components(separatedBy: " ")
                    chatVC.chatName = "\(fullNameArr![0]) \(fullNameArr?.last ?? "")"
                    chatVC.canSendMessage = !thread.participants.isEmpty
                    chatVC.thread = thread
                    
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        //                self.navigationController?.isNavigationBarHidden = false
                        //                self.navigationController?.pushViewController(chatVC, animated: true)
                        self.navigationController?.navigationController?.pushViewController(chatVC, animated: true)
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func getMessage(time: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let date = dateFormatter.date(from: time)!
        return date
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.threads.count > 0 else {
            return
        }
        guard indexPath.row < self.threads.count else {
            return
        }
        getMessages(thread: self.threads![indexPath.row])
        
    }
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIViewContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}
