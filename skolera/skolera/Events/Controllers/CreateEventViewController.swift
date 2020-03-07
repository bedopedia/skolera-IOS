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
    
    enum Colors {
        case error
        case editing
    }
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
    var lineColor: UIColor!
    var selectedLineColor: UIColor!
    
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
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "d/M/y hh:mm a"
        //        whenDateTextField.placeholder = dateFormatter.string(from: Date())
        //        toDateTextField.placeholder = dateFormatter.string(from: Date())
    }
    
    @objc func whenDatePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y hh:mm a"
        dateFormatter.locale = Locale(identifier: "en")
        whenDateTextField.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.locale = Locale(identifier: "en")
        whenISODate = dateFormatter.string(from: sender.date)
        update(fields: [whenDateTextField], with: .editing)
    }
    
    @objc func toDatePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y hh:mm a"
        dateFormatter.locale = Locale(identifier: "en")
        toDateTextField.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.locale = Locale(identifier: "en")
        toISODate = dateFormatter.string(from: sender.date)
        update(fields: [toDateTextField], with: .editing)
    }
    
    @IBAction func back() {
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
            update(fields: [whenDateTextField], with: .error)
        }
        if !toISODate.isEmpty {
            eventsParameters["end_date"] = toISODate
        } else {
            eventsParameters.removeValue(forKey: "end_date")
            isMissingData = true
            update(fields: [toDateTextField], with: .error)
        }
        if let subjectNameText = subjectNameTextField.text, !subjectNameText.isEmpty {
            eventsParameters["title"] = subjectNameText
        } else {
            eventsParameters.removeValue(forKey: "title")
            isMissingData = true
            update(fields: [subjectNameTextField], with: .error)
        }
        
        if let notesText = addNotesTextField.text, !notesText.isEmpty {
            eventsParameters["description"] = notesText
        } else {
            eventsParameters.removeValue(forKey: "description")
            isMissingData = true
            update(fields: [addNotesTextField], with: .error)
        }
        if !isMissingData{
            guard whenISODate < toISODate else {
                update(fields: [whenDateTextField, toDateTextField], with: .error)
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
            debugPrint(parameters)
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
    
    private func update(fields: [SkyFloatingLabelTextField], with: Colors) {
        switch with {
        case .editing:
            lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            selectedLineColor = #colorLiteral(red: 0, green: 0.8813343644, blue: 0.6430147886, alpha: 1)
        case .error :
            lineColor = .red
            selectedLineColor = .red
        }
        for field in fields {
            if field == whenDateTextField {
                whenDateTextField.lineColor = lineColor
                whenDateTextField.selectedLineColor = selectedLineColor
            } else if field == toDateTextField {
                toDateTextField.lineColor = lineColor
                toDateTextField.selectedLineColor = selectedLineColor
            } else if field == addNotesTextField {
                addNotesTextField.lineColor = selectedLineColor
                addNotesTextField.selectedLineColor = selectedLineColor
            } else {
                subjectNameTextField.lineColor = lineColor
                subjectNameTextField.selectedLineColor = selectedLineColor
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
            update(fields: [addNotesTextField], with: .editing)
            create()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == subjectNameTextField {
            update(fields: [subjectNameTextField], with: .editing)
        } else {
            update(fields: [addNotesTextField], with: .editing)
        }
    }
}
