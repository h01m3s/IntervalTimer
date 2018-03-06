//
//  TimerViewSetup.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/5/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit
import KDCircularProgress

extension TimerViewController {
    
    func setupLabels() {
        
        profileNameLabel = {
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
        
        totalTimeLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = "Total Time"
            label.font = UIFont(name: "HelveticaNeue", size: 20)
            label.textColor = UIColor.white
            return label
        }()
        
        totalTimeCounterLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = "00:00"
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            label.textColor = UIColor(r: 255, g: 128, b: 0)
            return label
        }()
        
        counterLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = "00:00"
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 70)
            label.textColor = UIColor.lightGray
            return label
        }()
        
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
        
        startButton = {
            let button = UIButton(type: .system)
            button.setTitle("Start", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            button.clipsToBounds = true
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
            return button
        }()
        
        progress = {
            let progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
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
        
        let width = view.frame.width
        
        view.addSubview(startButton)
        startButton.layer.cornerRadius = (width * 3/5) / 2
        startButton.anchorCenterXToSuperview()
        startButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: (width * 1/5) / 2, rightConstant: 0, widthConstant: width * 3/5, heightConstant: width * 3/5)
        
        view.addSubview(progress)
        progress.centerXAnchor.constraint(equalTo: startButton.centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
        progress.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: (width * 3/5) / 2, rightConstant: 0, widthConstant: width * 4/5, heightConstant: width * 4/5)
    }
    
}
