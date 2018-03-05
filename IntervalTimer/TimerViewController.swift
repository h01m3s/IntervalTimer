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
    fileprivate var selectedProfile: Profile? {
        didSet {
            guard let profile = selectedProfile else { return }
            profileNameLabel.text = profile.profileName
            totalTimeCounterLabel.text = textToDisplay(for: profile.totalTime)
        }
    }
    
    var progress: KDCircularProgress = {
        var progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.2
        progress.trackColor = .lightGray
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .constant
        progress.glowAmount = 0.9
        return progress
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    }()
    
    @objc func handleStart() {
        print("Start Timer")
        timeInterval.setIntervals(profile: selectedProfile!)
        
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
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.numberOfLines = 0
        label.baselineAdjustment = .alignCenters
        label.text = "Profile Name"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.textColor = UIColor.white
        return label
    }()
    
    let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Total Time"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    let totalTimeCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "00:00"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textColor = UIColor.rgb(red: 255, green: 128, blue: 0)
        return label
    }()
    
    let counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "00:00"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 70)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        hTimer.delegate = self
        
        let profile = Profile(profileName: "Default", cycle: 3, highInterval: 3, lowInterval: 3, highIntervalName: "high", lowIntervalName: "low")
        
        print("save profile status: ", defaultsStore.storeProfile(profile: profile, previousProfiles: []))
        selectedProfile = defaultsStore.getSelectedProfile(profileName: "Default")
        
        setupButtonAndProgressbar()
        
        setupLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetDisplay()
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
    
    func setupLabels() {
        view.addSubview(profileNameLabel)
        profileNameLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        let totalTimeStackView = UIStackView(arrangedSubviews: [totalTimeLabel, totalTimeCounterLabel])
        totalTimeStackView.axis = .vertical
        totalTimeStackView.distribution = .fillEqually
        view.addSubview(totalTimeStackView)
        totalTimeStackView.anchor(profileNameLabel.bottomAnchor, left: profileNameLabel.leftAnchor, bottom: nil, right: profileNameLabel.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        view.addSubview(counterLabel)
        counterLabel.anchor(totalTimeStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
    }
    
    func setupButtonAndProgressbar() {
        
        let width = view.frame.width
        
        view.addSubview(startButton)
        startButton.layer.cornerRadius = (width * 3/5) / 2
        startButton.anchorCenterXToSuperview()
        startButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: (width * 3/5) / 2, rightConstant: 0, widthConstant: width * 3/5, heightConstant: width * 3/5)
        
        view.addSubview(progress)
        progress.centerXAnchor.constraint(equalTo: startButton.centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
        progress.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: (width * 3/5) / 2, rightConstant: 0, widthConstant: width * 4/5, heightConstant: width * 4/5)
    }

}

extension TimerViewController {
    
    fileprivate func resetDisplay() {
        guard let profile = selectedProfile else { return }
        counterLabel.text = textToDisplay(for: 0)
        timeRemaining = profile.totalTime
        totalTimeCounterLabel.text = textToDisplay(for: timeRemaining)
        profileNameLabel.text = profile.profileName
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
            profileNameLabel.text = selectedProfile?.highIntervalName
        } else {
            progress.set(colors: UIColor.circleBlue)
            progress.trackColor = UIColor.circleLightBlue
            profileNameLabel.text = selectedProfile?.lowIntervalName
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
