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

class CreatePostViewController: UIViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var postContentTextView: KMPlaceholderTextView!
    @IBOutlet weak var addAttachmentsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var attachments: [URL] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addAttachmentsView.isHidden = true
        
//        postContentTextView.layer.borderWidth = 1
//        postContentTextView.layer.borderColor = #colorLiteral(red: 0.6460315585, green: 0.6780731678, blue: 0.7072373629, alpha: 1)
//        postContentTextView.layer.cornerRadius = 6
        postContentTextView.placeholder = "This is a text editor. Add and edit as you wish".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true

    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post() {
        debugPrint("create post")
    }
    
    @IBAction func uploadFile() {
        debugPrint("upload file")
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), String(kUTTypePresentation), String(kUTTypeMP3), String(kUTTypeImage), String(kUTTypeVideo), String(kUTTypeData), String(kUTTypeArchive)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
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
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            debugPrint("fileSize: \(fileSize)")
            if fileSize / (1024 * 1024) < UInt64(0.8) {
                attachments.append(myURL)
                addAttachmentsView.isHidden = true
                tableView.isHidden = false
                tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Cannot select file", message: "You must select a file with size less than 10 MB.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        } catch {
            print("Error: \(error)")
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
        cell.chosenFile = attachments[indexPath.row]
//        cell.attachmentTitle.text = "new title"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

}


