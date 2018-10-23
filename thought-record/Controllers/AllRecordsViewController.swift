//
//  TableViewController.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class AllRecordsViewController: UITableViewController {
    
    // MARK: Properties
    
    var records: [ThoughtRecord] = []
    var selectedRecordIndex = 0

    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecords()
        //loadSavedRecords()
        useLargeTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        saveRecords()
    }
}

// MARK: Private Implementation

extension AllRecordsViewController {
    
    func getRecords() {
        let database = ThoughtRecordDatabase()
        records = database.thoughts
    }
    
    func loadSavedRecords() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                records = try decoder.decode([ThoughtRecord].self, from: data)
            } catch {
                print("Error decoding")
            }
        }
    }
    
    func setCellTitle(recordAtPath: ThoughtRecord) -> String {
        let title = recordAtPath.thought
        let date = recordAtPath.shortDate
        return "\(date): \(title)"
    }
    
    func useLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: Table View Methods

extension AllRecordsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordListCell", for: indexPath)
        
        cell.textLabel?.text = setCellTitle(recordAtPath: records[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedRecordIndex = indexPath.row
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func deleteRecord(indexPath: IndexPath) {
        records.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        saveRecords()
    }
    
    func deletionAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Record?", message: nil, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
            self.deleteRecord(indexPath: indexPath)
        }
        )
        let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletionAlert(indexPath: indexPath)
        }
    }
}

// MARK: - Data Persistence

extension AllRecordsViewController {
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Records.plist")
    }
    
    func saveRecords() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(records)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding")
        }
    }
}

// MARK: - AddRecordViewControllerDelegate Methods

extension AllRecordsViewController: RecordDetailViewControllerDelegate {
    // this currently doesn't get called:
    func addRecordDidCancel(_ controller: RecordDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addRecordSave(_ controller: RecordDetailViewController, didFinishAdding item: ThoughtRecord) {
        records.append(item)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
        saveRecords()
    }
    
    // this doesn't get called, do we need it? doing its stuff in ViewWillAppear() - is that bad? - save in DetailVC
    func editRecordSave(_ controller: RecordDetailViewController, didFinishEditing item: ThoughtRecord) {
//        saveRecords()
//        tableView.reloadData()
    }
}

// MARK: - Navigation

extension AllRecordsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.detail.rawValue {
            guard let detailViewController = segue.destination as? RecordDetailViewController else { return }
            detailViewController.recordToShow = records[selectedRecordIndex]
            detailViewController.currentMode = Mode.view
        }
        else if segue.identifier == SegueIdentifier.add.rawValue {
            guard let addViewController = segue.destination as? RecordDetailViewController else { return }
            addViewController.delegate = self
            addViewController.currentMode = Mode.add
        }
    }
}
