//
//  TableViewMethods.swift
//  thought-record
//
//  Created by DetroitLabs on 10/24/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    
    func useLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setTitleColor() {
        let darkPurple = UIColor(named: "DarkPurple")
        
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: darkPurple!]
    }
    
}
