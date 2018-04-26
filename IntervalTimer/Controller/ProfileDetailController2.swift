//
//  ProfileDetailController2.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 4/25/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class ProfileDetailController2: UIViewController {
    
    var profile: Profile?
    var stackSubViews = [UIView]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveProfile))
        navigationController?.navigationBar.tintColor = .white
        
        self.dismissKeyboardWhenTapped()
        
        viewSetup()
    }
    
    @objc fileprivate func handleSaveProfile() {
        print("Trying to save profile")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
}

// MARK: View setup
extension ProfileDetailController2 {
    
    fileprivate func viewSetup() {
        guard let profile = profile else { return }
        let profileNameRowView = createRowView(title: "Profile Name:", value: profile.profileName)
        let cycleRowView = createRowView(title: "Cycle:", value: profile.cycle.description)
        let highIntervalNameRowView = createRowView(title: "High Interval Name:", value: profile.highIntervalName)
        let highIntervalRowView = createRowView(title: "High Interval", value: profile.highInterval.description)
        let lowIntervalNameRowView = createRowView(title: "Low Interval Name:", value: profile.lowIntervalName)
        let lowIntervalRowView = createRowView(title: "Low Interval", value: profile.lowInterval.description)
        
        stackSubViews = [profileNameRowView, cycleRowView, highIntervalNameRowView, highIntervalRowView, lowIntervalNameRowView, lowIntervalRowView]
        let stackView = UIStackView(arrangedSubviews: stackSubViews)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 450)
    }
    
    fileprivate func createRowView(title: String, value: String) -> UIView {
        let rowView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        let valueTextField = UITextField()
        valueTextField.textAlignment = .right
        valueTextField.font = UIFont.boldSystemFont(ofSize: 16)
        valueTextField.textColor = .white
        rowView.addSubview(titleLabel)
        rowView.addSubview(valueTextField)
        titleLabel.text = title
        valueTextField.text = value
        titleLabel.anchor(rowView.topAnchor, left: rowView.leftAnchor, bottom: rowView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 32, bottomConstant: 8, rightConstant: 0, widthConstant: 180, heightConstant: 0)
        valueTextField.anchor(rowView.topAnchor, left: nil, bottom: rowView.bottomAnchor, right: rowView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 32, widthConstant: 80, heightConstant: 0)
        rowView.backgroundColor = UIColor.lightGray
        rowView.layer.cornerRadius = 10
        return rowView
    }
    
}

// MARK: TODO: create a RowView class
class RowView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
