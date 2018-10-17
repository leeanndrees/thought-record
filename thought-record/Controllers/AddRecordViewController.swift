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
    
    // MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setDateButtonText(date: Date())
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
        
        
        newRecord = ThoughtRecord(date: createNewRecordDate(), thought: newThought, situation: newSituation, feelingsStart: [newFeelingBefore], unhelpfulThoughts: newUnhelpfulThoughts, factsSupporting: newFactsSupporting, factsAgainst: newFactsAgainst, balancedPerspective: newBalancedPerspective, feelingsEnd: [newFeelingAfter], tags: [newTag])
        
        return newRecord
    }
    
    private func createNewRecordDate() -> String {
        var newDate: String
        if let dateOfEntry = dateButton.titleLabel?.text {
            newDate = dateOfEntry
        } else {
            newDate = formattedShortDate(date: Date())
        }
        return newDate
    }
    
}

// MARK: API Methods

extension AddRecordViewController {
    
    func generateToneString() -> String {
        let thoughtText = thoughtField.text!
        let unhelpfulThoughtsText = unhelpfulThoughtsView.text!
        
        let toneString = "\(thoughtText) \(unhelpfulThoughtsText)"
        print(toneString)
        return toneString
    }
    
    func checkTone(of text: String) {
        toneAnalyzer.tone(toneContent: ToneContent.text(text), sentences: false, tones: nil, contentLanguage: nil, acceptLanguage: nil, headers: nil, failure: { (error) in
            print(error)
        }) { (response) in
            print(response)
            
            if response.documentTone.tones != nil {
                if let toneName = response.documentTone.tones?[0].toneName {
                    print(toneName)
                } else {
                    print("no suggestion")
                }
            }
            
            //print(response.documentTone.tones?[0].toneName ?? "no suggestion")
        }
    }
    
}
