//
//  DataModel.swift
//  Checklists
//
//  Created by Celeste Urena on 10/14/22.
//

import Foundation

// Responsible for loading and saving
class DataModel {
    var lists = [Checklist]()
    
    // Ensures that as soon as DataModel loads it will attempt to load Checklists.plist
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // MARK: - Data Saving
    // Method to return full path to the Documents folder (for data persistence)
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    // Uses documentsDirectory() to construct the full path to the file that will store the checklist
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    /* Takes contents of the checklist and converts it to a block
     of binary data and then writes this data to a file */
    func saveChecklists() {
        // Create instance of PropertyListEncoder
        let encoder = PropertyListEncoder()
        // Sets up a block of code to catch Swift errors
        do {
            let data = try encoder.encode(lists)
            
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    // Loads contents saved to Checklists.plist (by saveChecklists)
    func loadChecklists() {
        // Puts results of dataFilePath in a temp var
        let path = dataFilePath()
        // Try to load the contents of Checklists.plist
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                // Load the saved data back into items
                lists = try decoder.decode(
                    [Checklist].self,
                    from: data)
                sortChecklists()
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    
    // Sorts the Checklists array
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    // Creates a new Dictionary instance and adds the value -1 for the key "ChecklistIndex"
    func registerDefaults() {
        let dictionary = [
            "ChecklistIndex": -1,
            // Checks wether this is the first time the user runs the app
            "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // Automatically updates UserDefaults
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(
                forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: "ChecklistIndex")
        }
    }
    
    // Creates a new checklist object and adds it to the array if it's the first time the app is being run
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    // Generates a unique item ID for notifications
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
}
