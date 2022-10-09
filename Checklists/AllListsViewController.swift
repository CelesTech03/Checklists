//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Celeste Urena on 10/8/22.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    var lists = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enables large titles on navigation
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // Placeholder data
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
    }
    
    // MARK: - Lsit Detail View Controller Delegates
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController) {
            navigationController?.popViewController(animated: true)
    }
    
    /* Insert new object into the items array. Tell the All List
       table view you have new row for it and then close the list detail screen */
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist) {
            let newRowIndex = lists.count
            lists.append(checklist)
            
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            navigationController?.popViewController(animated: true)
    }
    
    // Updates the label for table view cell (edits it)
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist) {
            if let index = lists.firstIndex(of: checklist) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.textLabel!.text = checklist.name
                }
            }
            navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    // Passes Checklist object to ChecklistViewController
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Table view data source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return lists.count
        }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Manually creates new cells
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            // Update cell information
            let checklist = lists[indexPath.row]
            cell.textLabel!.text = checklist.name
            cell.accessoryType = .detailDisclosureButton
            
            return cell
        }
    
    // Method for swipe-to-delete row/checklist
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            // remove the item from the data model
            lists.remove(at: indexPath.row)
            
            // Delete the corresponding row from the table view
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    
    // MARK: - Table View Delegate
    // Method for to toggle checkmark
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            // Performs the segue to the Checklist scene
            let checklist = lists[indexPath.row]
            performSegue(
                withIdentifier: "ShowChecklist",
                sender: checklist)
        }
    
    // Method to edit a checklist
    override func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath) {
            let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
            controller.delegate = self
            
            let checklist = lists[indexPath.row]
            controller.checklistToEdit = checklist
            
            navigationController?.pushViewController(controller, animated: true)
    }
}
