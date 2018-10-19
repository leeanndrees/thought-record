//
//  NewRecordDetailViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/18/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var recordToShow: ThoughtRecord?
    
    // MARK: Outlets
    
    /// View Collections:
    @IBOutlet var viewModeViews: [UIStackView]!
    @IBOutlet var editModeViews: [UIStackView]!
    
    /// Labels:
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thoughtSummaryLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var unhelpfulThoughtsLabel: UILabel!
    @IBOutlet weak var beforeFeelingLabel: UILabel!
    @IBOutlet weak var factsSupportingLabel: UILabel!
    @IBOutlet weak var factsAgainstLabel: UILabel!
    @IBOutlet weak var balancedPerspectiveLabel: UILabel!
    @IBOutlet weak var afterFeelingLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editModeViews.forEach { (view) in
            view.isHidden = true
        }
        
        displayThoughtRecordData()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editButtonTap(_ sender: Any) {
        viewModeViews.forEach { (view) in
            view.isHidden = true
        }
        editModeViews.forEach { (view) in
            view.isHidden = false
        }
    }
    
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
    
    func displayThoughtRecordData() {
        if let record = recordToShow {
            dateLabel.text = "Date: \(record.longDate)"
            thoughtSummaryLabel.text = "Thought: \(record.thought)"
            situationLabel.text = "Situation: \(record.situation)"
            beforeFeelingLabel.text = "Feelings at time: \(feelingsArrayToString(array: record.feelingsStart))"
            unhelpfulThoughtsLabel.text = "Unhelpful Thoughts: \(record.unhelpfulThoughts)"
            factsSupportingLabel.text = "Facts Supporting Unhelpful Thoughts: \(record.factsSupporting)"
            factsAgainstLabel.text = "Facts Opposing Unhelpful Thoughts: \(record.factsAgainst)"
            balancedPerspectiveLabel.text = "More Balanced Perspective: \(record.balancedPerspective)"
            afterFeelingLabel.text = "Feelings After Unpacking: \(feelingsArrayToString(array: record.feelingsEnd))"
            tagsLabel.text = "Tags: \(tagArrayToString(array: record.tags))"
        } else {
            return
        }
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
