//
//  ViewController.swift
//  Checklists
//
//  Created by Celeste Urena on 10/5/22.
//

import UIKit

class ChecklistViewController: UITableViewController {
    let row0text = "Walk the dog"
    let row1text = "Brush teeth"
    let row2text = "Learn iOS development"
    let row3text = "Soccer practice"
    let row4text = "Eat ice cream"
    
    var row0checked = false
    var row1checked = true
    var row2checked = true
    var row3checked = false
    var row4checked = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Makes checkmark visible or invisible according to "row checked" var
    func configureCheckmark(
        for cell: UITableViewCell,
        at indexPath: IndexPath) {
            var isChecked = false
            
            if indexPath.row == 0 {
                isChecked = row0checked
            } else if indexPath.row == 1 {
                isChecked = row1checked
            } else if indexPath.row == 2 {
                isChecked = row2checked
            } else if indexPath.row == 3 {
                isChecked = row3checked
            } else if indexPath.row == 4 {
                isChecked = row4checked
            }
            
            if isChecked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        }
    
    // MARK: - Table View Data Source
    // Data source protocol for table view
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int { // Method signature
            return 5
        }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Method signature
            // Gets a copy of prototype cell and puts it into a local constant (cell)
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ChecklistItem",
                for: indexPath) // indexPath is an object that points to a specific row in the table
            
            // Asks table view cell for the view with tag 1000
            let label = cell.viewWithTag(1000) as! UILabel
            
            if indexPath.row == 0 {
                label.text = row0text
            } else if indexPath.row == 1 {
                label.text = row1text
            } else if indexPath.row == 2 {
                label.text = row2text
            } else if indexPath.row == 3 {
                label.text = row3text
            } else if indexPath.row == 4 {
                label.text = row4text
            }
            // End of code block
            
            configureCheckmark(for: cell, at: indexPath)
            return cell
        }
    
    // MARK: - Table View Delegate
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath) {
                
                // toggles the "checked" state from false to true and vice versa
                if indexPath.row == 0 {
                    row0checked.toggle()
                } else if indexPath.row == 1 {
                    row1checked.toggle()
                } else if indexPath.row == 2 {
                    row2checked.toggle()
                } else if indexPath.row == 3 {
                    row3checked.toggle()
                } else if indexPath.row == 4 {
                    row4checked.toggle()
                }
                
                configureCheckmark(for: cell, at: indexPath)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
}
