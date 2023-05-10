//
//  CompletedTaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/30.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct CompletedTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>

    var navigationTitle: String = ""
    var color: Color = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    @State private var deleteIndex = 0
    @State private var showConfirm = false
    @State private var newToDoTask = ""
    @State private var newNote = ""
    

    
    //設定慾刪除之index
    func SetDeleteIndex(at index: IndexSet)
    {
        self.showConfirm = true
        self.deleteIndex = index.first!
    }
    
    //刪除
    func delete() {
        self.toDoLists[4].tasks.remove(at: deleteIndex)
        
        do{
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    var body: some View {

        ZStack {
            
            GeometryReader { geo in
                Image("Completed")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            
            VStack {
                
                List {
                    ForEach(self.toDoLists[4].tasks, id: \.self) { index in
                        CompletedTaskRow(task: index)
                    }.onDelete { indexSet in
                            self.SetDeleteIndex(at: indexSet) //點擊刪除時的動作
                    }
                }
                    
                //是否顯示刪除對話框
                .alert(isPresented: $showConfirm) {
                    Alert(title: Text("\(toDoLists[4].tasks[self.deleteIndex].title!)"), message: Text("Are you sure to delete the task?"),
                              primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Delete")) {
                                self.delete()
                            })
                }
            }
            
        }
        .navigationBarTitle(Text(self.navigationTitle), displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
}


