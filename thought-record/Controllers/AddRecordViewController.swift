//
//  AddRecordViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/11/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit
import ToneAnalyzer

protocol AddRecordViewControllerDelegate: class {
    func addEventDidCancel(_ controller: AddRecordViewController)
    func addEventSave(_ controller: AddRecordViewController, didFinishAdding item: ThoughtRecord)
}

class AddRecordViewController: UITableViewController {

    // MARK: Outlets
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var sliderLabel1: UILabel!
    @IBOutlet weak var sliderLabel2: UILabel!
    @IBOutlet weak var sliderLabel3: UILabel!
    
    @IBOutlet weak var thoughtField: UITextField!
    @IBOutlet weak var situationField: UITextField!
    @IBOutlet weak var unhelpfulThoughtsView: UITextView!
    
    @IBOutlet weak var beforeFeeling1Field: UITextField!
    @IBOutlet weak var beforeFeeling1Slider: UISlider!
    @IBOutlet weak var beforeFeeling2Field: UITextField!
    @IBOutlet weak var beforeFeeling2Slider: UISlider!
    @IBOutlet weak var beforeFeeling3Field: UITextField!
    @IBOutlet weak var beforeFeeling3Slider: UISlider!
    
    @IBOutlet weak var factsSupportingView: UITextView!
    @IBOutlet weak var factsAgainstView: UITextView!
    @IBOutlet weak var balancedPerspectiveView: UITextView!
    
    @IBOutlet weak var afterFeeling1Field: UITextField!
    @IBOutlet weak var afterFeeling1Slider: UISlider!
    
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
        sliderLabel1.text = String(Int(sender.value))
    }
    
    @IBAction func sliderValue2Changed(_ sender: UISlider) {
        sliderLabel2.text = String(Int(sender.value))
    }
    
    @IBAction func sliderValue3Changed(_ sender: UISlider) {
        sliderLabel3.text = String(Int(sender.value))
    }

    @IBAction func dateButtonTapped(_ sender: Any) {
        showDatePickerActionSheet()
    }
    
    @IBAction func save() {
        guard let newRecord = createNewRecord() else { navigationController?.popViewController(animated: true); return }
    
        delegate?.addEventSave(self, didFinishAdding: newRecord)
    }
        
}

// MARK: Private Implementation

extension AddRecordViewController {
    
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let todayString = dateFormatter.string(from: date)
        let formattedToday = dateFormatter.date(from: todayString)
        
        return dateFormatter.string(from: formattedToday!)
    }
    
    private func getCurrentDate() -> Date {
        return Date()
    }
    
    private func setDateButtonText(date: Date) {
        dateButton.setTitle(formattedDate(date: date), for: .normal)
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
        let newFeeling1 = Feeling(name: beforeFeeling1Field.text!, rating: Int(beforeFeeling1Slider!.value))
        
        let newTag = Tag(name: tagsField.text!, useCount: 1)
        
        guard let newThought = thoughtField.text,
            let newSituation = situationField.text,
            let newUnhelpfulThoughts = unhelpfulThoughtsView.text,
            let newFactsSupporting = factsSupportingView.text,
            let newFactsAgainst = factsAgainstView.text,
            let newBalancedPerspective = balancedPerspectiveView.text else { return nil }
        
        
        newRecord = ThoughtRecord(date: createNewRecordDate(), thought: newThought, situation: newSituation, feelingsStart: [newFeeling1], unhelpfulThoughts: newUnhelpfulThoughts, factsSupporting: newFactsSupporting, factsAgainst: newFactsAgainst, balancedPerspective: newBalancedPerspective, feelingsEnd: [newFeeling1], tags: [newTag])
        
        return newRecord
    }
    
    private func createNewRecordDate() -> String {
        var newDate: String
        if let dateOfEntry = dateButton.titleLabel?.text {
            newDate = dateOfEntry
        } else {
            newDate = formattedDate(date: Date())
        }
        return newDate
    }
    
}

// MARK: API Methods

extension AddRecordViewController {
    
    func checkTone() {
        let text = "I'm so happy this finally works! :D"
        
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


// MARK: Table View Methods

extension AddRecordViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
