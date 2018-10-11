//
//  AddRecordViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/11/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class AddRecordViewController: UITableViewController {

    // MARK: Outlets
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var sliderLabel1: UILabel!
    @IBOutlet weak var sliderLabel2: UILabel!
    @IBOutlet weak var sliderLabel3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateButtonText(date: Date())
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderLabel1.text = String(Int(sender.value))
    }
    
    @IBAction func sliderValue2Changed(_ sender: UISlider) {
        sliderLabel2.text = String(Int(sender.value))
    }
    
    @IBAction func sliderValue3Changed(_ sender: UISlider) {
        sliderLabel3.text = String(Int(sender.value))
    }
    
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let todayString = dateFormatter.string(from: date)
        let formattedToday = dateFormatter.date(from: todayString)
        
        return dateFormatter.string(from: formattedToday!)
    }
    
    func getCurrentDate() -> Date {
        return Date()
    }
    
    func setDateButtonText(date: Date) {
        dateButton.setTitle(formattedDate(date: date), for: .normal)
    }

    // let's redo this, maybe with a xib?
    @IBAction func dateButtonTapped(_ sender: Any) {
        let datePicker = UIDatePicker()
        let dateChooserAlert = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        
        // this doesn't work yet:
        let dateChosen = UIAlertAction(title: "Done", style: .default) { action in
            let newDate = datePicker.date
            self.setDateButtonText(date: newDate)
        }
        
        dateChooserAlert.addAction(dateChosen)
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
}
