//
//  TaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/29.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoTasks()) var toDoTasks: FetchedResults<ToDoList>
    
    @State private var tasks: [Task]
    @State private var deleteIndex = 0
    @State private var showConfirm = false
    @State private var newToDoTask = ""
    
    //設定慾刪除之index
    func SetDeleteIndex(at index: IndexSet)
    {
        self.showConfirm = true
        self.deleteIndex = index.first!
    }
    
    //刪除
    func delete() {
        let deleteItem = self.toDoTasks[self.deleteIndex]
        self.managedObjectContext.delete(deleteItem)
        
        do{
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add New Task")){
                    HStack {
                        TextField("New Task", text: self.$newToDoTask)
                        Button(action:{
                            if (self.newToDoTask != ""){
                                let toDoTask = ToDoList(context: self.managedObjectContext)
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
                    ForEach(self.toDoTasks) { (index) in
                        ToDoListView(title: index.title!, createdAt: "\(index.createdAt!)", taskTitle: "\(index.tasks.count)")
                        }.onDelete { indexSet in
                            self.SetDeleteIndex(at: indexSet) //點擊刪除時的動作
                    }
                }
                //當showConfirm為true時執行一下程式碼
                .alert(isPresented: $showConfirm) {
                    Alert(title: Text("\(toDoTasks[self.deleteIndex].title!)"), message: Text("Are you sure to delete this list?"),
                              primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Delete")) {
                                self.delete()
                            })
                }
            }
            .navigationBarTitle(Text("New List"))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
