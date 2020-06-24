//
//  ListView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/28.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI
import UserNotifications

struct ListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
    @FetchRequest(fetchRequest: LocalNotificationManager.getAllNotifications()) var notifications: FetchedResults<LocalNotificationManager>
    
    @State private var deleteIndex = 0
    @State private var isShowConfirm = false
    @State private var showActionSheet = false
    @State private var isShowTextField = false
    @State private var isShowFloatingButton = true
    @State private var newToDoList = ""
    @State private var renameString = ""
    @State private var value : CGFloat = 0
    @State private var notiAlert = false
    @State private var actionSheetButtons : [ActionSheet.Button] = [ActionSheet.Button]()
    
     
    func initializeList(){        
        //新增notification到coreData
        let notification = LocalNotificationManager(context: self.managedObjectContext)
        notification.createdAt = Date()
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
        self.isShowConfirm = true
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
        
        self.UpdateNotificationSchedule()
    }
    
    func renameDialog(){

        let alertController = UIAlertController(title: "Rename", message: self.renameString, preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Type here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
            self.toDoLists[self.deleteIndex].title = alertController.textFields![0].text
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
        
        NavigationView {
            
            ZStack {
                
                GeometryReader { geo in
                    Image("task")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                
                VStack {
                        
                        NavigationLink(destination: MyDayTaskView(navigationTitle: "My Day")) {
                            HStack {
                                Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                                Image(systemName: "sun.max.fill")
                                .resizable()
                                .fixedSize()
                                .foregroundColor(Color.red)
                                HStack {
                                    Text("My Day").font(.headline)
                                    Spacer()
                                    /*if (notifications.count > 0){
                                        Text("Notification: \(notifications[0].notifications.count)").font(.caption)
                                    }*/
                                }
                                Spacer()
                            }
                            .background(RoundedRectangle(cornerRadius: 40).fill(Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))))
                        }
                        
                        NavigationLink(destination: ImportantTaskView(navigationTitle: "Important")) {
                            HStack {
                                Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                                Image(systemName: "star.fill")
                                .resizable()
                                .fixedSize()
                                .foregroundColor(Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)))
                                HStack {
                                    Text("Important").font(.headline)
                                }
                                Spacer()
                            }
                            .background(RoundedRectangle(cornerRadius: 40).fill(Color(#colorLiteral(red: 0.9187197089, green: 0.5710100532, blue: 0.6108112335, alpha: 1))))
                        }
                        
                        NavigationLink(destination: PlannedTaskView(navigationTitle: "Planned")) {
                            HStack {
                                Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                                Image(systemName: "calendar")
                                .resizable()
                                .fixedSize()
                                .foregroundColor(Color.blue)
                                HStack {
                                    Text("Planned").font(.headline)
                                }
                                Spacer()
                            }
                            .background(RoundedRectangle(cornerRadius: 40).fill(Color(#colorLiteral(red: 0.5823103189, green: 0.916143477, blue: 0.6088748574, alpha: 1))))
                        }
                        
                        NavigationLink(destination: CompletedTaskView(navigationTitle: "Completed")) {
                            HStack {
                                Spacer().frame(width: 15, height: 50, alignment: .topLeading)
                                Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .fixedSize()
                                .foregroundColor(Color.black)
                                HStack {
                                    Text("Completed").font(.headline)
                                    Spacer()
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
                                        HStack {
                                            Image(systemName: "list.dash")
                                            .resizable()
                                            .frame(width: 30, height: 20)
                                            .onTapGesture {
                                                self.deleteIndex = self.toDoLists.firstIndex(of: list)!
                                                self.renameString = list.title!
                                                self.showActionSheet.toggle()
                                                
                                                //根據listview決定actionsheet button的內容
                                                let buttons = [
                                                    ActionSheet.Button.default(Text("Rename"), action: {
                                                        self.renameDialog()
                                                    }),
                                                    ActionSheet.Button.cancel()
                                                ]
                                                
                                                self.actionSheetButtons.removeAll()
                                                for i in 0...1 {
                                                    self.actionSheetButtons.append(buttons[i])
                                                }
                                                //根據listview決定actionsheet button的內容
                                            }

                                            ToDoListRow(title: list.title!, createdAt: "Created At: " + CustomDateFormatter().Formatter(date: list.createdAt!, format: "yyyy-MM-dd' 'HH:mm:ss"), taskCount: "Task count: \(list.tasks.count)", id: self.toDoLists.firstIndex(of: list))
                                            
                                            }.actionSheet(isPresented: self.$showActionSheet) { () -> ActionSheet in
                                                ActionSheet(title: Text("Choose Action"), buttons: self.actionSheetButtons)
                                            }
                                        }
                                    
                                    }.onDelete { indexSet in
                                        self.SetDeleteIndex(at: indexSet) //點擊刪除時的動作
                                }
                            }
                                
                            //是否顯示刪除對話框
                            .alert(isPresented: $isShowConfirm) {
                                Alert(title: Text("\(toDoLists[self.deleteIndex].title!)"), message: Text("Are you sure to delete the list?"),
                                          primaryButton: .cancel(),
                                          secondaryButton: .destructive(Text("Delete")) {
                                            self.delete()
                                        })
                            }
                        }
                        
                        if (isShowTextField)
                        {
                            HStack {
                                Image(systemName: "pencil").resizable().frame(width: 30, height: 30)
                                Text("Title:")
                                TextField(" New List", text: self.$newToDoList).frame(height: 35).overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.secondary, lineWidth: 1)
                                )
                                Button(action:{
                                    self.isShowFloatingButton = true
                                    self.isShowTextField = false
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
                        }
                                                
                    }.font(.headline).padding()
                    
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
                .navigationBarTitle(Text("Lists"), displayMode: .inline)
                .navigationBarItems(trailing: EditButton())
                
                //檢查是否有新增過defautList
                .onAppear(perform: {
                    if(self.toDoLists.count == 0){
                        self.initializeList()
                    }})
            
                //處理鍵盤彈出時view往上移動
                .offset(y: -self.value)
                    .animation(.default)
                    .onAppear {
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (noti) in
                            guard let value = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                                return
                            }
                            self.value = value.height
                            self.isShowFloatingButton = false
                        }
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                            self.value = 0
                            self.isShowTextField = false
                            self.isShowFloatingButton = true
                        }
                        //處理鍵盤彈出時view往上移動
                        
                        //notification權限要求
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ (status, _) in
                            if (status){
                                return
                            }
                            self.notiAlert.toggle()
                        }
                        
                        
                }.alert(isPresented: $notiAlert){
                    return Alert(title: Text("Please Enable Notification Access in Setting"))
                    }
                
        }
            
    }
    
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

