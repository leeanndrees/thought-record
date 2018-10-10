//
//  RecordDetailViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class RecordDetailViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thoughtLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var feelingsStartLabel: UILabel!
    @IBOutlet weak var unhelpfulThoughtsLabel: UILabel!
    @IBOutlet weak var factsSupportingLabel: UILabel!
    @IBOutlet weak var factsAgainstLabel: UILabel!
    @IBOutlet weak var balancedPerspectiveLabel: UILabel!
    @IBOutlet weak var feelingsEndLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
}
