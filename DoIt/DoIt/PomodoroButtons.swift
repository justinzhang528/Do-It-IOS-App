//
//  PomodoroButtons.swift
//  Pomodoro
//
//  Created by user172171 on 6/15/20.
//  Copyright © 2020 rotasha. All rights reserved.
//

import SwiftUI

struct StartButton: View {
    @EnvironmentObject var timerState: TimerState
    var body: some View {
        Button(action: {
            self.timerState.sessionStart = Date()
        }) {
            Image(systemName: "play")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.gray)
        }
    }
}

struct PauseButton: View {
    @EnvironmentObject var timerState: TimerState
    var body: some View {
        Button(action: {
            self.timerState.sessionStart = nil
        }) {
            Image(systemName: "pause")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.gray)
        }
    }
}

struct StopButton: View {
    @EnvironmentObject var timerState: TimerState
    var body: some View {
        Button(action: {
            self.timerState.sessionStart = nil
        }) {
            Image(systemName: "stop")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.gray)
        }
    }
}

struct RestartButton: View {
    @EnvironmentObject var timerState: TimerState
    var body: some View {
        Button(action: {
            self.timerState.sessionStart = Date()
        }) {
            Image(systemName: "repeat")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.gray)
        }
    }
}
