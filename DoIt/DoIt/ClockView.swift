//
//  ClockView.swift
//  Pomodoro
//
//  Created by user172171 on 6/15/20.
//  Copyright © 2020 rotasha. All rights reserved.
//

import SwiftUI

struct ClockView: View {
    @EnvironmentObject var timerState: TimerState
    
    @State var clockString: String = "00:30"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        return Text(clockString)
            .font(.system(size: 54, weight: .bold))
            .foregroundColor(Color.gray)
            .onReceive(timer){ (now) in
                var secondsElapsed: Double = 0
                if let startTime = self.timerState.sessionStart {
                    secondsElapsed = now.timeIntervalSince1970 - startTime.timeIntervalSince1970
                }
                
                let totalMinutes: Double = 0.5
                let secondsRemaining = totalMinutes * 60 - secondsElapsed
                
                let minutes = Int(secondsRemaining / 60)
                let seconds = Int(secondsRemaining) - minutes * 60
                
                self.clockString = String(format: "%02d:%02d",minutes, seconds)
        }
    }
}
