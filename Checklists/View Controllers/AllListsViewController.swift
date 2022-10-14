//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Celeste Urena on 10/8/22.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enables large titles on navigation
        navigationController?.navigationBar.prefersLargeTitles = true
        // Creates custome TableView programmatically
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    /* Insert new object into the items array. Tell the All List
       table view you have new row for it and then close the list detail screen */
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist) {
            let newRowIndex = dataModel.lists.count
            dataModel.lists.append(checklist)
            
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            navigationController?.popViewController(animated: true)
    }
    
    // Updates the label for table view cell (edits it)
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist) {
            if let index = dataModel.lists.firstIndex(of: checklist) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.textLabel!.text = checklist.name
                }
            }
            navigationController?.popViewController(animated: true)
    }
    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController) {
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
    
    // MARK: - Navigation Controller Delegates
    func navigationController(
      _ navigationController: UINavigationController,
      willShow viewController: UIViewController,
      animated: Bool
    ) {
      // Was the back button tapped?
      if viewController === self {
          dataModel.indexOfSelectedChecklist = -1
      }
    }
    
    // Checks which checklist needs to be shown at startup
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)

      navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
        let checklist = dataModel.lists[index]
        performSegue(
          withIdentifier: "ShowChecklist",
          sender: checklist)
      }
    }
    
    // MARK: - Table view data source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return dataModel.lists.count
        }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Manually creates new cells
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            // Update cell information
            let checklist = dataModel.lists[indexPath.row]
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
            dataModel.lists.remove(at: indexPath.row)
            
            // Delete the corresponding row from the table view
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    
    // MARK: - Table View Delegate
    // Method for to toggle checkmark
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            // Store the index of the selected row into UserDefaults
            dataModel.indexOfSelectedChecklist = indexPath.row
            // Performs the segue to the Checklist scene
            let checklist = dataModel.lists[indexPath.row]
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
            
            let checklist = dataModel.lists[indexPath.row]
            controller.checklistToEdit = checklist
            
            navigationController?.pushViewController(controller, animated: true)
    }
}
