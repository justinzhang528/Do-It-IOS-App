//
//  ToDoTaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/28.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct ToDoListRow: View {
    var title:String?
    var createdAt:String?
    var taskCount:String?
    var id:Int?
    
    var body: some View {
        HStack{
            NavigationLink(destination: TaskView(listIndex: id!, navigationTitle: title!)){
                VStack(alignment: .leading){
                    Text(title!).font(.headline)
                    Text(taskCount!).font(.caption)
                }
            }
        }
    }
}

