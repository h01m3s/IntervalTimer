//
//  ProfileDetailController.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/5/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class ProfileDetailController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let PickerData = (0...59).map { String($0) }
    let pickerDataSize = 120_000
    
    let effect = UIBlurEffect(style: .dark)
    lazy var visualEffectView: UIVisualEffectView = {
        let visualView = UIVisualEffectView(effect: nil)
        visualView.frame = self.view.bounds
        visualView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return visualView
    }()
    
    let cellId = "cellId"
    var profile: Profile?
    var previousProfiles = [Profile]()
    var previousIndex = -1
    
    lazy var addItemView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 2/3, height: 250)
        view.backgroundColor = UIColor.white
        view.alpha = 0.6
        view.layer.cornerRadius = 5
        let pickerView = UIPickerView()
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 35)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(pickerDataSize / 2, inComponent: 0, animated: false)
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        doneButton.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        doneButton.backgroundColor = UIColor.darkGray
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 5
        view.addSubview(doneButton)
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: view.frame.width * 1/4).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.addSubview(pickerView)
        pickerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return view
    }()
    
    @objc func handleDone() {
        animateOut()
    }
    
    @objc func handleAdd() {
        animateIn()
    }
    
    func animateIn() {
        view.addSubview(addItemView)
        addItemView.center = self.view.center
        
        addItemView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.addItemView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (_) in
            self.addItemView.removeFromSuperview()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveProfile))
        tabBarController?.tabBar.isHidden = true
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animateIn()
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
            guard let cellValue = cell.sideTextField.text else {
                print("Invalid Profile Input")
                return nil
            }
            switch index {
            case 0:
                profileDic["profileName"] = cellValue
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerData[row % PickerData.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Let PickerView go back to middle so user won't know
        let position = pickerDataSize / 2 + row % PickerData.count
        pickerView.selectRow(position, inComponent: 0, animated: false)
        
        // Get actual selected value
        navigationItem.title = String(row % PickerData.count)
    }
    
}
