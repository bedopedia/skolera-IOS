//
//  SelectSlotsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class SelectSlotsViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var didSelectSlot: ( (TimetableSlots) -> () )!
//    var cancel: (() -> ())!
    var selectedIndex: Int!
    var selectedSlot: TimetableSlots!
    var timeTableSlots: [TimetableSlots]! {
        didSet{
            self.tableView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func close() {
//        cancel()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit() {
        didSelectSlot(selectedSlot)
        close()
    }
}

extension SelectSlotsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTableSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slotCell") as! AttendanceSlotTableViewCell
        cell.slotLabel.text = "\("Slot".localized) \(timeTableSlots[indexPath.row].slotNo!)"
        if selectedIndex == indexPath.row {
            cell.selectionView.setImage(#imageLiteral(resourceName: "selectedSlot"), for: .normal)
        } else {
            cell.selectionView.setImage(#imageLiteral(resourceName: "unselectedSlot"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selectedSlot = timeTableSlots[indexPath.row]
        tableView.reloadData()
    }

}



