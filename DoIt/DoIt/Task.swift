//
//  Task.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/28.
//  Copyright © 2020 NTUT. All rights reserved.
//

import Foundation

public class Task: NSObject, NSCoding {
    
    public var title:String?
    public var createdAt:Date?
    public var note:String?
    public var isImportant:Bool = false
    public var isCompleted:Bool = false
    public var isRemind:Bool = false
    public var remindAt:Date?
    public var dueDate:Date?
    
    enum Key:String {
        case title = "title"
        case createdAt = "createdAt"
        case note = "note"
        case remindAt = "remindAt"
        case dueDate = "dueDate"
        case isImportant = "isImportant"
        case isCompleted = "isCompleted"
        case isRemind = "isRemind"
    }
    
    init(title: String, createdAt: Date, note: String, remindAt: Date, dueDate: Date) {
        self.title = title
        self.createdAt = createdAt
        self.note = note
        self.remindAt = remindAt
        self.dueDate = dueDate
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: Key.title.rawValue)
        coder.encode(createdAt, forKey: Key.createdAt.rawValue)
        coder.encode(note, forKey: Key.note.rawValue)
        coder.encode(isImportant, forKey: Key.isImportant.rawValue)
        coder.encode(isCompleted, forKey: Key.isCompleted.rawValue)
        coder.encode(isRemind, forKey: Key.isRemind.rawValue)
        coder.encode(remindAt, forKey: Key.remindAt.rawValue)
        coder.encode(dueDate, forKey: Key.dueDate.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mTitle = coder.decodeObject(forKey: Key.title.rawValue) as! String
        let mCreatedAt = coder.decodeObject(forKey: Key.createdAt.rawValue) as! Date
        let mNote = coder.decodeObject(forKey: Key.note.rawValue) as! String
        let mRemindAt = coder.decodeObject(forKey: Key.remindAt.rawValue) as! Date
        let mDueDate = coder.decodeObject(forKey: Key.dueDate.rawValue) as! Date
        
        self.init(title: mTitle, createdAt: mCreatedAt, note: mNote, remindAt: mRemindAt, dueDate: mDueDate)
    }

}
