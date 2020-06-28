//
//  PomodoroView.swift
//  DoIt
//
//  Created by user172171 on 6/14/20.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct PomodoroCircleView: View {
    
    var body: some View {
        ZStack{
            Track()
            Outline()
            ClockView()
            
        }
        .frame(width: 250, height: 250)
    }
}

struct Outline: View{
    @EnvironmentObject var timerState: TimerState
    @State var percentage: CGFloat = 0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.clear)
                .frame(width: 250, height: 250)
                .overlay(
                    Circle().trim(from:0, to: percentage)
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round,
                                lineJoin:.round
                            )
                    )
                        .foregroundColor(
                            Color.blue
                    ).animation(
                        .easeInOut(duration: 0.2)
                    )
            )
        }
        .onReceive(timer){ time in
            self.percentage = CGFloat(self.timerState.progress)
            print("\(self.percentage)")
        }
    }
}

struct Track: View{
    var body: some View{
        Circle()
            .fill(Color.clear)
            .frame(width: 250, height: 250)
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 15)
        )
    }
}

