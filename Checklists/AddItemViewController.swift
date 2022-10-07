//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Celeste Urena on 10/6/22.
//

import UIKit

// Delegate protocol (contact between addItemViewController and ChecklistViewController)
protocol AddItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(
        _ controller: AddItemViewController)
    func addItemViewController(
        _ controller: AddItemViewController,
        didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    // var to refer back to ChecklistViewController
    weak var delegate: AddItemViewControllerDelegate?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Keyboard automatically shows up on the screen when Add Item controller is opened
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    // Tells navigation controller to close the Add Item screen
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    // Sends text field input to ChecklistViewController
    @IBAction func done(_ sender: Any) {
        let item = ChecklistItem()
        item.text = textField.text!
        
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
    // MARK: - Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    // Disallows empty keyboard input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
}
