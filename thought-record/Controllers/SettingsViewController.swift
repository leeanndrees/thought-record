//
//  SettingsViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/17/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let persistence = DataPersistence()
    let settingOptions = ["Allow Text Analysis"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedSettings()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else { return UITableViewCell() }

        cell.textLabel?.text = settingOptions[indexPath.row]
        
        cell.settingSwitch.isOn = userSettings.allowTextAnalysis
        
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func analysisSettingSwitchChanged(_ sender: UISwitch) {
        userSettings.allowTextAnalysis = sender.isOn
        saveSettings()
    }

}

// MARK: Data Persistence

extension SettingsViewController {
    
    func dataFilePath() -> URL {
        return persistence.documentsDirectory().appendingPathComponent("Settings.plist")
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
    
    func loadSavedSettings() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                userSettings = try decoder.decode(Settings.self, from: data)
            } catch {
                print("Error decoding")
            }
        }
    }
    
}
