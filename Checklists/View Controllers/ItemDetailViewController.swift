//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Celeste Urena on 10/6/22.
//

import UIKit

// Delegate protocol (contact between ItemDetailViewController and ChecklistViewController)
protocol ItemDetailViewControllerDelegate: AnyObject {
    func ItemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController)
    func ItemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem)
    func ItemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    // var to refer back to ChecklistViewController
    weak var delegate: ItemDetailViewControllerDelegate?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // new property for a ChecklistItem object
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changes view controller title to Edit Item if user is editing
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    // Keyboard automatically shows up on the screen when Add Item controller is opened
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    // Tells navigation controller to close the Add/Edit Item screen
    @IBAction func cancel(_ sender: Any) {
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    // Method to finish adding or editing an item
    @IBAction func done(_ sender: Any) {
        
        // Checks wether the itemToEdit property contains an object
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.ItemDetailViewController(
                self,
                didFinishEditing: item)
        } else { // else add new item
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.ItemDetailViewController(
                self,
                didFinishAdding: item)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    // Disallows empty keyboard input
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        
        // If the text is not empty, enable the button. Else don't enable it
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    // Gives users a quick and easy way to clear text
    func textFieldShouldClear(
        _ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
}
