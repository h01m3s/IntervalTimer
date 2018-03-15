//
//  DefaultsStore.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/2/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let encoder = PropertyListEncoder()
    static let decoder = PropertyListDecoder()
    
    static func setSelectedProfile(profileName: String) {
        UserDefaults.standard.set(profileName, forKey: "selectedProfileName")
    }
    
    static func getSelectedProfile() -> String {
        guard let profileName = UserDefaults.standard.string(forKey: "selectedProfileName") else {
            return "Tabata"
        }
        return profileName
    }
    
    static func storeProfile(profile: Profile, previousProfiles: [Profile]) -> Bool {
        var profiles = [Profile]()
        
        if previousProfiles.count > 0 {
            profiles.append(contentsOf: previousProfiles)
        }

        for previousProfile in profiles {
            if previousProfile.profileName == profile.profileName {
                return false
            }
        }
        
        profiles.append(profile)
        guard let encoded = try? UserDefaults.encoder.encode(profiles) else { return false }
        UserDefaults.standard.set(encoded, forKey: "Profiles")
        
        return true
    }
    
    static func getSelectedProfile(profileName: String) -> Profile? {
        let profiles = getProfiles()
        let selectedProfile = profiles.filter { $0.profileName == profileName }
        return selectedProfile.count > 0 ? selectedProfile[0] : nil
    }
    
    static func getProfiles() -> [Profile] {
        guard let profileData = UserDefaults.standard.data(forKey: "Profiles") else {
            print("Error When get profiles data")
            return []
        }
        guard let profiles = try? UserDefaults.decoder.decode([Profile].self, from: profileData) else {
            print("Error When convert profiles")
            return []
        }
        
        return profiles
    }
    
}
