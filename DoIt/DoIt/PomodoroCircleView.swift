//
//  PomodoroView.swift
//  DoIt
//
//  Created by user172171 on 6/14/20.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct PomodoroCircleView: View {
    //@EnvironmentObject var timerState: TimerState
    
    //@State var percentage: CGFloat = 0
    var body: some View {
        ZStack{
            //Track()
            ClockView()
            //Outline(percentage: percentage)
            
        }
        .frame(width: 250, height: 250)
    }
}

struct Outline: View{
    var percentage: CGFloat = 50
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.clear)
                .frame(width:250, height: 250)
                .overlay(
                    Circle()
                        .trim(from: 0, to: percentage * 0.01)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        .fill(AngularGradient(gradient: .init(colors: [ Color.blue]),center: .center, startAngle: .zero, endAngle: .init(degrees: 360)))
            ).animation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0))
        }
    }
}

struct Track: View{
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.white)
                .frame(width:250, height: 250)
            .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 3))
                        .fill(AngularGradient(gradient: .init(colors: [Color.gray]), center: .center))
            )
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
        
        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .degrees(start),
            endAngle:.degrees(end),
            clockwise: false
        )
        
        return path
    }
}
struct PomodoroCircleView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroCircleView()
    }
}
