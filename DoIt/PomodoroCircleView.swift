//
//  PomodoroView.swift
//  DoIt
//
//  Created by user172171 on 6/14/20.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct PomodoroView: View {
    var body: some View {
        NavigationView{
            ZStack{
                CircleShape(progress: 1)
                    .stroke(Color.white, style: .init(lineWidth: 3))
                CircleShape(progress: 0.4)
                    .stroke(Color.gray, style: .init(lineWidth: 8, lineCap: .round))
                Text("1:30")
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(Color.gray)
            }.frame(width: 250, height: 250)
        }
    }
}

struct CircleShape: Shape{
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = rect.width / 2
        
        let start: Double = -90
        let end: Double = -90 + 360 * progress
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
    }
}
