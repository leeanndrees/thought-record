//
//  RecordDetailViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/18/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit
import ToneAnalyzer

protocol RecordDetailViewControllerDelegate: class {
    func addRecordDidCancel(_ controller: RecordDetailViewController)
    func addRecordSave(_ controller: RecordDetailViewController, didFinishAdding item: ThoughtRecord)
    func editRecordSave(_ controller: RecordDetailViewController, didFinishEditing item: ThoughtRecord)
}

class RecordDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var recordToShow: ThoughtRecord?
    var currentMode: Mode?
    var newRecord: ThoughtRecord?
    weak var delegate: RecordDetailViewControllerDelegate?
    var toneID = ""
    var userChosenDate = Date()
    let database = TagDatabase()
    let datePicker = UIDatePicker()
    
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
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        
        if currentMode == Mode.view {
            hide(views: editModeViews)
            displayThoughtRecordData()
            self.navigationItem.rightBarButtonItem = editButton
            userChosenDate = recordToShow?.date ?? Date()
        }
        
        if currentMode == Mode.add {
            hide(views: viewModeViews)
            show(views: editModeViews)
            thoughtSummaryField.becomeFirstResponder()
            setDateButtonText(date: Date())
            showOrHideSuggestButton()
            self.navigationItem.rightBarButtonItem = saveButton
        }
 
    }
    
    // MARK: Actions
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        showDatePickerActionSheet()
    }
    
    @IBAction func beforeFeelingSliderValueChanged(_ sender: UISlider) {
        beforeFeelingRatingLabel.text = String(Int(sender.value))
    }
    
    @IBAction func afterFeelingSliderValueChanged(_ sender: UISlider) {
        afterFeelingRatingLabel.text = String(Int(sender.value))
    }
    
    @IBAction func suggestButtonTapped(_ sender: UIButton) {
        checkTone(of: generateToneString())
    }
    
}

// MARK: Private Implementation

extension RecordDetailViewController {
    
    private func setMode(to mode: Mode) {
        
    }
    
    private func showViews(for mode: Mode) {
        switch mode {
        case .view:
            show(views: viewModeViews)
        case .add, .edit:
            show(views: editModeViews)
        }
    }
    
    private func hideViews(for mode: Mode) {
        switch mode {
        case .view:
            hide(views: editModeViews)
        case .add, .edit:
            hide(views: viewModeViews)
        }
    }
    
    @objc func editButtonTapped() {
        currentMode = .edit
        
        show(views: editModeViews)
        hide(views: viewModeViews)
        
        displayEditModeData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEdited))
    }
    
    @objc func save() {
        // our else condition should maybe show an error instead of doing nothing
        guard let newRecord = createNewRecord() else { navigationController?.popViewController(animated: true); return }
        
        checkTagExistence(tagNames: splitTagInput())
        
        delegate?.addRecordSave(self, didFinishAdding: newRecord)
    }
    
    @objc func saveEdited() {
        guard let recordToUpdate = recordToShow else { return }
        recordToUpdate.date = userChosenDate
        recordToUpdate.thought = thoughtSummaryField.text!
        recordToUpdate.situation = situationField.text!
        recordToUpdate.unhelpfulThoughts = unhelpfulThoughtsView.text!
        recordToUpdate.feelingsStart = [createBeforeFeeling()]
        recordToUpdate.factsSupporting = factsSupportingView.text!
        recordToUpdate.factsAgainst = factsContradictingView.text!
        recordToUpdate.balancedPerspective = balancedPerspectiveView.text!
        recordToUpdate.feelingsEnd = [createAfterFeeling()]
        recordToUpdate.tags = generateTags()
        
        delegate?.editRecordSave(self, didFinishEditing: recordToUpdate)
        
        hide(views: editModeViews)
        show(views: viewModeViews)
        displayThoughtRecordData()
    }
    
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
    
    private func formattedFullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        /// are these steps in this order necessary?
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
    
    /// this reads easier to me than Date(), but it's basically just that. Is there a way to alias functions? - could extend Date, something like Date.now
    private func getCurrentDate() -> Date {
        return Date()
    }
    
    private func setDateButtonText(date: Date) {
        dateButton.setTitle(formattedFullDate(date: date), for: .normal)
    }
    
    /// this method needs breaking up (or at least renaming) but how - could create/configure picker and then load it. probably not worth it?
    private func showDatePickerActionSheet() {
        let datePickerAlert = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
        datePickerAlert.view.addSubview(datePicker)
        
        let dateAction = UIAlertAction(title: "Done", style: .default) { action in
            let newDate = self.datePicker.date
            self.setDateButtonText(date: newDate)
            self.userChosenDate = newDate
        }
        
        datePickerAlert.addAction(dateAction)
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: datePickerAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        datePickerAlert.view.addConstraint(height)
        self.present(datePickerAlert, animated: true, completion: nil)
    }
    
    private func createBeforeFeeling() -> Feeling {
        return Feeling(name: beforeFeelingField.text!, rating: Int(beforeFeelingSlider!.value))
    }
    
    private func createAfterFeeling() -> Feeling {
        return Feeling(name: afterFeelingField.text!, rating: Int(afterFeelingSlider!.value))
    }
    
    private func generateTags() -> [Tag] {
        let tagInputArray = splitTagInput()
        var newTags: [Tag] = []
        
        for name in tagInputArray {
            newTags.append(Tag(name: name))
        }
        
        return newTags
    }
    
    private func createNewRecord() -> ThoughtRecord? {
        
        guard let newThought = thoughtSummaryField.text,
            let newSituation = situationField.text,
            let newUnhelpfulThoughts = unhelpfulThoughtsView.text,
            let newFactsSupporting = factsSupportingView.text,
            let newFactsAgainst = factsContradictingView.text,
            let newBalancedPerspective = balancedPerspectiveView.text else { return nil }
        
        newRecord = ThoughtRecord(date: userChosenDate, thought: newThought, situation: newSituation, feelingsStart: [createBeforeFeeling()], unhelpfulThoughts: newUnhelpfulThoughts, factsSupporting: newFactsSupporting, factsAgainst: newFactsAgainst, balancedPerspective: newBalancedPerspective, feelingsEnd: [createAfterFeeling()], tags: generateTags())
        
        return newRecord
    }
    
    private func showOrHideSuggestButton() {
        suggestButton.isHidden = !userSettings.allowTextAnalysis
    }
    
}

// MARK: API Methods

extension RecordDetailViewController {
    
    /// not sure how to fix these force unwraps
    private func generateToneString() -> String {
        let thoughtText = thoughtSummaryField.text!
        let unhelpfulThoughtsText = unhelpfulThoughtsView.text!
        
        let toneString = "\(thoughtText) \(unhelpfulThoughtsText)"
        return toneString
    }
    
    private func checkTone(of text: String)  {
        toneAnalyzer.tone(toneContent: ToneContent.text(text), sentences: false, tones: nil, contentLanguage: nil, acceptLanguage: nil, headers: nil, failure: { (error) in
            print(error)
        }) { (response) in
            DispatchQueue.main.async {
                self.toneID = self.getToneID(from: response)
                self.populateSuggestionField(with: self.getExpandedFeelingName(from: self.toneID))
            }
        }
    }
    
    private func getToneID(from analysis: ToneAnalysis) -> String {
        if let toneID = analysis.documentTone.tones?[0].toneID {
            return toneID
        }
        else {
            return "no suggestion"
        }
    }
    
    private func getExpandedFeelingName(from toneID: String) -> String {
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
    
    private func populateSuggestionField(with text: String) {
        beforeFeelingField.text = text
    }
}

// MARK: Tagging

extension RecordDetailViewController {
    
    private func splitTagInput() -> [String] {
        let tagInput = tagsField.text!
        let allTagsAdded = tagInput.split(separator: ",")
        var tagsTrimmed: [String] = []
        for tag in allTagsAdded {
            let trimmed = tag.trimmingCharacters(in: .whitespaces)
            tagsTrimmed.append(trimmed)
        }
        return tagsTrimmed
    }
    
    private func checkTagExistence(tagNames: [String]) {
        var existingTagNames: [String] = []
        print(tagNames)
        
        for tag in database.tags {
            existingTagNames.append(tag.name)
        }
        
        for name in tagNames {
            if existingTagNames.contains(name) {
                return
            }
            else {
                let newTag = Tag(name: name)
                database.tags.append(newTag)
                for tag in database.tags {
                    print(tag.name)
                }
            }
        }
    }
    
    
}
