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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useLargeTitles()
    }

    // MARK: Table view data source

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
    
    // MARK: Actions
    
    @IBAction func analysisSettingSwitchChanged(_ sender: UISwitch) {
        userSettings.allowTextAnalysis = sender.isOn
        saveSettings()
    }

}

// MARK: Private Implementation

extension SettingsViewController {
    
    private func useLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

// MARK: Data Persistence

extension SettingsViewController {
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Settings.plist")
    }
    
    func saveSettings() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(userSettings)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding")
        }
    }
    
}
