//
//  TimeIntervals.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/2/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import Foundation

class TimeIntervals {
    
    fileprivate var cycle: Int = 0
    fileprivate var highInterval: TimeInterval = 0
    fileprivate var lowInterval: TimeInterval = 0
    var returnHighInterval = true
    
    func popNextInterval() -> TimeInterval {
        
        guard cycle > 0 else {
            return 0
        }
        
        var returnInterval: TimeInterval = 0
        
        if returnHighInterval {
            returnHighInterval = false
            returnInterval = highInterval
        } else {
            returnHighInterval = true
            returnInterval = lowInterval
            cycle -= 1
        }
        
        return returnInterval
    }
    
    func setIntervals(profile: Profile) {
        returnHighInterval = true
        self.cycle = profile.cycle
        self.highInterval = profile.highInterval
        self.lowInterval = profile.lowInterval
    }
}
