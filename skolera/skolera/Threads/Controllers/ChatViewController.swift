//
//  NewChatViewController.swift
//  skolera
//
//  Created by Salma Medhat on 6/29/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import UIKit
import ReverseExtension
import Firebase
import FirebaseDatabase
import TLPhotoPicker
import Photos
import Lightbox
import IQKeyboardManagerSwift
import NVActivityIndicatorView

class ChatViewController: UIViewController, TLPhotosPickerViewControllerDelegate, UITextFieldDelegate, NVActivityIndicatorViewable  {
    
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "")
    
    var selectedAssets = [TLPHAsset]()
    
    var ref: DatabaseReference!
    var threadRef: DatabaseReference!
    
    var messages: [ChatMessage] = []
    
    var channelName: String = ""
    
    var didOpenImagePicker: Bool = false
    
    var fakeCounter: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        chatTableView.register(nibWithCellClass: ReceiverTextChatTableViewCell.self)
        chatTableView.register(nibWithCellClass: ReceiverImageChatTableViewCell.self)
        chatTableView.register(nibWithCellClass: SenderTextChatTableViewCell.self)
        chatTableView.register(nibWithCellClass: SenderImageChatTableViewCell.self)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 24))
        headerView.backgroundColor = .clear
        self.chatTableView.tableHeaderView = headerView
        chatTableView.re.delegate = self
        
        chatTableView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        chatTableView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        channelName = ""
        //        threadRef = Database.database().reference().child("Production-Threads").child(channelName)
        //        ref = threadRef.child("messages")
        //
        //
        //        ref.observe(.childAdded) { (snapshot) in
        //            let messageData = snapshot.value as! Dictionary<String, Any>
        //            self.messages.append(ChatMessage(messageData))
        //            self.messages = self.messages.sorted(by: { $0.messageTime > $1.messageTime })
        //            self.chatTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        //            self.threadRef.updateChildValues(["job_post_unseen_count": 0])
        //        }
        //
        //        ref.observe(.childChanged) { (snapshot) in
        //            let messageData = snapshot.value as! Dictionary<String, Any>
        //            let item = ChatMessage(messageData)
        //            for (pos, message) in self.messages.enumerated() {
        //                if message.messageTime == item.messageTime {
        //                    message.content = item.content
        //                    self.chatTableView.reloadRows(at: [IndexPath(row: pos, section: 0)], with: .automatic)
        //                }
        //            }
        //            self.chatTableView.reloadData()
        //        }
        
        self.chatTableView.reloadData() // remove later
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //          if !didOpenImagePicker {
        //              ref.removeAllObservers()
        //              NotificationCenter.default.removeObserver(self)
        //          }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //             UIView.animate(withDuration: 0.3) {
        //                 let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        //                let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        //                 let keyboardRectangle = keyboardFrame.cgRectValue
        //                 let keyboardHeight = keyboardRectangle.height
        //                 self.headerTopConstraint.constant = keyboardHeight
        //                 self.view.layoutIfNeeded()
        //             }
        //         }
        
        if let userInfo = notification.userInfo,
                   let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let inset = keyboardFrame.height // if scrollView is not aligned to bottom of screen, subtract offset
                   self.headerTopConstraint.constant = inset
               }
    }
    //
    @objc func keyboardWillHide(notification: NSNotification) {
        //         UIView.animate(withDuration: 0.3) {
        //             self.headerTopConstraint.constant = 0
        //             self.view.layoutIfNeeded()
        //         }
        //
        
         self.headerTopConstraint.constant = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage() {
        //        self.view.endEditing(true)
        //            if let text = messageTextField.text, !text.isEmpty {
        //                let itemRef = ref.childByAutoId()
        //                let messageItem : [String: Any] = ["type": "text",
        //                                                   "content": text,
        //                                                   "message_time": Int(Date().timeIntervalSince1970 * 1000),
        //                                                   "sender_id": "job_post_\(superChozenJobPost.jobPostId)"]
        //                Database.database().reference().child("Devices").child("job_seeker_\(self.jobSeeker!.id)").observe(.childAdded) { (snapShot) in
        //                    let data = snapShot.value as! String
        //                    sendMessageNotification(name: getRecruiterUser().firstName, matchId: self.match.id, reciever: data, message: text)
        //                    Database.database().reference().child("Devices").child("job_seeker_\(self.jobSeeker!.id)").removeAllObservers()
        //                }
        //                itemRef.setValue(messageItem)
        //                updateUnSeenCount()
        //                messageTextField.text = ""
        //            }
        fakeCounter+=1
        var messageItem : [String: Any] = [:]
        if let text = messageTextField.text, !text.isEmpty {
            if fakeCounter % 2 == 0 {
                messageItem = ["type": "text",
                               "content": text,
                               "message_time": Int(Date().timeIntervalSince1970 * 1000),
                               "sender_id": "seeker"]
            } else {
                messageItem = ["type": "text",
                               "content": text,
                               "message_time": Int(Date().timeIntervalSince1970 * 1000),
                               "sender_id": "Recruiter"]
            }
            messageTextField.text = ""
            messages.append(ChatMessage.init(messageItem))
            chatTableView.reloadData()
        }
       
    }
    
    
    private func updateUnSeenCount(){
        //        threadRef.child("seeker_unseen_count").observe(.value) { (snapShot) in
        //            self.threadRef.child("seeker_unseen_count").removeAllObservers()
        //            if snapShot.exists() {
        //                if let unSeenCount = snapShot.value as? Int {
        //                    self.threadRef.updateChildValues(["seeker_unseen_count": unSeenCount + 1])
        //                }
        //            } else {
        //                self.threadRef.updateChildValues(["seeker_unseen_count": 0])
        //            }
        //
        //        }
    }
    
    
    @IBAction func addAttachment() {
        didOpenImagePicker = true
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.allowedVideo = false
        configure.allowedLivePhotos = false
        configure.allowedVideoRecording = false
        configure.singleSelectedMode = false
        viewController.configure = configure
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    //TLPhotosPickerViewControllerDelegate
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        didOpenImagePicker = false
        //        if !withTLPHAssets.isEmpty {
        //            let itemRef = ref.childByAutoId()
        //            let messageItem : [String: Any] = ["type": "image",
        //                                               "content": "NOTSET",
        //                                               "message_time": Int(Date().timeIntervalSince1970 * 1000),
        //                                               "sender_id": "job_post_"]
        //            //"sender_id": "job_post_\(superChozenJobPost.jobPostId)
        //            itemRef.setValue(messageItem)
        //            Database.database().reference().child("Devices").child("job_seeker_").observe(.childAdded) { (snapShot) in
        //                let data = snapShot.value as! String
        ////                sendMessageNotification(name: getRecruiterUser().firstName, matchId: self.match.id, reciever: data, message: "📸 Sent an Image")
        //                Database.database().reference().child("Devices").child("job_seeker_").removeAllObservers()
        //            }
        //            updateUnSeenCount()
        //            self.storageRef.child(channelName).child("\(Int(Date().timeIntervalSince1970 * 1000)).jpeg").putData(withTLPHAssets[0].fullResolutionImage!.jpegData(compressionQuality: 0.5)!, metadata: nil) { (metadata, error) in
        //                if let error = error {
        //                    print("Error uploading photo: \(error.localizedDescription)")
        //                    return
        //                }
        //                self.storageRef.child((metadata?.path)!).downloadURL(completion: { (url, error) in
        //                    let itemKey = itemRef.key ?? ""
        //                    self.ref.child(itemKey).updateChildValues(["content": url!.absoluteString])
        //                })
        //            }
        //        }
        
        fakeCounter+=1
        var messageItem : [String: Any] = [:]
        if !withTLPHAssets.isEmpty {
            if fakeCounter % 2 == 0 {
                messageItem   = ["type": "image",
                                 "content": "NOTSET",
                                 "message_time": Int(Date().timeIntervalSince1970 * 1000),
                                 "sender_id": "seeker"]
            }else {
                messageItem = ["type": "image",
                               "content": "NOTSET",
                               "message_time": Int(Date().timeIntervalSince1970 * 1000),
                               "sender_id": "recruiter"]
            }
            messages.append(ChatMessage.init(messageItem))
            chatTableView.reloadData()
        }
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        //Custom Rules & Display
        //You can decide in which case the selection of the cell could be forbidden.
        return true
    }
    
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        // handle denied albums permissions case
        // showErrorDialog(title: "Access denied", message: "You need to enable Album permissions to select an image")
    }
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        // handle denied camera permissions case
        //        showErrorDialog(title: "Access denied", message: "You need to enable camera permissions to take photo")
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].type.elementsEqual("text") {
            if messages[indexPath.row].senderId.contains("seeker") {
                let cell = tableView.dequeueReusableCell(withClass: ReceiverTextChatTableViewCell.self, for: indexPath)
                cell.messageTextLabel.text = messages[indexPath.row].content
                cell.messageTimeLabel.text = getMessageDate(timeInterval: messages[indexPath.row].messageTime)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withClass: SenderTextChatTableViewCell.self, for: indexPath)
                cell.messageTextLabel.text = messages[indexPath.row].content
                cell.messageTimeLabel.text = getMessageDate(timeInterval: messages[indexPath.row].messageTime)
                return cell
            }
        } else {
            if messages[indexPath.row].senderId.contains("seeker") {
                let cell = tableView.dequeueReusableCell(withClass: ReceiverImageChatTableViewCell.self, for: indexPath)
                cell.messageImageView.isHidden = messages[indexPath.row].content.elementsEqual("NOTSET")
                cell.messageTimeLabel.text = getMessageDate(timeInterval: messages[indexPath.row].messageTime)
                if let url = URL(string: messages[indexPath.row].content) {
                    cell.messageImageView.kf.setImage(with: url)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withClass: SenderImageChatTableViewCell.self, for: indexPath)
                cell.messageImageView.isHidden = messages[indexPath.row].content.elementsEqual("NOTSET")
                cell.messageTimeLabel.text = getMessageDate(timeInterval: messages[indexPath.row].messageTime)
                if let url = URL(string: messages[indexPath.row].content) {
                    cell.messageImageView.kf.setImage(with: url)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if messages[indexPath.row].type.elementsEqual("image") && !messages[indexPath.row].content.elementsEqual("NOTSET"){
            let images = [
                LightboxImage(imageURL: URL(string: messages[indexPath.row].content)!)
            ]
            
            // Create an instance of LightboxController.
            let controller = LightboxController(images: images)
            
            // Use dynamic background.
            controller.dynamicBackground = true
            
            // Present your controller.
            present(controller, animated: true, completion: nil)
        }
    }
}

