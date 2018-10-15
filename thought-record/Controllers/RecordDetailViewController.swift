//
//  RecordDetailViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class RecordDetailViewController: UITableViewController {
    
    // MARK: Properties
    
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
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayRecordData()
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

}

// MARK: Private Implementation

extension RecordDetailViewController {
    
    private func feelingsArrayToString(array: [Feeling]) -> String {
        var feelingNames: [String] = []
        for feeling in array {
            let feelingString = "\(feeling.name) (\(feeling.rating))"
            feelingNames.append(feelingString)
        }
        let feelingListString = feelingNames.joined(separator: ", ")
        return feelingListString
    }
    
    private func tagArrayToString(array: [Tag]) -> String {
        var tagNames: [String] = []
        for tag in array {
            tagNames.append(tag.name)
        }
        let tagListString = tagNames.joined(separator: ", ")
        return tagListString
    }
    
    private func displayRecordData() {
        if let record = recordToShow {
            dateLabel.text = "Date: \(record.date)"
            thoughtLabel.text = "Thought: \(record.thought)"
            situationLabel.text = "Situation: \(record.situation)"
            feelingsStartLabel.text = "Feelings at time: \(feelingsArrayToString(array: record.feelingsStart))"
            unhelpfulThoughtsLabel.text = "Unhelpful Thoughts: \(record.unhelpfulThoughts)"
            factsSupportingLabel.text = "Facts Supporting Unhelpful Thoughts: \(record.factsSupporting)"
            factsAgainstLabel.text = "Facts Opposing Unhelpful Thoughts: \(record.factsAgainst)"
            balancedPerspectiveLabel.text = "More Balanced Perspective: \(record.balancedPerspective)"
            feelingsEndLabel.text = "Feelings After Unpacking: \(feelingsArrayToString(array: record.feelingsEnd))"
            tagsLabel.text = "Tags: \(tagArrayToString(array: record.tags))"
        } else {
            return
        }
    }
    
}

// MARK: Table View Methods

extension RecordDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
