//
//  ViewController.swift
//  Checklists
//
//  Created by Celeste Urena on 10/5/22.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist! // Checklist object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Changes the title of the screen to the name of the Checklist object
        title = checklist.name
    }
    
    // Makes checkmark visible or invisible according to current state
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem) { // Directly passes ChecklistItem object (parameter)
            
            let label = cell.viewWithTag(1001) as! UILabel
            
            if item.checked {
                label.text = "√"
            } else {
                label.text = ""
            }
        }
    
    // Sets the checklist item's text on the cell's label
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem) {
            // Asks table view cell for the view with tag 1000
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = item.text
        }
    
    // MARK: - Add ItemViewController Delegates
    func ItemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController) {
            navigationController?.popViewController(animated: true)
        }
    
    /* Insert new object into the items array. Tell the ChecklistItem
     table view you have new row for it and then close the Add Items screen */
    func ItemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem) {
            let newRowIndex = checklist.items.count
            checklist.items.append(item)
            
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            navigationController?.popViewController(animated: true)
        }
    
    // Updates the label for table view cell (edits it)
    func ItemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem) {
            if let index = checklist.items.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?) {
            // Checking for correct segue by using the identifier
            if segue.identifier == "AddItem" {
                // cast destination to AddItemViewController to get a ref. to an object with the right type
                let controller = segue.destination as! ItemDetailViewController
                // Set delegate property to self so the connection is complete
                controller.delegate = self
            } else if segue.identifier == "EditItem" {
                // If user taps on edit button
                let controller = segue.destination as! ItemDetailViewController
                controller.delegate = self
                
                // Required for table view cell whose disclosure button was tapped
                if let indexPath = tableView.indexPath(
                    for: sender as! UITableViewCell) {
                    controller.itemToEdit = checklist.items[indexPath.row]
                }
            }
        }
    
    // MARK: - Table View Data Source
    // Data source protocol for table view
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int { // Method signature
            return checklist.items.count // Returns actual number of items in the array
        }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Method signature
            // Gets a copy of prototype cell and puts it into a local constant (cell)
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ChecklistItem",
                for: indexPath) // indexPath is an object that points to a specific row in the table
            
            /* Asks the array global var for the ChecklistItem
             object at the index that corresponds to the row number */
            let item = checklist.items[indexPath.row]
            
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
            return cell
        }
    
    // Method for swipe-to-delete row/checklist
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            // remove the item from the data model
            checklist.items.remove(at: indexPath.row)
            
            // Delete the corresponding row from the table view
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    
    // MARK: - Table View Delegate
    // Method for to toggle checkmark
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath) {
                
                let item = checklist.items[indexPath.row]
                // toggles the "checked" state from false to true and vice versa
                item.checked.toggle()
                
                configureCheckmark(for: cell, with: item)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
}
