//
//  PomodoroView.swift
//  DoIt
//
//  Created by user172171 on 6/14/20.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct PomodoroView: View {
    @EnvironmentObject var timerState: TimerState
    var body: some View {
        NavigationView{
            VStack(spacing: 100.0){
                PomodoroCircleView()
                HStack(spacing:50.0){
                    if timerState.sessionStart == nil{
                        StartButton()
                    }else{
                        //PauseButton()
                        StopButton()
                        //RestartButton()
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
    }
}
