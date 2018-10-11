//
//  AddRecordViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/11/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class AddRecordViewController: UITableViewController {

    // MARK: Outlets
    
    @IBOutlet weak var dateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateButtonText()
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let today = Date()
        let todayString = dateFormatter.string(from: today)
        let formattedToday = dateFormatter.date(from: todayString)
        
        return dateFormatter.string(from: formattedToday!)
    }
    
    func setDateButtonText() {
        dateButton.setTitle(formattedDate(), for: .normal)
    }

    // let's redo this, maybe with a xib?
    @IBAction func dateButtonTapped(_ sender: Any) {
        let datePicker = UIDatePicker()
        let dateChooserAlert = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            
        }))
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
}
