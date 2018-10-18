//
//  NewRecordDetailViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/18/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class NewRecordDetailViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var viewModeViews: [UIStackView]!
    @IBOutlet var editModeViews: [UIStackView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editModeViews.forEach { (view) in
            view.isHidden = true
        }

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
    
 
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
