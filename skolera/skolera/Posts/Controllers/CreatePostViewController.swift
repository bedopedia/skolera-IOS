//
//  CreatePostViewController.swift
//  skolera
//
//  Created by Rana Hossam on 8/26/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import MobileCoreServices
import NVActivityIndicatorView
import Alamofire

class CreatePostViewController: UIViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var postContentTextView: KMPlaceholderTextView!
    @IBOutlet weak var addAttachmentsView: UIView!
    @IBOutlet weak var tableView: UITableView!
  
    var attachments: [URL] = []
    var courseGroup: CourseGroup!
    var createdPost: Post!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        postContentTextView.placeholder = "This is a text editor. Add and edit as you wish".localized
//        debugPrint(postContentTextView.placeholder)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true

    }
    
    @IBAction func close() {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func post() {
        debugPrint("create post")
        if !postContentTextView.text.isEmpty {
            startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
            let parameters : Parameters = ["post": ["content": postContentTextView.text!, "owner_id": userId(), "postable_id": self.courseGroup.id, "postable_type": "CourseGroup","video_preview": "",
                                                    "videoURL": ""]]
            createPostApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
                self.stopAnimating()
                if isSuccess {
                    debugPrint("createPostApi success")
                    if let result = value as? [String : AnyObject] {
                        self.createdPost = Post(result)
                        //                    self.uploadFile(file: self.attachments.first!, fileName: self.attachments.first?.lastPathComponent ?? "cannot get file name")
                        if !self.attachments.isEmpty {
                            self.uploadAllFiles()
                        }
                    }
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
                self.close()
            }
        } else {
            debugPrint("empty content")
            let alert = UIAlertController(title: "Skolera", message: "Post is empty".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func uploadFileButton() {
        debugPrint("upload file")
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePresentation), String(kUTTypeMP3), String(kUTTypeImage), String(kUTTypeVideo), String(kUTTypeData), String(kUTTypeArchive)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        importMenu.modalPresentationStyle = .fullScreen
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        let filePath = myURL.path
        var fileSize : UInt64

        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            debugPrint("fileSize: \(fileSize)")
            if fileSize / (1024 * 1024) < UInt64(10) {
                if !attachments.contains(myURL) {
                    attachments.append(myURL)
                }
                addAttachmentsView.isHidden = true
                tableView.isHidden = false
                tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Cannot select file".localized, message: "You must select a file with size less than 10 MB.".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                alert.modalPresentationStyle = .fullScreen
                self.present(alert, animated: true, completion: nil)
            }
            
        } catch {
            print("Error openning the chosen file: \(error)")
        }
        
    }
    
    func uploadFile(file: URL, fileName: String) {
            uploadFileApi(file: file,postId: createdPost.id!, fileName: fileName) { (isSuccess, statusCode, error) in
                if isSuccess {
                    debugPrint("file upload success")
                    
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
    }
    
    func uploadAllFiles() {
        let attachment = attachments.removeFirst()
        uploadFileApi(file: attachment,postId: createdPost.id!, fileName: attachment.lastPathComponent) { (isSuccess, statusCode, error) in
            if isSuccess {
                debugPrint("file upload success")
                
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
        if attachments.isEmpty {
            return
        } else {
            uploadAllFiles()
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentTableViewCell") as! AttachmentTableViewCell
        cell.cancelAction = {
                                let alert = UIAlertController(title: "Delete Entry".localized, message: "Are you sure you want to delete this attachment?".localized, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
                                    NSLog("The \"OK\" alert occured.")
                                    debugPrint("cancel action")
                                    self.attachments.remove(at: indexPath.row)
                                    if self.attachments.isEmpty {
                                        self.tableView.isHidden = true
                                        self.addAttachmentsView.isHidden = false
                                    } else {
                                        self.tableView.reloadData()
                                    }
                                }))
                                alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: { _ in
                                    NSLog("The \"Cancel\" alert occured.")
                                }))
                                alert.modalPresentationStyle = .fullScreen
                                self.present(alert, animated: true, completion: nil)
                            }
        cell.chosenFile = attachments[indexPath.row]
//        cell.attachmentTitle.text = "new title"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
   
}


