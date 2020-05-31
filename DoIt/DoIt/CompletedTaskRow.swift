//
//  CompletedTaskRow.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/30.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct CompletedTaskRow: View {
    var task: Task
    
    var body: some View {
        HStack{
            Image(systemName: "checkmark.circle.fill")
            VStack(alignment: .leading){
                Text(task.title!).font(.headline)
                Text("Completed Time: " + CustomDateFormatter().Formatter(date: task.createdAt!, format: "yyyy-MM-dd' 'HH:mm:ss")).font(.caption)
            }
        }.foregroundColor(Color.black)
    }
}
