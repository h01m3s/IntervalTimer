//
//  HTimer.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/1/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import Foundation

protocol HTimerProtocol {
    func timeRemainingOnTimer(_ timer: HTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: HTimer)
    func elapsedTimeUpdate(_ timer: HTimer)
}

class HTimer {
    
    var delegate: HTimerProtocol?
    var timer: Timer? = nil
    var duration: TimeInterval = 0
    
    @objc dynamic func timerAction() {
        
        guard duration > 0 else {
            stopTimer()
            delegate?.timerHasFinished(self)
            return
        }
        
        duration -= 1
        delegate?.elapsedTimeUpdate(self)
        delegate?.timeRemainingOnTimer(self, timeRemaining: duration)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
        delegate?.timeRemainingOnTimer(self, timeRemaining: duration)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        duration = 0
    }
    
}
