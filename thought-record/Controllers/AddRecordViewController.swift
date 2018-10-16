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
    func addEventDidCancel(_ controller: AddRecordViewControllerOld)
    func addEventSave(_ controller: AddRecordViewControllerOld, didFinishAdding item: ThoughtRecord)
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
