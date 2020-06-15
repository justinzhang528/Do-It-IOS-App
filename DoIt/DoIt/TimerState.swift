//
//  TimerState.swift
//  Pomodoro
//
//  Created by user172171 on 6/15/20.
//  Copyright © 2020 rotasha. All rights reserved.
//

import Foundation
import SwiftUI
import AudioToolbox
import Combine

class TimerState: ObservableObject{
    
    static var totalMinutes: Double = 25
    static var totalSeconds: Double{
        return totalMinutes * 60
    }
    
    @Published var sessionStart: Date? = nil
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .default).autoconnect()
    
    var cancellables: [AnyCancellable] = []
    
    var isRunning: Bool{
        return sessionStart != nil
    }
    
    var secondsElapsed: Double? {
        guard let start = sessionStart else { return nil}
        
        return Date().timeIntervalSince1970 - start.timeIntervalSince1970
    }
    
    var secondsRemaining: Double? {
        guard let elapsed = secondsElapsed else {return nil}
        return max(TimerState.totalSeconds - elapsed, 0)
    }
    
    var progress: Double{
        guard let elapsed = secondsElapsed else {return 0}
        let progress = elapsed / TimerState.totalSeconds
        return progress
    }
    
    init(){
        cancellables.append(timer.sink(receiveValue: { (date) in
            self.objectWillChange.send()
            
            if(self.secondsRemaining == 0){
                AudioServicesPlayAlertSound(1005)
                self.sessionStart = nil
            }
        }))
    }
}

//    @Published var sessionStart: Date? = nil
