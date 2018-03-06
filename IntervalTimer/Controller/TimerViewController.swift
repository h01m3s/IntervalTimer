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
    fileprivate let defaultsStore = DefaultsStore()
    fileprivate var isPlay = false
    fileprivate var timeRemaining: TimeInterval = 0
    fileprivate var timeElapsed: TimeInterval = 0
    fileprivate var selectedProfile = Profile(profileName: "Default", cycle: 2, highInterval: 5, lowInterval: 3, highIntervalName: "high", lowIntervalName: "low") {
        didSet {
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
        
        setupTestingData()
        if let profile = defaultsStore.getSelectedProfile(profileName: "Default") {
            selectedProfile = profile
        }
        tabBarController?.tabBar.barTintColor = UIColor.darkGray
    }
    
    func setupTestingData() {
         let profile1 = Profile(profileName: "Default", cycle: 2, highInterval: 5, lowInterval: 3, highIntervalName: "high", lowIntervalName: "low")
         let profile2 = Profile(profileName: "Profile2", cycle: 3, highInterval: 3, lowInterval: 3, highIntervalName: "high", lowIntervalName: "low")
         let profile3 = Profile(profileName: "Profile3", cycle: 3, highInterval: 3, lowInterval: 3, highIntervalName: "high", lowIntervalName: "low")
        let result = defaultsStore.storeProfile(profile: profile3, previousProfiles: [profile1, profile2])
        print("Storing Testing Data Status: ", result)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetDisplay()
    }
    
    @objc func handleStart() {
        print("Start Timer")
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
