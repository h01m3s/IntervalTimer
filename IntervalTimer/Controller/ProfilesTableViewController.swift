//
//  ProfilesTableView.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/5/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class ProfilesTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var profiles = [Profile]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellId)
        
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        
        navigationItem.title = "Profiles"
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleAddProfile))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddProfile))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        profiles = UserDefaults.getProfiles()
        profiles.sort { $0.profileName < $1.profileName }
        tableView.reloadData()
        self.animateTable()
    }
    
    @objc func handleAddProfile() {
        let profileDetailController = ProfileDetailController()
        profileDetailController.previousProfiles = profiles
        navigationController?.pushViewController(profileDetailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileCell
        cell.textLabel?.text = profiles[indexPath.item].profileName
        cell.sideTextField.isEnabled = false
        cell.link = self
        let selectedProfileName = UserDefaults.getSelectedProfile()
        cell.selectButton.tintColor = (cell.textLabel?.text == selectedProfileName) ? .red : .gray
        return cell
    }
    
    @objc func handleSelectButton(cell: ProfileCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        let selectedProfileName = UserDefaults.getSelectedProfile()
        if cell.textLabel?.text != selectedProfileName {
            cell.selectButton.tintColor = .red
            UserDefaults.setSelectedProfile(profileName: (cell.textLabel?.text)!)
            let cells = tableView.visibleCells as! [ProfileCell]
            for (index, cell) in cells.enumerated() {
                if index != indexPathTapped.item {
                    cell.selectButton.tintColor = .gray
                }
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileDetailController = ProfileDetailController()
        profileDetailController.profile = profiles[indexPath.item]
        profileDetailController.previousProfiles = profiles
        profileDetailController.previousIndex = indexPath.item
        navigationController?.pushViewController(profileDetailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(0.2)
        
        cell.transform =  CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.commitAnimations()
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(0.2)
        
        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        UIView.commitAnimations()
    }
    
    func animateTable() {
        let cells = tableView.visibleCells
        
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for (index, cell) in cells.enumerated() {
            
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                
            }, completion: nil)
        }
    }
    
}

class ProfileCell: UITableViewCell {
    
    var link: ProfilesTableViewController?
    
    fileprivate var originalSize: CGSize?
    
    let sideTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleSelect() {
        link?.handleSelectButton(cell: self)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.masksToBounds = false
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 12
        addSubview(sideTextField)
        sideTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sideTextField.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 100, heightConstant: 60)
//        accessoryView = selecteButton
        addSubview(selectButton)
        selectButton.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 50)
        selectButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if originalSize == nil {
            originalSize = self.frame.size
        }
        
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: (originalSize?.width ?? self.frame.size.width) - 30, height: (originalSize?.height ?? self.frame.size.height) - 10)
    }
    
    override var bounds: CGRect {
        didSet {
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOffset = CGSize(width: 2, height: 4)
            layer.shadowRadius = 8
            layer.shadowOpacity = 0.2
            layer.shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
