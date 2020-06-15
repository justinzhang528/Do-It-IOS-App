//
//  LocalNotificationManager.swift
//  DoIt
//
//  Created by 張維俊 on 2020/6/13.
//  Copyright © 2020 NTUT. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData

public class Notification: NSObject, NSCoding {
    
    public var id: String?
    public var title: String?
    public var remindAt: Date = Date()
    public var dueDate: Date = Date()
    
    init(id: String, title: String){
        self.id = id
        self.title = title
    }
    
    enum Key:String {
        case id = "id"
        case title = "title"
        case remindAt = "remindAt"
        case dueDate = "dueDate"
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Key.id.rawValue)
        coder.encode(title, forKey: Key.title.rawValue)
        coder.encode(remindAt, forKey: Key.remindAt.rawValue)
        coder.encode(dueDate, forKey: Key.dueDate.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mID = coder.decodeObject(forKey: Key.id.rawValue) as! String
        let mTitle = coder.decodeObject(forKey: Key.title.rawValue) as! String
        
        self.init(id: mID, title: mTitle)
    }
}

public class LocalNotificationManager: NSManagedObject, Identifiable {
    @NSManaged public var notifications: [Notification]
    @NSManaged public var createdAt: Date?
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ (status, _) in
            if (status){
                return
            }
        }
    }
    
    func addNotification(task: Task) {
        let notification = Notification(id: UUID().uuidString, title: task.title!)
        notification.remindAt = task.remindAt!
        notification.dueDate = task.dueDate!
        notifications.append(notification)
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = "Reminder : \(notification.title!) " + " \(CustomDateFormatter().Formatter(date: notification.remindAt, format: "HH:mm"))"
            content.subtitle = "Due Date : \(CustomDateFormatter().Formatter(date: notification.dueDate, format: "yyyy-MM-dd"))"
            content.sound = UNNotificationSound.default
            
            let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notification.remindAt)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id!, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(String(describing: notification.id))")
            }
        }
    }
    
    func cancelAllNotifications(){
        notifications.removeAll()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension LocalNotificationManager {
    static func getAllNotifications() -> NSFetchRequest<LocalNotificationManager> {
        let request:NSFetchRequest<LocalNotificationManager> = LocalNotificationManager.fetchRequest() as!
            NSFetchRequest<LocalNotificationManager>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
        
    }
}
