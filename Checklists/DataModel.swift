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
                print("Error encoding item arra: \(error.localizedDescription)")
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
                } catch {
                    print("Error decoding list array: \(error.localizedDescription)")
                }
            }
        }
    
}
