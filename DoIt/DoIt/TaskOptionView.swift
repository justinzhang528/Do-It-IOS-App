//
//  TaskOptionView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/6/6.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct TaskOptionView: View {
    
   var task: Task
   var listIndex: Int
   var taskIndex: Int
   @State private var isShowRemindDate = false
   @State private var isShowDueDate = false
   @State private var isShowEditNote = false   
   @State private var value : CGFloat = 0
    
    var body: some View {
         
         ZStack {
            
            GeometryReader { geo in
               Image("task")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            
            VStack(alignment: .leading, spacing: 30) {
                   
                   HStack {
                       Image(systemName: "bell")
                        .resizable()
                        .frame(width:30, height:30)
                       Text("Remind Me")
                     Spacer()
                   }.onTapGesture {
                     self.isShowRemindDate.toggle()
               }
                   
                   HStack {
                       Image(systemName: "calendar")
                        .resizable()
                        .frame(width:30, height:30)
                       Text("Set Due Date")
                   }.onTapGesture {
                   self.isShowDueDate.toggle()
               }
               
                   
                   HStack {
                       Image(systemName: "doc.on.clipboard")
                        .resizable()
                        .frame(width:30, height:35)
                       Text("Edit Note")
                   }.onTapGesture {
                   self.isShowEditNote.toggle()
               }
                   
               NavigationLink(destination: TimerView(listIndex: self.listIndex, taskIndex: self.taskIndex).environmentObject(TimerState())) {
                  HStack {
                      Image(systemName: "clock")
                       .resizable()
                       .frame(width:30, height:30)
                      Text("Pomodoro")
                  }.foregroundColor(Color.black)
               }
                  
                  Spacer()
               
               }
            .font(.headline)
            .padding()
            .navigationBarTitle(Text(task.title!), displayMode: .inline)
            
            VStack{
                
                Spacer()
               
               HStack {
                  Spacer()
                  RemindDatePickerView(isShowRemindDate: $isShowRemindDate, task: self.task).offset(y: self.isShowRemindDate ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15 : UIScreen.main.bounds.height)
                  Spacer()
               }
                
                                
            }.background(Color(UIColor.label.withAlphaComponent(self.isShowRemindDate ? 0.2 : 0)).edgesIgnoringSafeArea(.all))
            
            
            VStack{
                
                Spacer()
               
               HStack {
                  Spacer()
                  DueDatePickerView(isShowDueDate: $isShowDueDate, task: self.task).offset(y: self.isShowDueDate ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15 : UIScreen.main.bounds.height)
                  Spacer()
               }
                
                                
            }.background(Color(UIColor.label.withAlphaComponent(self.isShowDueDate ? 0.2 : 0)).edgesIgnoringSafeArea(.all))
            
            
            VStack{
                
                Spacer()
               
               HStack {
                  Spacer()
                  EditNoteView(note: task.note!, isShowEditNote: $isShowEditNote, task: self.task).offset(y: self.isShowEditNote ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15 : UIScreen.main.bounds.height)
                  Spacer()
               }
                
                                
            }.background(Color(UIColor.label.withAlphaComponent(self.isShowEditNote ? 0.2 : 0)).edgesIgnoringSafeArea(.all))
            
            
         }
         .animation(.spring())
            .offset(y: -self.value)
         .onAppear {
                 
                 NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (noti) in
                     let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                     let height = value.height
                     self.value = height
                 }
                 
                 NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                     self.value = 0
                 }
         }
         
      
    }
   
}

struct RemindDatePickerView: View {
   
   @Environment(\.managedObjectContext) var managedObjectContext
   @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
   @FetchRequest(fetchRequest: LocalNotificationManager.getAllNotifications()) var notifications: FetchedResults<LocalNotificationManager>
   
   @State private var date: Date = Date()
   @Binding var isShowRemindDate: Bool
   var task: Task
   
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
   
   var body : some View{
           
      VStack(alignment: .center, spacing: 20) {
               
         Text("Choose Remind Time").font(.headline).foregroundColor(Color.black)
               
         DatePicker("", selection: $date).labelsHidden().colorInvert()
         .colorMultiply(Color.black)
         
         Text(CustomDateFormatter().Formatter(date: date, format: "yyyy-MM-dd' 'HH:mm")).foregroundColor(Color.black)
         
         Button(action: {
             self.isShowRemindDate.toggle()
             
          }) {
              
            Text("Cancel").font(.headline).foregroundColor(Color.red)
              
            }
         
         Button(action: {
            self.task.remindAt = self.date
            self.task.isRemind = true
             self.isShowRemindDate.toggle()
            self.UpdateNotificationSchedule()
            self.updateContext()
            
             do {
                 try self.managedObjectContext.save()
             }catch{
                 print(error)
             }
            
          }) {
              
              Text("Done").font(.headline)
              
               }
               
           }.padding(.vertical)
           .padding(.horizontal)
           .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
           .background(Color.white)
           .cornerRadius(30)
       }
   
}

struct DueDatePickerView: View {
   @Environment(\.managedObjectContext) var managedObjectContext
   @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
   
   @State private var date: Date = Date()
   @Binding var isShowDueDate: Bool
   var task: Task
   
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
   
   
   var body : some View{
           
      VStack(alignment: .center, spacing: 20) {
               
         Text("Choose Due Date").font(.headline).foregroundColor(Color.black)
               
         DatePicker("", selection: $date, displayedComponents: .date).labelsHidden().colorInvert()
         .colorMultiply(Color.black)
         
         Text(CustomDateFormatter().Formatter(date: date, format: "yyyy-MM-dd")).foregroundColor(Color.black)
         
         Button(action: {
             self.isShowDueDate.toggle()
             
          }) {
              
              Text("Cancel").font(.headline).foregroundColor(Color.red)
              
            }
         
         Button(action: {
           self.task.dueDate = self.date
            self.isShowDueDate.toggle()
            self.updateContext()
            
            do {
                try self.managedObjectContext.save()
            }catch{
                print(error)
            }
            
         }) {
             
             Text("Done").font(.headline)
             
           }
               
           }.padding(.vertical)
           .padding(.horizontal)
           .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
           .background(Color.white)
           .cornerRadius(30)
       }
   
}

struct EditNoteView: View {
   @Environment(\.managedObjectContext) var managedObjectContext
   @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
   
   @State var note: String
   @Binding var isShowEditNote: Bool
   var task: Task
     
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
   
   var body : some View{
           
      VStack(alignment: .center, spacing: 20) {
               
         Text("Edit Note").font(.headline).foregroundColor(Color.black)
               
         MultilineTextView(text: self.$note).frame(height: 150).overlay(
             RoundedRectangle(cornerRadius: 5)
                 .stroke(Color.secondary, lineWidth: 1)
         )
         
         Button(action: {
             self.isShowEditNote.toggle()
            UIApplication.shared.endEditing()
          }) {
              
              Text("Cancel").font(.headline).foregroundColor(Color.red)
              
            }
         
         Button(action: {
           self.task.note = self.note
            self.isShowEditNote.toggle()
            UIApplication.shared.endEditing()
            self.updateContext()
            
            do {
                try self.managedObjectContext.save()
            }catch{
                print(error)
            }
            
         }) {
             
             Text("Done").font(.headline)
             
           }
               
           }.padding(.vertical)
           .padding(.horizontal)
           .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
           .background(Color.white)
           .cornerRadius(30)
       }
   
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
