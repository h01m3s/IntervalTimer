//
//  Profile.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/2/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import Foundation

struct Profile: Codable {
    
    var profileName: String
    var cycle: Int
    var highInterval: TimeInterval
    var lowInterval: TimeInterval
    var highIntervalName: String
    var lowIntervalName: String
    var totalTime: TimeInterval {
        get {
            return TimeInterval(cycle) * (highInterval + lowInterval)
        }
    }
    
    var isSelected = false
    
}

extension Profile: Hashable {
    // Needed if order to use set() function
    
    var hashValue: Int {
        return profileName.hashValue
    }
    
}

extension Profile: Equatable {
    
    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.profileName == rhs.profileName
    }
    
}
