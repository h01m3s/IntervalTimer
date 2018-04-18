//
//  Notification+helper.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 4/18/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import Foundation

extension Notification {
    struct UserInfoKey<ValueType>: Hashable {
        let key: String
    }
    
    func getUserInfo<T>(for key: Notification.UserInfoKey<T>) -> T {
        return userInfo![key] as! T
    }
}

extension Notification.Name {
    static let profileStoreDidChangedNotification = Notification.Name(rawValue: "me.weijielin.IntervalTimer.ProfileStoreDidChangedNotification")
}

extension Notification.UserInfoKey {
    static var profileStoreDidChangedChangeBehaviorKey: Notification.UserInfoKey<ProfileStore.ChangeBehavior> {
        return Notification.UserInfoKey(key: "me.weijielin.IntervalTimer.ProfileStoreDidChangedNotification.ChangeBehavior")
    }
}

extension NotificationCenter {
    func post<T>(name aName: NSNotification.Name, object anObject: Any?, typedUserInfo aUserInfo: [Notification.UserInfoKey<T> : T]? = nil) {
        post(name: aName, object: anObject, userInfo: aUserInfo)
    }
}
