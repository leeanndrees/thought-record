//
//  SettingsViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/17/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let settingOptions = ["Allow Text Analysis"]
    var userSettingForAnalysis: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useLargeTitles()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        cell.textLabel?.text = settingOptions[indexPath.row]

        return cell
    }
    
    func useLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func analysisSettingSwitchChanged(_ sender: UISwitch) {
        userSettingForAnalysis = sender.isOn
    }
    

}
