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

}
