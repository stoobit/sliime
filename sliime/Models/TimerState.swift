//
//  TimerState.swift
//  sliime
//
//  Created by Till Brügmann on 04.05.26.
//

import Foundation

enum TimerState: String {
    case on
    case off
    
    var opposite: Self {
        switch self {
        case .on:
            return .off
        case .off:
            return .on
        }
    }
    
    static let Key = "TimerState.Key"
}
