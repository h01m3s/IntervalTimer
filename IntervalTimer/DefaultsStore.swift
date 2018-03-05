//
//  DefaultsStore.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/2/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import Foundation

class DefaultsStore {
    
    fileprivate let encoder = PropertyListEncoder()
    fileprivate let decoder = PropertyListDecoder()
    
    func storeProfile(profile: Profile, previousProfiles: [Profile]) -> Bool {
        var profiles = [Profile]()
        if previousProfiles.count > 0 {
            profiles.append(contentsOf: previousProfiles)
        }
        profiles.append(profile)
        guard let encoded = try? encoder.encode(profiles) else { return false }
        UserDefaults.standard.set(encoded, forKey: "Profiles")
        return true
    }
    
    func getSelectedProfile(profileName: String) -> Profile? {
        let profiles = getProfiles()
        let selectedProfile = profiles.filter { $0.profileName == profileName }
        return selectedProfile.count > 0 ? selectedProfile[0] : nil
    }
    
    func getProfiles() -> [Profile] {
        guard let profileData = UserDefaults.standard.data(forKey: "Profiles") else {
            print("Error When get profiles data")
            return []
        }
        guard let profiles = try? decoder.decode([Profile].self, from: profileData) else {
            print("Error When convert profiles")
            return []
        }
        
        return profiles
    }
    
}
