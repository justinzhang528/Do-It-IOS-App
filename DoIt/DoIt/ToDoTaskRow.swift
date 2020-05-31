//
//  ToDoTaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/29.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct ToDoTaskRow: View {
    var task: Task
    
    @State var iconString = "circle"
    
    var body: some View {
        VStack(alignment: .leading){
            Text(task.title!).font(.headline)
            Text("Created At: " + CustomDateFormatter().Formatter(date: task.createdAt!, format: "yyyy-MM-dd' 'HH:mm:ss")).font(.caption)
            Text("Note: " + task.note!).font(.caption)
        }.foregroundColor(Color.black)
    }
}

/*struct ToDoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoTaskRow()
    }
}*/
