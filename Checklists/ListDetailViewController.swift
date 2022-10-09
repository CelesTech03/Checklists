//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Celeste Urena on 10/8/22.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController)
    
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist)
    
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Changes the title of the screen if the user is editing an existing checklist
           and puts the checklist's name into the text field */
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    // Method to make keyboard pop up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    // Tells navigation controller to close the Add/Edit Checklist screen
    @IBAction func cancel(_ sender: Any) {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    // Method to finish adding or editing a schecklist
    @IBAction func done(_ sender: Any) {
        // Checks wether the checklistToEdit property contains an object
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.listDetailViewController(
                self,
                didFinishEditing: checklist)
        } else { // else add new checklist
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewController(
                self,
                didFinishAdding: checklist)
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
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
