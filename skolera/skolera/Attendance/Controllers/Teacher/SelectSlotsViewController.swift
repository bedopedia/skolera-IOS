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
    
    var didSelectSlot: ( (Int) -> () )!
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit() {
        if let index = selectedIndex {
            didSelectSlot(index)
            close()
        } else {
            //present dialogue slot selection or close
            close()
        }
    }
}

extension SelectSlotsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slotCell") as! AttendanceSlotTableViewCell
        cell.slotLabel.text = "Slot \(indexPath.row + 1)"
        cell.selectionView.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        cell.selectionView.layer.borderWidth = 1
        cell.selectionView.layer.cornerRadius = 12
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }

}



