//
//  ToDoTaskView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/28.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct ToDoTaskView: View {
    var title:String = ""
    var createdAt:String = ""
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title).font(.headline)
                Text(createdAt).font(.caption)
            }
        }
    }
}

struct ToDoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoTaskView()
    }
}
