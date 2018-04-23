//
//  ProfileStore.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 4/18/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import Foundation

class ProfileStore {
    
    enum ChangeBehavior {
        case add([Int])
        case remove([Int])
        case reload
    }
    
    fileprivate let encoder = PropertyListEncoder()
    fileprivate let decoder = PropertyListDecoder()
    
    private init() {
        guard let profileData = UserDefaults.standard.data(forKey: "Profiles") else {
            print("Error When get profiles data")
            return
        }
        guard let profiles = try? UserDefaults.decoder.decode([Profile].self, from: profileData) else {
            print("Error When convert profiles")
            return
        }
        
        items = profiles.sorted { $0.profileName < $1.profileName }
    }
    
    static let shared = ProfileStore()
    
    static func diff(original: [Profile], now: [Profile]) -> ChangeBehavior {
        let originalSet = Set(original)
        let nowSet = Set(now)
        
        if originalSet.isSubset(of: nowSet) { // Appended
            let added = nowSet.subtracting(originalSet)
            let indexes = added.compactMap { now.index(of: $0) }
            return .add(indexes)
        } else if (nowSet.isSubset(of: originalSet)) { // Removed
            let removed = originalSet.subtracting(nowSet)
            let indexes = removed.compactMap { original.index(of: $0) }
            return .remove(indexes)
        } else { // Both appended and removed
            return .reload
        }
    }
    
    private var items: [Profile] = [] {
        didSet {
            guard let encoded = try? encoder.encode(items) else { return }
            UserDefaults.standard.set(encoded, forKey: "Profiles")
            let behavior = ProfileStore.diff(original: oldValue, now: items)
            NotificationCenter.default.post(
                name: .profileStoreDidChangedNotification,
                object: self,
                typedUserInfo: [.profileStoreDidChangedChangeBehaviorKey: behavior]
            )
        }
    }
    
    func select(item: Profile) {
        for index in items.indices {
            items[index].isSelected = items[index] == item
        }
    }
    
    func append(item: Profile) {
        items.append(item)
    }
    
    func append(newItems: [Profile]) {
        items.append(contentsOf: newItems)
    }
    
    func remove(item: Profile) {
        guard let index = items.index(of: item) else { return }
        remove(at: index)
    }
    
    func remove(at index: Int) {
        items.remove(at: index)
    }
    
    func edit(original: Profile, new: Profile) {
        guard let index = items.index(of: original) else { return }
        items[index] = new
    }
    
    var count: Int {
        return items.count
    }
    
    func item(at index: Int) -> Profile {
        return items[index]
    }
    
}
