//
//  CustomTabBarController.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/5/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timerViewController = TimerViewController()
        let navProfileTableController = UINavigationController(rootViewController: ProfilesTableViewController())
        
        timerViewController.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(named: "timer"), tag: 1)
        navProfileTableController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "setting"), tag: 2)
        
        viewControllers = [timerViewController, navProfileTableController]
        
        
    }
    
}
