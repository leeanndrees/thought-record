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
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastRecord()
        updateLabels()
    }
    
}

// MARK: Private Implementation

extension HomeViewController {
    
    private func getLastRecord() {
        let database = ThoughtRecordDatabase()
        lastRecord = database.thoughts.last
    }
    
    private func updateLabels() {
        updateTimeLabel()
        updateEncouragementLabel()
    }
    
    private func updateTimeLabel() {
        if let lastTime = lastRecord?.longDate {
            timeLabel.text = "Your last check-in was on \(lastTime)."
        } else {
            timeLabel.text = "Nice to see you again!"
        }
    }
    
    private func updateEncouragementLabel() {
        encouragementLabel.text = encouragements.randomElement() ?? ":)"
    }
    
}
