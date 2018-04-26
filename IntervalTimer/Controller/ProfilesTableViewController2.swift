//
//  ProfilesTableViewController2.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 4/23/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class ProfilesTableViewController2: UITableViewController {
    
    private let cellId = "cellId"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoItemsDidChange), name: .profileStoreDidChangedNotification, object: nil)
    }
    
    private func setup() {
        navigationItem.title = "Profiles"
        view.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func syncTableView(for behavior: ProfileStore.ChangeBehavior) {
        switch behavior {
        case .add(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPathes, with: .automatic)
        case .remove(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.deleteRows(at: indexPathes, with: .automatic)
        case .reload:
            tableView.reloadData()
        }
    }
    
    @objc func addButtonPressed(_ sender: Any) {
        print("addButtonPressed")
    }
    
    @objc func todoItemsDidChange(_ notification: Notification) {
        let behavior = notification.getUserInfo(for: .profileStoreDidChangedChangeBehaviorKey)
        syncTableView(for: behavior)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileDetailController = ProfileDetailController2()
        profileDetailController.profile = ProfileStore.shared.item(at: indexPath.row)
        navigationController?.pushViewController(profileDetailController, animated: true)
    }
    
}

// MARK: cell setup
extension ProfilesTableViewController2 {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileCell
        cell.profile = ProfileStore.shared.item(at: indexPath.row)
        cell.sideTextField.isEnabled = false
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileStore.shared.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: animation
extension ProfilesTableViewController2 {
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
}

extension ProfilesTableViewController2: ProfileCellDelegate {
    
    func didTapSelectButton(cell: ProfileCell) {
        guard let cellProfile = cell.profile else {
            print("error here")
            return
        }
        
        ProfileStore.shared.select(item: cellProfile)
        UserDefaults.setSelectedProfile(profileName: cellProfile.profileName)
        
        tableView.reloadData()
    }
    
}






