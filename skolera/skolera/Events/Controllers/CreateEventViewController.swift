//
//  CreateEventViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SkyFloatingLabelTextField

class CreateEventViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var whenDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var toDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var subjectNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addNotesTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var childImageView: UIImageView!
    
    let whenDatePickerView: UIDatePicker = UIDatePicker()
    let toDatePickerView: UIDatePicker = UIDatePicker()
    var whenISODate: String = ""
    var toISODate: String = ""
    var child : Actor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.setImage(backButton.image(for:.normal)?.flipIfNeeded(),for: .normal)
        subjectNameTextField.delegate = self
        addNotesTextField.delegate = self        
        let whenDatePickerView: UIDatePicker = UIDatePicker()
        whenDatePickerView.backgroundColor = .white
        whenDatePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        whenDateTextField.inputView = whenDatePickerView
        whenDatePickerView.addTarget(self, action: #selector(whenDatePickerFromValueChanged), for: UIControl.Event.valueChanged)
        
        let toDatePickerView: UIDatePicker = UIDatePicker()
        toDatePickerView.backgroundColor = .white
        toDatePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        toDateTextField.inputView = toDatePickerView
        toDatePickerView.addTarget(self, action: #selector(toDatePickerFromValueChanged), for: UIControl.Event.valueChanged)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "d/M/y hh:mm a"
//        whenDateTextField.placeholder = dateFormatter.string(from: Date())
//        toDateTextField.placeholder = dateFormatter.string(from: Date())
        
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
    }
    
    @objc func whenDatePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y hh:mm a"
        dateFormatter.locale = Locale(identifier: "en")
        whenDateTextField.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.locale = Locale(identifier: "en")
        whenISODate = dateFormatter.string(from: sender.date)
        whenDateTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        whenDateTextField.selectedLineColor = #colorLiteral(red: 0, green: 0.8813343644, blue: 0.6430147886, alpha: 1)
    }
    
    @objc func toDatePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y hh:mm a"
        dateFormatter.locale = Locale(identifier: "en")
        toDateTextField.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.locale = Locale(identifier: "en")
        toISODate = dateFormatter.string(from: sender.date)
        toDateTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        toDateTextField.selectedLineColor = #colorLiteral(red: 0, green: 0.8813343644, blue: 0.6430147886, alpha: 1)
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func create(){
        var isMissingData: Bool = false
        var eventsParameters: [String: Any] = [:]
        if !whenISODate.isEmpty {
            eventsParameters["start_date"] = whenISODate
        } else {
            eventsParameters.removeValue(forKey: "start_date")
            isMissingData = true
            whenDateTextField.lineColor = .red
            whenDateTextField.selectedLineColor = .red
        }
        if !toISODate.isEmpty {
            eventsParameters["end_date"] = toISODate
        } else {
            eventsParameters.removeValue(forKey: "end_date")
            isMissingData = true
            toDateTextField.lineColor = .red
            toDateTextField.selectedLineColor = .red
        }
        if let subjectNameText = subjectNameTextField.text, !subjectNameText.isEmpty {
            eventsParameters["title"] = subjectNameText
        } else {
            eventsParameters.removeValue(forKey: "title")
            isMissingData = true
            subjectNameTextField.lineColor = .red
            subjectNameTextField.selectedLineColor = .red
        }
        
        if let notesText = addNotesTextField.text, !notesText.isEmpty {
            eventsParameters["description"] = notesText
        } else {
            eventsParameters.removeValue(forKey: "description")
            isMissingData = true
            addNotesTextField.lineColor = .red
            addNotesTextField.selectedLineColor = .red
        }
        if !isMissingData{
            guard whenISODate < toISODate else {
                whenDateTextField.lineColor = .red
                whenDateTextField.selectedLineColor = .red
                toDateTextField.lineColor = .red
                toDateTextField.selectedLineColor = .red
                let alert = UIAlertController(title: "Skolera".localized, message: "Please enter correct dates".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                alert.modalPresentationStyle = .fullScreen
                self.present(alert, animated: true, completion: nil)
                return
            }
            eventsParameters["type"] = "personal"
            eventsParameters["all_day"] = false
            eventsParameters["cancel"] = false
            eventsParameters["subscriptions_attributes"] = [["subscriber_type" : "User", "subscriber_id" : child.id!]]
            let parameters = [ "event": eventsParameters ]
            startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
            createEventsAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
                self.stopAnimating()
                if isSuccess {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
            
        }
    }
}

extension CreateEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == subjectNameTextField {
            addNotesTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            create()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == subjectNameTextField {
            subjectNameTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            subjectNameTextField.selectedLineColor = #colorLiteral(red: 0, green: 0.8813343644, blue: 0.6430147886, alpha: 1)
        } else if textField == addNotesTextField{
            addNotesTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            addNotesTextField.selectedLineColor = #colorLiteral(red: 0, green: 0.8813343644, blue: 0.6430147886, alpha: 1)
        } else if textField == whenDateTextField {
            whenDateTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            whenDateTextField.selectedLineColor = #colorLiteral(red: 0, green: 0.8813343644, blue: 0.6430147886, alpha: 1)
        } else {
            toDateTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            toDateTextField.selectedLineColor = #colorLiteral(red: 0, green: 0.8813343644, blue: 0.6430147886, alpha: 1)
        }
    }
}
