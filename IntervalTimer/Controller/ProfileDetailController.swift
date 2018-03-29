//
//  ProfileDetailController.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/5/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class ProfileDetailController: UITableViewController {
    
    let cellId = "cellId"
    var profile: Profile?
    var previousProfiles = [Profile]()
    var previousIndex = -1
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveProfile))
        navigationController?.navigationBar.tintColor = .white
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
//        tableView.isScrollEnabled = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellId)
        
        self.dismissKeyboardWhenTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileCell
        cell.selectButton.removeFromSuperview()
        switch indexPath.item {
        case 0:
            cell.textLabel?.text = "Profile Name:"
            cell.sideTextField.text = profile?.profileName
        case 1:
            cell.textLabel?.text = "Cycle:"
            cell.sideTextField.text = profile?.cycle.description
            cell.sideTextField.keyboardType = .numberPad
        case 2:
            cell.textLabel?.text = "High Interval Name:"
            cell.sideTextField.text = profile?.highIntervalName
        case 3:
            cell.textLabel?.text = "High Interval:"
            if let highInterval = profile?.highInterval {
                cell.sideTextField.text = Int(highInterval).description
            } else {
                cell.sideTextField.text = ""
            }
            cell.sideTextField.keyboardType = .numberPad
        case 4:
            cell.textLabel?.text = "Low Interval Name:"
            cell.sideTextField.text = profile?.lowIntervalName
        case 5:
            cell.textLabel?.text = "Low Interval:"
            if let lowInterval = profile?.lowInterval {
                cell.sideTextField.text = Int(lowInterval).description
            } else {
                cell.sideTextField.text = ""
            }
            cell.sideTextField.keyboardType = .numberPad
        default:
            cell.textLabel?.text = "Profile Name:"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc func handleSaveProfile() {
        var newArr = previousProfiles
        if previousIndex != -1 {
            newArr.remove(at: previousIndex)
        }
        guard let newProfile = createNewProfile() else { return }
        
        if profile?.profileName == UserDefaults.getSelectedProfile() {
            UserDefaults.setSelectedProfile(profileName: newProfile.profileName)
        }
        
        if UserDefaults.storeProfile(profile: newProfile, previousProfiles: newArr) != true {
            return
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate func createNewProfile() -> Profile? {
        var profileDic = [String: Any]()
        let cells = tableView.visibleCells as! [ProfileCell]
        
        for (index, cell) in cells.enumerated() {
            guard let cellValue = cell.sideTextField.text, cellValue != "" else {
                print("Invalid Profile Input")
                return nil
            }
            switch index {
            case 0:
                profileDic["profileName"] = cellValue
                profileDic["isSelected"] = (UserDefaults.getSelectedProfile() == cellValue) ? true : false
            case 1:
                profileDic["cycle"] = Int(cellValue)
            case 2:
                profileDic["highIntervalName"] = cellValue
            case 3:
                profileDic["highInterval"] = TimeInterval(cellValue)
            case 4:
                profileDic["lowIntervalName"] = cellValue
            case 5:
                profileDic["lowInterval"] = TimeInterval(cellValue)
            default:
                print("default case")
            }
        }
        
        let data = try! JSONSerialization.data(withJSONObject: profileDic, options: [])

        guard let newProfile = try? JSONDecoder().decode(Profile.self, from: data) else {
            print("Error when decoding...")
            return nil
        }

        return newProfile
    }
    
}
