//
//  AddRecordViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/16/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit
import ToneAnalyzer

protocol AddRecordViewControllerDelegate: class {
    func addRecordDidCancel(_ controller: AddRecordViewController)
    func addRecordSave(_ controller: AddRecordViewController, didFinishAdding item: ThoughtRecord)
}

class AddRecordViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var thoughtField: UITextField!
    @IBOutlet weak var situationField: UITextField!
    
    @IBOutlet weak var unhelpfulThoughtsView: UITextView!
    
    @IBOutlet weak var beforeFeelingField: UITextField!
    @IBOutlet weak var beforeFeelingSlider: UISlider!
    @IBOutlet weak var beforeFeelingRatingLabel: UILabel!
    @IBOutlet weak var suggestButton: UIButton!
    
    @IBOutlet weak var factsSupportingView: UITextView!
    @IBOutlet weak var factsAgainstView: UITextView!
    
    @IBOutlet weak var balancedPerspectiveView: UITextView!
    
    @IBOutlet weak var afterFeelingField: UITextField!
    @IBOutlet weak var afterFeelingSlider: UISlider!
    @IBOutlet weak var afterFeelingRatingLabel: UILabel!
    
    @IBOutlet weak var tagsField: UITextField!
    
    // MARK: Properties
    
    var newRecord: ThoughtRecord?
    weak var delegate: AddRecordViewControllerDelegate?
    var toneID = ""
    var userChosenDate = Date()
    let database = TagDatabase()
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateButtonText(date: Date())
        showOrHideSuggestButton()
    }

    // MARK: Actions
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        beforeFeelingRatingLabel.text = String(Int(sender.value))
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        showDatePickerActionSheet()
    }
    
    @IBAction func suggestButtonTapped(_ sender: UIButton) {
        checkTone(of: generateToneString())
    }
    
    @IBAction func save() {
        guard let newRecord = createNewRecord() else { navigationController?.popViewController(animated: true); return }
        
        checkTagExistence(tagNames: splitTagInput())
        
        delegate?.addRecordSave(self, didFinishAdding: newRecord)
    }

}

// MARK: Private Implementation

extension AddRecordViewController {
    
    private func formattedFullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateFormatter.date(from: dateString)
        
        return dateFormatter.string(from: formattedDate!)
    }
    
    private func formattedShortDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateFormatter.date(from: dateString)
        
        return dateFormatter.string(from: formattedDate!)
    }
    
    private func getCurrentDate() -> Date {
        return Date()
    }
    
    private func setDateButtonText(date: Date) {
        dateButton.setTitle(formattedFullDate(date: date), for: .normal)
    }
    
    private func showDatePickerActionSheet() {
        let datePicker = UIDatePicker()
        let datePickerAlert = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
        datePickerAlert.view.addSubview(datePicker)
        
        let dateChosen = UIAlertAction(title: "Done", style: .default) { action in
            let newDate = datePicker.date
            self.setDateButtonText(date: newDate)
            self.userChosenDate = newDate
        }
        
        datePickerAlert.addAction(dateChosen)
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: datePickerAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        datePickerAlert.view.addConstraint(height)
        self.present(datePickerAlert, animated: true, completion: nil)
    }
    
    private func createNewRecord() -> ThoughtRecord? {
        let newFeelingBefore = Feeling(name: beforeFeelingField.text!, rating: Int(beforeFeelingSlider!.value))
        
        let newFeelingAfter = Feeling(name: afterFeelingField.text!, rating: Int(afterFeelingSlider!.value))
        
        let newTag = Tag(name: tagsField.text!, useCount: 1)
        
        guard let newThought = thoughtField.text,
            let newSituation = situationField.text,
            let newUnhelpfulThoughts = unhelpfulThoughtsView.text,
            let newFactsSupporting = factsSupportingView.text,
            let newFactsAgainst = factsAgainstView.text,
            let newBalancedPerspective = balancedPerspectiveView.text else { return nil }
        
        
        newRecord = ThoughtRecord(date: userChosenDate, thought: newThought, situation: newSituation, feelingsStart: [newFeelingBefore], unhelpfulThoughts: newUnhelpfulThoughts, factsSupporting: newFactsSupporting, factsAgainst: newFactsAgainst, balancedPerspective: newBalancedPerspective, feelingsEnd: [newFeelingAfter], tags: [newTag])
        
        return newRecord
    }
    
    func showOrHideSuggestButton() {
        if userSettings.allowTextAnalysis == false {
            suggestButton.isHidden = true
        }
        else {
            suggestButton.isHidden = false
        }
    }
    
}

// MARK: API Methods

extension AddRecordViewController {
    
    func generateToneString() -> String {
        let thoughtText = thoughtField.text!
        let unhelpfulThoughtsText = unhelpfulThoughtsView.text!
        
        let toneString = "\(thoughtText) \(unhelpfulThoughtsText)"
        return toneString
    }
    
    func checkTone(of text: String)  {
        toneAnalyzer.tone(toneContent: ToneContent.text(text), sentences: false, tones: nil, contentLanguage: nil, acceptLanguage: nil, headers: nil, failure: { (error) in
            print(error)
        }) { (response) in
            DispatchQueue.main.async {
                self.toneID = self.getToneID(from: response)
                self.populateSuggestionField(with: self.getExpandedFeelingName(from: self.toneID))
            }
        }
    }
    
    func getToneID(from analysis: ToneAnalysis) -> String {
        if let toneID = analysis.documentTone.tones?[0].toneID {
            return toneID
        }
        else {
            return "no suggestion"
        }
    }
    
    func getExpandedFeelingName(from toneID: String) -> String {
        let expandedTones = ExpandedTones()
        
        switch toneID {
        case Tone.anger.rawValue: return expandedTones.angerTones.randomElement() ?? "angry"
        case Tone.fear.rawValue: return expandedTones.fearTones.randomElement() ?? "afraid"
        case Tone.joy.rawValue: return expandedTones.joyTones.randomElement() ?? "joyful"
        case Tone.sadness.rawValue: return expandedTones.sadnessTones.randomElement() ?? "sad"
        case Tone.analytical.rawValue: return expandedTones.analyticalTones.randomElement() ?? "analytical"
        case Tone.confident.rawValue: return expandedTones.confidentTones.randomElement() ?? "confident"
        case Tone.tentative.rawValue: return expandedTones.tentativeTones.randomElement() ?? "tentative"
        default: return "sorry, no suggestion"
        }
    }
    
    func populateSuggestionField(with text: String) {
            beforeFeelingField.text = text
    }
}

// MARK: Tagging

extension AddRecordViewController {
    
    func splitTagInput() -> [String] {
        let tagInput = tagsField.text!
        let allTagsAdded = tagInput.split(separator: ",")
        var tagsTrimmed: [String] = []
        for tag in allTagsAdded {
            let trimmed = tag.trimmingCharacters(in: .whitespaces)
            tagsTrimmed.append(trimmed)
        }
        return tagsTrimmed
    }
    
    func checkTagExistence(tagNames: [String]) {
        var existingTagNames: [String] = []
        
        for tag in database.tags {
            existingTagNames.append(tag.name)
        }
        print(existingTagNames)
        
        for name in tagNames {
            if existingTagNames.contains(name) {
                let existingTag = database.tags.filter { $0.name == name }
                //existingTag.updateUseCount()
            }
            else {
                let newTag = Tag(name: name, useCount: 1)
                database.tags.append(newTag)
            }
        }
    }
    

}
