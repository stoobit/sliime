//
//  ViewControllerView.swift
//  sliime
//
//  Created by Till Brügmann on 04.05.26.
//

import SwiftUI

struct ViewControllerView: View {
    @State private var timerState: TimerState = .off
    
    var body: some View {
        VStack {
            Button(timerState == .off ? "Start" : "Reset") {
                timerState = timerState.opposite
                
                NotificationCenter.default
                    .post(
                        name: .startTimer, object: nil,
                        userInfo: [TimerState.Key: timerState]
                    )
            }
        }
        .scenePadding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
