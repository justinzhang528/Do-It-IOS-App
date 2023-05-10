//
//  TaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/29.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct MyDayTaskView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
    @FetchRequest(fetchRequest: LocalNotificationManager.getAllNotifications()) var notifications: FetchedResults<LocalNotificationManager>
    
    @State var listIndex: Int = 0
    var navigationTitle: String = ""
    
    @State private var deleteIndex = 0
    @State private var showConfirm = false
    @State private var showActionSheet = false
    @State private var isShowFloatingButton = true
    @State private var isShowTextField = false
    @State private var renameString = ""
    @State private var newToDoTask = ""
    @State private var newNote = ""
    @State private var value : CGFloat = 0
    @State private var actionSheetButtons : [ActionSheet.Button] = [ActionSheet.Button]()
    

    
    //設定慾刪除之index
    func SetDeleteIndex(at index: IndexSet)
    {
        self.showConfirm = true
        self.deleteIndex = index.first!
    }
    
    //刪除
    func delete() {
        self.toDoLists[self.listIndex].tasks.remove(at: deleteIndex)
        
        do{
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }
        
        self.UpdateNotificationSchedule()
    }
    
    func moveTask(task: Task, listIndex: Int) {
        task.createdAt = Date()
        self.toDoLists[listIndex].tasks.append(task)
        self.delete()
    }
    
    
    func renameDialog(){

        let alertController = UIAlertController(title: "Rename", message: self.renameString, preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Type here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
            self.toDoLists[self.listIndex].tasks[self.deleteIndex].title = alertController.textFields![0].text
            let task = self.toDoLists[self.listIndex].tasks[self.deleteIndex]
            self.delete()
            self.toDoLists[self.listIndex].tasks.append(task)

            self.UpdateNotificationSchedule()
        })


        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)

    }
    
    func UpdateNotificationSchedule(){
       notifications[0].cancelAllNotifications()
       for list in toDoLists {
          for task in toDoLists[toDoLists.firstIndex(of: list)!].tasks {
            if (task.isRemind! && !task.isCompleted! && task.remindAt! > Date()) {
                notifications[0].addNotification(task: task)
                notifications[0].scheduleNotifications()
             }
          }
       }
    }
    
    
    var body: some View {
                    
        ZStack {
            
            GeometryReader { geo in
                Image("My Day")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            
            VStack {
                
                HStack {
                    Image(systemName: "sun.max.fill")
                    .resizable()
                    .fixedSize()
                    .foregroundColor(Color.red)
                    Text(CustomDateFormatter().Formatter(date: Date(), format: "yyyy-MM-dd")).font(.headline).foregroundColor(Color.red)
                    Image(systemName: "sun.max.fill")
                    .resizable()
                    .fixedSize()
                    .foregroundColor(Color.red)
                }.padding(.top)
                
                List {
                    Section(header: Text("Added Tasks").font(.headline)) {
                        ForEach(self.toDoLists, id: \.self) { number in
                            ForEach(self.toDoLists[self.toDoLists.firstIndex(of: number)!].tasks, id: \.self) { index in
                                Group {
                                    
                                    if(CustomDateFormatter().Formatter(date: index.dueDate!, format: "yyyy-MM-dd") == CustomDateFormatter().Formatter(date: Date(), format: "yyyy-MM-dd") && self.toDoLists.firstIndex(of: number)! != 4)
                                    {
                                        HStack{

                                            Image(systemName: "circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .onTapGesture {
                                                self.deleteIndex = self.toDoLists[self.toDoLists.firstIndex(of: number)!].tasks.firstIndex(of: index)!
                                                self.listIndex = self.toDoLists.firstIndex(of: number)!
                                                self.renameString = index.title!
                                                self.showActionSheet.toggle()
                                                
                                                //根據listview決定actionsheet button的內容
                                                let buttons = [
                                                    ActionSheet.Button.default(Text("Mark as Completed"), action: {
                                                        index.isCompleted = true
                                                        self.moveTask(task: index, listIndex: 4)
                                                        self.UpdateNotificationSchedule()
                                                    }),
                                                    ActionSheet.Button.default(Text("Rename"), action: {
                                                        self.renameDialog()
                                                    }),
                                                    ActionSheet.Button.cancel()
                                                ]
                                                
                                                self.actionSheetButtons.removeAll()
                                                for i in 0...2 {
                                                    self.actionSheetButtons.append(buttons[i])
                                                }
                                                //根據listview決定actionsheet button的內容
                                                
                                            }
                                            MyDayTaskRow(task: index, listIndex: self.toDoLists.firstIndex(of: number)!, taskIndex: self.toDoLists[self.toDoLists.firstIndex(of: number)!].tasks.firstIndex(of: index)!, title: index.title!, note: index.note!, isRemind: index.isRemind!, remindAt: index.remindAt!, dueDate: index.dueDate!)
                                            
                                            
                                        }
                                        .actionSheet(isPresented: self.$showActionSheet) { () -> ActionSheet in
                                            ActionSheet(title: Text("Choose Action"), buttons: self.actionSheetButtons)
                                        }
                                    }
                                    
                                }
                                
                            }.onDelete { indexSet in
                                self.listIndex = self.toDoLists.firstIndex(of: number)!
                                    self.SetDeleteIndex(at: indexSet) //點擊刪除時的動作
                            }
                        }
                    }
                }
                //是否顯示刪除對話框
                .alert(isPresented: $showConfirm) {
                    Alert(title: Text("\(toDoLists[self.listIndex].tasks[self.deleteIndex].title!)"), message: Text("Are you sure to delete the task?"),
                              primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Delete")) {
                                self.delete()
                            })
                }
                    
                    
                /*是否顯示重命名對話框
                    .alert(isPresented: $showTextAlert, TextAlert(title: "Rename", name: renameString, action: {_ in
                        
                    }))*/
                
                if(isShowTextField)
                {
                    Group {
                        
                        HStack {
                            Image(systemName: "pencil").resizable().frame(width: 30, height: 30)
                            Text("Title:")
                            TextField(" New Task", text: self.$newToDoTask).frame(height: 35).overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                            Button(action:{
                                self.isShowTextField = false
                                self.isShowFloatingButton = true
                                if (self.newToDoTask != ""){
                                    self.toDoLists[0].tasks.append(Task(title: self.newToDoTask, createdAt: Date(), note: self.newNote, remindAt: Date(), dueDate: Date(), isImportant: false, isRemind: false, isCompleted: false))
                                    
                                    do {
                                        try self.managedObjectContext.save()
                                    }catch{
                                        print(error)
                                    }
                                                                            
                                    self.newToDoTask = ""
                                    self.newNote = ""
                                }
                            }){
                                Text("Add Task")
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .imageScale(.large)
                            }
                        }.padding(.top).padding(.leading).padding(.trailing)
                        
                        HStack {
                            Image(systemName: "doc.text").resizable().frame(width: 30, height: 40)
                            Text("Note:")
                            MultilineTextView(text: self.$newNote).frame(height: 60).overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                            
                        }.padding(.bottom).padding(.leading).padding(.trailing)
                        
                    }.font(.headline)
                }
                                
            }
            
            if(isShowFloatingButton)
            {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.isShowTextField = true
                            self.isShowFloatingButton = false
                        }, label: {
                            Text("+")
                            .font(.system(.largeTitle))
                            .frame(width: 77, height: 70)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                        })
                        .background(Color.blue)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    }
                }.animation(.none)
            }
            
        }
        .navigationBarTitle(Text(self.navigationTitle), displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
            
        //處理鍵盤彈出時view往上移動
        .offset(y: -self.value)
            .animation(.spring())
            .onAppear {
                self.isShowTextField = false
                self.isShowFloatingButton = true
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (noti) in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    self.value = height
                    self.isShowFloatingButton = false
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                    self.value = 0
                    self.isShowTextField = false
                    self.isShowFloatingButton = true
                }
        }
            //處理鍵盤彈出時view往上移動
    }
}

/*struct ImportantTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}*/
