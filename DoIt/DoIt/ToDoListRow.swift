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
            NavigationLink(destination: TaskView(listIndex: id!, navigationTitle: title!, color: Color(#colorLiteral(red: 0.6210807562, green: 0.9000057578, blue: 0.9218967557, alpha: 1)))){
                Image(systemName: "list.dash").resizable().fixedSize()
                VStack(alignment: .leading){
                    Text(title!).font(.headline)
                    Text(createdAt!).font(.caption)
                    Text(taskCount!).font(.caption)
            }
            }
        }.foregroundColor(Color.black)
    }
}

