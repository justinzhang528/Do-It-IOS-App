//
//  ToDoTaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/29.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct ToDoTaskRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
    
    var task: Task
    var listIndex: Int
    var taskIndex: Int
    @State var title: String
    @State var note: String
    @State private var scaleValue = CGFloat(1)
    
    
    var body: some View {
        HStack{
            
            NavigationLink(destination: TaskOptionView(task: self.task)){
                VStack(alignment: .leading){
                    Text(task.title!).font(.headline)
                    Text("Note: " + task.note!).font(.caption)
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
                        self.toDoLists[self.listIndex].tasks[self.taskIndex].isImportant = self.task.isImportant
                        
                        do{
                            try self.managedObjectContext.save()
                        }catch{
                            print(error)
                        }
                },
                    touchEnd: { _ in
                        withAnimation { self.scaleValue = 1.0  } }
                    
                )
            
        }
        
    }
}

/*struct ToDoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoTaskRow()
    }
}*/
