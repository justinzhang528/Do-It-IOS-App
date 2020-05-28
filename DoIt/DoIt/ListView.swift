//
//  ListView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/28.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoTask.getAlltoDoTasks()) var toDoTasks: FetchedResults<ToDoTask>
    
    @State private var newToDoTask = ""
    @State private var isTextFieldEmpty = true
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add New Task")){
                    HStack {
                        TextField("New Task", text: self.$newToDoTask)
                        Button(action:{
                            if (self.newToDoTask == ""){
                                self.isTextFieldEmpty = true
                            }else{
                                self.isTextFieldEmpty = false
                            }
                            if (!self.isTextFieldEmpty) {
                                let toDoTask = ToDoTask(context: self.managedObjectContext)
                                toDoTask.title = self.newToDoTask
                                toDoTask.createdAt = Date()
                                
                                do {
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error)
                                }
                                self.newToDoTask = ""
                            }
                        }){
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header: Text("New List")) {
                    ForEach(self.toDoTasks) { (index) in ToDoTaskView(title: index.title!, createdAt: "\(index.createdAt!)")
                    }.onDelete { indexSet in
                        let deleteItem = self.toDoTasks[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        
                        do{
                            try self.managedObjectContext.save()
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("New List"))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
