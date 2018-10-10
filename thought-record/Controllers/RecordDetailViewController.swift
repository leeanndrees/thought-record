//
//  RecordDetailViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class RecordDetailViewController: UITableViewController {
    
    var recordToShow: ThoughtRecord?
    
    // MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thoughtLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var feelingsStartLabel: UILabel!
    @IBOutlet weak var unhelpfulThoughtsLabel: UILabel!
    @IBOutlet weak var factsSupportingLabel: UILabel!
    @IBOutlet weak var factsAgainstLabel: UILabel!
    @IBOutlet weak var balancedPerspectiveLabel: UILabel!
    @IBOutlet weak var feelingsEndLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecordToShow()
        displayRecordData()
    }

    func getRecordToShow() {
        recordToShow = ThoughtRecordDatabase().thoughts[0]
    }
    
    func feelingsArrayToString(array: [Feeling]) -> String {
        var feelingNames: [String] = []
        for feeling in array {
            feelingNames.append(feeling.name)
        }
        let feelingListString = feelingNames.joined(separator: ", ")
        return feelingListString
    }
    
    func tagArrayToString(array: [Tag]) -> String {
        var tagNames: [String] = []
        for tag in array {
            tagNames.append(tag.name)
        }
        let tagListString = tagNames.joined(separator: ", ")
        return tagListString
    }
    
    func displayRecordData() {
        if let record = recordToShow {
            dateLabel.text = record.date
            thoughtLabel.text = record.thought
            situationLabel.text = record.situation
            feelingsStartLabel.text = feelingsArrayToString(array: record.feelingsStart)
            unhelpfulThoughtsLabel.text = record.unhelpfulThoughts
            factsSupportingLabel.text = record.factsSupporting
            factsAgainstLabel.text = record.factsAgainst
            balancedPerspectiveLabel.text = record.balancedPerspective
            feelingsEndLabel.text = feelingsArrayToString(array: record.feelingsEnd)
            tagsLabel.text = tagArrayToString(array: record.tags)
        } else {
            return
        }
    }
}
