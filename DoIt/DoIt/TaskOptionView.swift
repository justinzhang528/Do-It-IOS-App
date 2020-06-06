//
//  TaskOptionView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/6/6.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct TaskOptionView: View {
   
   @Environment(\.managedObjectContext) var managedObjectContext
   @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
    
   var task: Task
   @State private var isShowRemindDate = false
   @State private var isShowDueDate = false
    
    var body: some View {
      
        NavigationView {
         
         ZStack {
            
            VStack(alignment: .leading, spacing: 30) {
                   
                   HStack {
                       Image(systemName: "bell")
                        .resizable()
                        .fixedSize()
                       Text("Remind Me")
                     Spacer()
                   }.onTapGesture {
                     self.isShowRemindDate.toggle()
               }
                   
                   HStack {
                       Image(systemName: "calendar")
                        .resizable()
                        .fixedSize()
                       Text("Set Due Date")
                   }.onTapGesture {
                   self.isShowDueDate.toggle()
               }
                   
                   HStack {
                       Image(systemName: "clock")
                        .resizable()
                        .fixedSize()
                       Text("Pomodoro")
                   }
                   
                   HStack {
                       Image(systemName: "doc.text")
                        .resizable()
                        .fixedSize()
                       Text("Edit Note")
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
            
            
         }.background(Color("Color1").edgesIgnoringSafeArea(.all))
         .animation(.default)
         
         
        }
      
    }
   
}

struct RemindDatePickerView: View {
   
   @Environment(\.managedObjectContext) var managedObjectContext
   @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
   
   @State private var date: Date = Date()
   @Binding var isShowRemindDate: Bool
   var task: Task
   
   
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

/*struct TaskOptionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskOptionView()
    }
}*/
