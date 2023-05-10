//
//  ToDoTaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/29.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct MyDayTaskRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
    
    var task: Task    
    var listIndex: Int
    var taskIndex: Int
    
    @State private var scaleValue = CGFloat(1)
    @State var title: String
    @State var note: String
    @State var isRemind: Bool
    @State var remindAt: Date
    @State var dueDate: Date
    
    func updateContext(){
       for list in self.toDoLists{
          let index: Int = self.toDoLists.firstIndex(of: list) ?? 0
          self.toDoLists[index].tasks.append(Task(title: "...", createdAt: Date(), note: "", remindAt: Date(), dueDate: Date(), isImportant: false, isRemind: false, isCompleted: false))
        
          self.toDoLists[index].tasks.remove(at: (self.toDoLists[index].tasks.count - 1))
          
          do {
              try self.managedObjectContext.save()
          }catch{
              print(error)
          }
          
       }
    }
    
    
    var body: some View {
        HStack{
            
            NavigationLink(destination: TaskOptionView(task: self.task, listIndex: self.listIndex, taskIndex: self.taskIndex)){
                VStack(alignment: .leading, spacing: 5){
                    Text(task.title!).font(.headline)
                    if(task.note != ""){
                        HStack(alignment: .top){
                            Image(systemName: "doc.on.clipboard").fixedSize()
                            Text("Note:").font(.caption)
                            Text(task.note!).font(.caption)
                        }
                    }
                    if(task.isRemind! && task.remindAt! > Date()){
                        HStack{
                            Image(systemName: "bell").fixedSize()
                            Text("Remind At: " + "\((CustomDateFormatter().Formatter(date: task.remindAt!, format: "yyyy-MM-dd") == CustomDateFormatter().Formatter(date: Date(), format: "yyyy-MM-dd")) ? "Today " + "\(CustomDateFormatter().Formatter(date: task.remindAt!, format: "HH:mm"))" : CustomDateFormatter().Formatter(date: task.remindAt!, format: "yyyy-MM-dd' 'HH:mm"))").font(.caption)
                        }
                    }
                }
            }
            
            Spacer()
            Image(systemName: task.isImportant! ? "star.fill" : "star")
                .resizable()
                .frame(width: 25, height: 25)
                .scaleEffect(self.scaleValue)
                .onTouchGesture(
                    touchBegan: {
                        withAnimation { self.scaleValue = 1.5 }
                        self.task.isImportant!.toggle()
                        self.updateContext()
                },
                    touchEnd: { _ in withAnimation { self.scaleValue = 1.0 } }
                    
                )
            
        }
        
    }
}

/*struct ToDoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoTaskRow()
    }
}*/

