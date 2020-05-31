//
//  ToDoTask.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/28.
//  Copyright © 2020 NTUT. All rights reserved.
//

import Foundation
import CoreData

public class ToDoList:NSManagedObject, Identifiable {
    @NSManaged public var title:String?
    @NSManaged public var createdAt:Date?
    @NSManaged public var note:String?
    @NSManaged public var remindAt:Date?
    @NSManaged public var dueDate:Date?
}

extension ToDoList {
    static func getAlltoDoTasks() -> NSFetchRequest<ToDoList> {
        let request:NSFetchRequest<ToDoList> = ToDoList.fetchRequest() as!
            NSFetchRequest<ToDoList>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
        
    }
}
