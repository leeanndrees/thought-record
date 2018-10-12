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
        useLargeTitles()
    }
}

// MARK: Private Implementation

extension AllRecordsViewController {
    
    func getRecords() {
        let database = ThoughtRecordDatabase()
        records = database.thoughts
    }
    
    func setCellTitle(recordAtPath: ThoughtRecord) -> String {
        let title = recordAtPath.thought
        let date = recordAtPath.date
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
    
    func swipeToDelete(indexPath: IndexPath) {
        records.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    func deleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Are you sure?", message: "For real?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
            self.records.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        )
        let actionNo = UIAlertAction(title: "Nevermind", style: .default, handler: nil)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAlert(indexPath: indexPath)
            //swipeToDelete(indexPath: indexPath)
        }
    }
}

// MARK: - Navigation

extension AllRecordsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.detail.rawValue {
            guard let detailViewController = segue.destination as? RecordDetailViewController else { return }
            detailViewController.recordToShow = records[selectedRecordIndex]
        }
    }
}
