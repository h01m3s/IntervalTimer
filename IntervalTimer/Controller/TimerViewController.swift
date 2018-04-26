//
//  ViewController.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/1/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit
import KDCircularProgress

class TimerViewController: UIViewController {
    
    fileprivate var hTimer = HTimer()
    fileprivate let timeInterval = TimeIntervals()
    fileprivate var isPlay = false
    fileprivate var timeRemaining: TimeInterval = 0
    fileprivate var timeElapsed: TimeInterval = 0
    fileprivate var selectedProfile: Profile? {
        didSet {
            guard let selectedProfile = selectedProfile else { return }
            profileNameLabel.text = selectedProfile.profileName
            totalTimeCounterLabel.text = textToDisplay(for: selectedProfile.totalTime)
        }
    }
    
    var profileNameLabel: UILabel!
    var totalTimeLabel: UILabel!
    var totalTimeCounterLabel: UILabel!
    var counterLabel: UILabel!
    var progress: KDCircularProgress!
    var startButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        hTimer.delegate = self
        
        setupButtonAndProgressbar()
        setupLabels()
        
//        setupTestingData()
        
        let selectedProfileName = UserDefaults.getSelectedProfile()
        if let profile = UserDefaults.getSelectedProfile(profileName: selectedProfileName) {
            selectedProfile = profile
        }
        
        tabBarController?.tabBar.barTintColor = UIColor.darkGray
    }
    
    func setupTestingData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let profile = Profile(profileName: "Tabata", cycle: 8, highInterval: 20, lowInterval: 10, highIntervalName: "high", lowIntervalName: "low", isSelected: true)
        let profile2 = Profile(profileName: "test", cycle: 8, highInterval: 20, lowInterval: 10, highIntervalName: "high", lowIntervalName: "low", isSelected: false)
        let profile3 = Profile(profileName: "Aaa", cycle: 8, highInterval: 20, lowInterval: 10, highIntervalName: "high", lowIntervalName: "low", isSelected: false)
        ProfileStore.shared.append(newItems: [profile, profile2, profile3])
        UserDefaults.setSelectedProfile(profileName: profile.profileName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let selectedProfileName = UserDefaults.getSelectedProfile()
        if let profile = UserDefaults.getSelectedProfile(profileName: selectedProfileName) {
            selectedProfile = profile
        }
        resetDisplay()
    }
    
    @objc func handleStart() {
        guard let selectedProfile = selectedProfile else { return }
        timeInterval.setIntervals(profile: selectedProfile)
        
        timeElapsed = 0
        resetDisplay()
        
        if !isPlay {
            startTimer()
        } else {
            stopTimer()
        }
        
        startButtonState(isPlay)
    }
    
    fileprivate func startTimer() {
        hTimer.duration = timeInterval.popNextInterval()
        progressAnimationStart(duration: hTimer.duration)
        hTimer.startTimer()
        isPlay = true
    }
    
    fileprivate func stopTimer() {
        hTimer.stopTimer()
        isPlay = false
        progress.stopAnimation()
        progress.trackColor = UIColor.lightGray
    }
    
    func startButtonState(_ isPlay: Bool) {
        if isPlay {
            startButton.setTitle("Stop", for: .normal)
            startButton.setTitleColor(UIColor.warningRed, for: .normal)
        } else {
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
}

extension TimerViewController {
    
    fileprivate func resetDisplay() {
        guard let selectedProfile = selectedProfile else { return }
        counterLabel.text = textToDisplay(for: 0)
        timeRemaining = selectedProfile.totalTime
        totalTimeCounterLabel.text = textToDisplay(for: timeRemaining)
        profileNameLabel.text = selectedProfile.profileName
    }
    
    fileprivate func textToDisplay(for timeRemaining: TimeInterval) -> String {
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let minutesDisplay = String(format: "%02d", Int(minutesRemaining))
        let timeRemainingDisplay = "\(minutesDisplay):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    fileprivate func progressAnimationStart(duration: TimeInterval) {
        guard let selectedProfile = selectedProfile else { return }
        guard duration > 0 else {
            return
        }

        if timeInterval.returnHighInterval != true {
            progress.set(colors: UIColor.circleGreen)
            progress.trackColor = UIColor.circleLightGreen
            profileNameLabel.text = selectedProfile.highIntervalName.capitalized
        } else {
            progress.set(colors: UIColor.circleBlue)
            progress.trackColor = UIColor.circleLightBlue
            profileNameLabel.text = selectedProfile.lowIntervalName.capitalized
        }

        progress.animate(fromAngle: 0, toAngle: 360, duration: duration, completion: nil)
    }
    
}

extension TimerViewController: HTimerProtocol {
    
    internal func timerHasFinished(_ timer: HTimer) {
        progress.stopAnimation()
        let nextInterval = timeInterval.popNextInterval()
        if nextInterval != 0 {
            hTimer.duration = nextInterval
            hTimer.startTimer()
            progressAnimationStart(duration: nextInterval)
        } else {
            isPlay = false
            startButtonState(isPlay)
            resetDisplay()
            counterLabel.text = "Done!"
            progress.trackColor = UIColor.lightGray
        }
    }
    
    internal func timeRemainingOnTimer(_ timer: HTimer, timeRemaining: TimeInterval) {
        counterLabel.text = textToDisplay(for: timeRemaining)
    }
    
    internal func elapsedTimeUpdate(_ timer: HTimer) {
        timeRemaining -= 1
        totalTimeCounterLabel.text = textToDisplay(for: timeRemaining)
    }
    
}
