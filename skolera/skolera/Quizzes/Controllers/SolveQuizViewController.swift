//
//  SolveQuizViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/26/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import MobileCoreServices

class SolveQuizViewController: UIViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var duration = 30 { //duration in seconds
        didSet{
            timerLabel.text = timeString(time: TimeInterval(duration))
        }
    }
    var timer = Timer()
    var isTimerRunning = false
    var savedDuration = 0
    var answers = ["ans 1", "ans 2", "ans 3" ,"ans 4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if #available(iOS 11.0, *) {
            tableView.dropDelegate = self
            tableView.dragDelegate = self
            tableView.dragInteractionEnabled = true
        } else {
            // Fallback on earlier versions
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isTimerRunning {
            runTimer()
        }
        NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: nil) { (notification) in
            debugPrint("back ground mode")
            UserDefaults.standard.set(Date().second, forKey: "timerDuration")
        }
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { (notification) in
            if let timerDuration = UserDefaults.standard.string(forKey: "timerDuration") {
                self.duration -= ( Date().second - Int(timerDuration)! )
                debugPrint("in the background for:", Date().second - Int(timerDuration)!)
            }
        }
    }
 
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(self.updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        timer.tolerance = 0.1
    }
    @objc func updateTimer() {
            if duration < 1 {
            timer.invalidate()
        } else {
            duration -= 1
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}

extension SolveQuizViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if destinationIndexPath!.row < 2 {
            return UITableViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        debugPrint("drop")
        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
//        drop destination is below the questions and the answer cell.
        guard destinationIndexPath.row > 1 else {
            return
        }
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let name = (items as? [String])?.first else { return }
            guard let oldIndex = self.answers.index(of: name) else { return }
            let newIndex = destinationIndexPath.row
            self.answers.swapAt(oldIndex, newIndex-2)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        //should be disabled for questions and the answer cell
        if indexPath.row < 2 {
            return []
        } else {
            let string = answers[indexPath.row-2]
            guard let data = string.data(using: .utf8) else { return [] }
            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
            return [UIDragItem(itemProvider: itemProvider)]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuizQuestionTableViewCell
            return cell
        } else {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerLabelCell") as! QuizAnswerLabelTableViewCell
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QuizAnswerTableViewCell
                cell.answerTextLabel.text = answers[indexPath.row-2]
                return cell
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row < 2 {
//            return false
//        }
//        return true
//    }
    
    
}
