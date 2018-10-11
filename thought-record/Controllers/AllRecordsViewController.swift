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

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecords()
        useLargeTitles()
    }

    // MARK: - Table view data source

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
    
    func useLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.detail.rawValue {
            guard let detailViewController = segue.destination as? RecordDetailViewController else { return }
            detailViewController.recordToShow = records[selectedRecordIndex]
        }
    }
    
    // MARK: Private Implementation
    
    func getRecords() {
        let database = ThoughtRecordDatabase()
        records = database.thoughts
    }
    
    func setCellTitle(recordAtPath: ThoughtRecord) -> String {
        let shortTitle = recordAtPath.thought
        let date = recordAtPath.date
        return "\(date): \(shortTitle)"
    }

}
