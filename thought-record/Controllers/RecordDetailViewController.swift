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
    
    /// Edit Mode UI Elements:
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var thoughtSummaryField: UITextField!
    @IBOutlet var situationField: UITextField!
    @IBOutlet var unhelpfulThoughtsView: UITextView!
    @IBOutlet var beforeFeelingField: UITextField!
    @IBOutlet var beforeFeelingSlider: UISlider!
    @IBOutlet var beforeFeelingRatingLabel: UILabel!
    @IBOutlet var suggestButton: UIButton!
    @IBOutlet var factsSupportingView: UITextView!
    @IBOutlet var factsContradictingView: UITextView!
    @IBOutlet var balancedPerspectiveView: UITextView!
    @IBOutlet var afterFeelingField: UITextField!
    @IBOutlet var afterFeelingSlider: UISlider!
    @IBOutlet var afterFeelingRatingLabel: UILabel!
    @IBOutlet var tagsField: UITextField!
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hide(views: editModeViews)
        displayThoughtRecordData()
    }
    
    // MARK: Actions
    
    @IBAction func editButtonTap(_ sender: UIBarButtonItem) {
        show(views: editModeViews)
        hide(views: viewModeViews)
        
        displayEditModeData()
        
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: nil)
    }
    
}

// MARK: Private Implementation

extension RecordDetailViewController {
    
    private func show(views: [UIView]) {
        views.forEach { (view) in
            view.isHidden = false
        }
    }
    
    private func hide(views: [UIView]) {
        views.forEach { (view) in
            view.isHidden = true
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
    
    private func displayThoughtRecordData() {
        if let record = recordToShow {
            dateLabel.text = record.longDate
            thoughtSummaryLabel.text = record.thought
            situationLabel.text = record.situation
            beforeFeelingLabel.text = feelingsArrayToString(array: record.feelingsStart)
            unhelpfulThoughtsLabel.text = record.unhelpfulThoughts
            factsSupportingLabel.text = record.factsSupporting
            factsAgainstLabel.text = record.factsAgainst
            balancedPerspectiveLabel.text = record.balancedPerspective
            afterFeelingLabel.text = feelingsArrayToString(array: record.feelingsEnd)
            tagsLabel.text = tagArrayToString(array: record.tags)
        } else {
            return
        }
    }
    
    private func displayEditModeData() {
        if let record = recordToShow {
            dateButton.setTitle(record.longDate, for: .normal)
            thoughtSummaryField.text = record.thought
            situationField.text = record.situation
            unhelpfulThoughtsView.text = record.unhelpfulThoughts
            beforeFeelingField.text = record.feelingsStart[0].name
            beforeFeelingSlider.value = Float(record.feelingsStart[0].rating)
            beforeFeelingRatingLabel.text = String(record.feelingsStart[0].rating)
            factsSupportingView.text = record.factsSupporting
            factsContradictingView.text = record.factsAgainst
            balancedPerspectiveView.text = record.balancedPerspective
            afterFeelingField.text = record.feelingsEnd[0].name
            afterFeelingSlider.value = Float(record.feelingsEnd[0].rating)
            afterFeelingRatingLabel.text = String(record.feelingsEnd[0].rating)
            tagsField.text = tagArrayToString(array: record.tags)
            
        }
        else {
            return
        }
    }
    
}
