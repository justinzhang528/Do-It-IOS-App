//
//  ToDoTaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/29.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct PlannedTaskRow: View {
    var task: Task
    
    @State private var scaleValue = CGFloat(1)
    
    
    var body: some View {
        HStack{
            
            NavigationLink(destination: TaskOptionView(task: self.task)){
                VStack(alignment: .leading){
                    Text(task.title!).font(.headline)
                    Text("Note: " + task.note!).font(.caption)
                    if(task.isRemind){
                        Text("Remind at: " + CustomDateFormatter().Formatter(date: task.remindAt!, format: "yyyy-MM-dd' 'HH:mm")).font(.caption)
                    }
                    Text("Due Date: " + CustomDateFormatter().Formatter(date: task.dueDate!, format: "yyyy-MM-dd")).font(.caption)
                }
            }
            
            Spacer()
            Image(systemName: task.isImportant ? "star.fill" : "star")
                .resizable()
                .frame(width: 25, height: 25)
                .scaleEffect(self.scaleValue)
                .onTouchGesture(
                    touchBegan: {
                        withAnimation { self.scaleValue = 1.5 }
                        self.task.isImportant.toggle()
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
