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
    func addRecordSave(_ controller: RecordDetailViewController, didFinishAdding item: ThoughtRecord)
}

class RecordDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var recordToShow: ThoughtRecord?
    var currentMode: Mode?
    var newRecord: ThoughtRecord?
    weak var delegate: RecordDetailViewControllerDelegate?
    var toneID = ""
    var userChosenDate = Date()
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
        
        guard let mode = currentMode else { return }
        setMode(to: mode)
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

// MARK: Mode Methods

extension RecordDetailViewController {
    
    private func setMode(to mode: Mode) {
        setViewVisibility(for: mode)
        displayData(for: mode)
        setBarButtonItem(for: mode)
        setDate(for: mode)
        
        if mode == .add {
            thoughtSummaryField.becomeFirstResponder()
            setSuggestButtonVisibility()
        }
    }
    
    private func setViewVisibility(for mode: Mode) {
        switch mode {
        case .view:
            show(views: viewModeViews)
            hide(views: editModeViews)
        case .add, .edit:
            show(views: editModeViews)
            hide(views: viewModeViews)
        }
    }
    
    private func displayData(for mode: Mode) {
        switch mode {
        case .view:
            displayThoughtRecordData()
        case .edit:
            displayEditModeData()
        case .add:
            return
        }
    }
    
    private func setBarButtonItem(for mode: Mode) {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        let saveEditedButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEdited))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        let magenta = UIColor(named: "BrightMagenta")
        
        saveButton.tintColor = magenta
        editButton.tintColor = magenta
        saveEditedButton.tintColor = magenta
        
        switch mode {
        case .view:
            self.navigationItem.rightBarButtonItem = editButton
        case .add:
            self.navigationItem.rightBarButtonItem = saveButton
            self.navigationItem.leftBarButtonItem = cancelButton
        case .edit:
            self.navigationItem.rightBarButtonItem = saveEditedButton
            self.navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setDate(for mode: Mode) {
        switch mode {
        case .edit:
            userChosenDate = recordToShow?.date ?? Date().now()
            setDateButtonText(date: userChosenDate)
        case .add:
            let today = Date().now()
            setDateButtonText(date: today)
        case .view:
            return
        }
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
}

// MARK: Data Display Methods

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

// MARK: Record Creation/Saving Methods

extension RecordDetailViewController {
    
    @objc func editButtonTapped() {
        currentMode = .edit
        // why is it making me force unwrap currentMode below when I just set a value above?
        setMode(to: currentMode!)
    }
    
    @objc func save() {
        guard let newRecord = createNewRecord() else { navigationController?.popViewController(animated: true); return }
        
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
        
        setMode(to: .view)
    }
    
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
    
    private func setSuggestButtonVisibility() {
        suggestButton.isHidden = !userSettings.allowTextAnalysis
    }
    
    private func setDateButtonText(date: Date) {
        dateButton.setTitle(formattedFullDate(date: date), for: .normal)
    }
    
    private func generateTags() -> [Tag] {
        let tagInputArray = splitTagInput()
        var newTags: [Tag] = []
        
        for name in tagInputArray {
            newTags.append(Tag(name: name))
        }
        
        return newTags
    }
    
    private func formattedFullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateFormatter.date(from: dateString)
        
        return dateFormatter.string(from: formattedDate!)
    }
    
}

// MARK: API Methods

extension RecordDetailViewController {
    
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
    
}
