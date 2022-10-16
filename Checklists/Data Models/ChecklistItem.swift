//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Celeste Urena on 10/6/22.
//

import Foundation
import UserNotifications

// Combines the text and checked vars into one object
class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    // Local notification properties
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    // Deletes a ChecklistItem
    deinit {
        removeNotification()
    }
    
    // Method to schedule a new local notification
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // Puts item's text into the notification message
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            // Extracts the year, month, hour, and minute from the dueDate
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate)
            // Shows the notification at the specified date
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false)
            // Creates UNNotificationRequest object
            let request = UNNotificationRequest(
                identifier: "\(itemID)",
                content: content,
                trigger: trigger)
            // Add the new notification to the UNUserNotificationCenter
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    // Removed the local notification for this ChecklistItem, if it exists
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
}
