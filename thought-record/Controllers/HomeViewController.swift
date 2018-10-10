//
//  HomeViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    var lastRecord: ThoughtRecord?
    
    // MARK: Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var encouragementLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastRecord()
        updateLabels()
    }
    
    func getLastRecord() {
        let database = ThoughtRecordDatabase()
        lastRecord = database.thoughts.last
    }

    func updateLabels() {
        if let lastTime = lastRecord?.date {
            timeLabel.text = "Your last check-in was on \(lastTime)."
        } else {
            timeLabel.text = "Nice to see you again!"
        }
    }
    
}
