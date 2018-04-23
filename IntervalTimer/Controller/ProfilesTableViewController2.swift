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
        
        navigationItem.title = "Profiles"
        view.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        NotificationCenter.default.addObserver(self, selector: #selector(todoItemsDidChange), name: .profileStoreDidChangedNotification, object: nil)
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
    
}

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

extension ProfilesTableViewController2: ProfileCellDelegate {
    
    func didTapSelectButton(cell: ProfileCell) {
        guard let cellProfile = cell.profile else {
            print("error here")
            return
        }
        
        UserDefaults.setSelectedProfile(profileName: cellProfile.profileName)
        
        ProfileStore.shared.select(item: cellProfile)
        
        tableView.reloadData()
    }
    
}






