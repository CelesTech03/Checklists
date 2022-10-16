//
//  Checklist.swift
//  Checklists
//
//  Created by Celeste Urena on 10/8/22.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    // Creates a new empty array that can hold ChecklistItem
    var items: [ChecklistItem] = []
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // Method to count number of unchecked items
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items {
            if !item.checked {
                count += 1
            }
        }
        return count
    }
    
}
