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
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
    
    @State private var deleteIndex = 0
    @State private var showConfirm = false
    @State private var newToDoList = ""
    @State private var value : CGFloat = 0
    
    
    func initizeList(){
        let myDayList = ToDoList(context: self.managedObjectContext)
        myDayList.title = "My Day"
        myDayList.createdAt = Date()
        let importantList = ToDoList(context: self.managedObjectContext)
        importantList.title = "Important"
        importantList.createdAt = Date()
        let plannedList = ToDoList(context: self.managedObjectContext)
        plannedList.title = "Planned"
        plannedList.createdAt = Date()
        let completedList = ToDoList(context: self.managedObjectContext)
        completedList.title = "Completed"
        completedList.createdAt = Date()
        do {
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }
    }

    //設定慾刪除之index
    func SetDeleteIndex(at index: IndexSet)
    {
        self.showConfirm = true
        self.deleteIndex = index.first!
    }
    
    //刪除
    func delete() {
        let deleteItem = self.toDoLists[self.deleteIndex]
        self.managedObjectContext.delete(deleteItem)
        
        do{
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                NavigationLink(destination: TaskView(listIndex: 0, navigationTitle: "My Day", color: Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)))) {
                    HStack {
                        Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                        Image(systemName: "sun.max.fill")
                        .resizable()
                        .fixedSize()
                        .foregroundColor(Color.red)
                        HStack {
                            Text("My Day").font(.headline)
                            Spacer()
                            Text("\(toDoLists.count)").font(.caption)
                            if(toDoLists.count > 0) {
                                Text("\(toDoLists[0].tasks.count)").font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))))
                }
                
                NavigationLink(destination: TaskView(listIndex: 1, navigationTitle: "Important", color: Color(#colorLiteral(red: 0.9187197089, green: 0.5710100532, blue: 0.6108112335, alpha: 1)))) {
                    HStack {
                        Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                        Image(systemName: "star.fill")
                        .resizable()
                        .fixedSize()
                        .foregroundColor(Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)))
                        HStack {
                            Text("Important").font(.headline)
                            Spacer()
                            if(toDoLists.count > 1) {
                                Text("\(toDoLists[1].tasks.count)").font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color(#colorLiteral(red: 0.9187197089, green: 0.5710100532, blue: 0.6108112335, alpha: 1))))
                }
                
                NavigationLink(destination: TaskView(listIndex: 2, navigationTitle: "Planned", color: Color(#colorLiteral(red: 0.5823103189, green: 0.916143477, blue: 0.6088748574, alpha: 1)))) {
                    HStack {
                        Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                        Image(systemName: "calendar")
                        .resizable()
                        .fixedSize()
                        .foregroundColor(Color.blue)
                        HStack {
                            Text("Planned").font(.headline)
                            Spacer()
                            if(toDoLists.count > 2) {
                                Text("\(toDoLists[2].tasks.count)").font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color(#colorLiteral(red: 0.5823103189, green: 0.916143477, blue: 0.6088748574, alpha: 1))))
                }
                
                NavigationLink(destination: CompletedTaskView(navigationTitle: "Completed", color: Color(#colorLiteral(red: 0.82270962, green: 0.7489398122, blue: 0.9375836253, alpha: 1)))) {
                    HStack {
                        Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                        Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .fixedSize()
                        .foregroundColor(Color.black)
                        HStack {
                            Text("Completed").font(.headline)
                            Spacer()
                            if(toDoLists.count > 3) {
                                Text("\(toDoLists[3].tasks.count)").font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color(#colorLiteral(red: 0.82270962, green: 0.7489398122, blue: 0.9375836253, alpha: 1))))
                }
                
                List {
                    Section(header: Text("Added Lists")) {
                        ForEach(self.toDoLists) { (list) in
                            
                            //不顯示前四個DefaultList
                            if(self.toDoLists.firstIndex(of: list)! > 3){
                                ToDoListRow(title: list.title!, createdAt: "Created At: " + CustomDateFormatter().Formatter(date: list.createdAt!, format: "yyyy-MM-dd' 'HH:mm:ss"), taskCount: "Task count: \(list.tasks.count)", id: self.toDoLists.firstIndex(of: list))
                                }
                            
                            }.onDelete { indexSet in
                                self.SetDeleteIndex(at: indexSet) //點擊刪除時的動作
                        }
                    }.listRowBackground(Color(#colorLiteral(red: 0.6210807562, green: 0.9000057578, blue: 0.9218967557, alpha: 1)))
                        
                    //是否顯示刪除對話框
                    .alert(isPresented: $showConfirm) {
                        Alert(title: Text("\(toDoLists[self.deleteIndex].title!)"), message: Text("Are you sure to delete the list?"),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Delete")) {
                                    self.delete()
                                })
                    }
                }
                
                HStack {
                        Image(systemName: "pencil").resizable().frame(width: 30, height: 30)
                        Text("Title:")
                        TextField("New List", text: self.$newToDoList)
                        Button(action:{
                            if (self.newToDoList != ""){
                                let toDoTask = ToDoList(context: self.managedObjectContext)
                                toDoTask.title = self.newToDoList
                                toDoTask.createdAt = Date()
                                
                                do {
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error)
                                }
                                self.newToDoList = ""
                            }
                        }){
                            Text("Add List")
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                        }
                    }
                
                }.font(.headline).padding()
            
            .navigationBarTitle(Text("Lists"), displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
            //處理鍵盤彈出時view往上移動
            .offset(y: -self.value)
                .animation(.default)
                .onAppear {
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (noti) in
                        guard let value = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                            return
                        }
                        self.value = value.height
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                        self.value = 0
                    }
            }
            //處理鍵盤彈出時view往上移動
        }
        //檢查是否有新增過defautList
        .onAppear(perform: {
            if(self.toDoLists.count == 0){
                self.initizeList()
            }})
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
