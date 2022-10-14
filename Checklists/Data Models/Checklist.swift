//
//  Checklist.swift
//  Checklists
//
//  Created by Celeste Urena on 10/8/22.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    // Creates a new empty array that can hold ChecklistItem
    var items: [ChecklistItem] = []
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
