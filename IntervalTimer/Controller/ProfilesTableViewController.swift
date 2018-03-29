//
//  ProfilesTableView.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/5/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class ProfilesTableViewController: UITableViewController, ProfileCellDelegate {
    
    var profiles = UserDefaults.getProfiles()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        
        navigationItem.title = "Profiles"
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddProfile))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profiles = UserDefaults.getProfiles()
        tableView.reloadData()
        self.animateTable()
    }
    
    @objc func handleAddProfile() {
        let profileDetailController = ProfileDetailController()
        profileDetailController.previousProfiles = profiles
        navigationController?.pushViewController(profileDetailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileDetailController = ProfileDetailController()
        profileDetailController.profile = profiles[indexPath.item]
        profileDetailController.previousProfiles = profiles
        profileDetailController.previousIndex = indexPath.item
        navigationController?.pushViewController(profileDetailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.profile = profiles[indexPath.item]
        cell.sideTextField.isEnabled = false
        cell.delegate = self
        return cell
    }

    func didTapSelectButton(cell: ProfileCell) {
        guard let cellProfile = cell.profile else {
            print("error here")
            return
        }
        
        UserDefaults.setSelectedProfile(profileName: cellProfile.profileName)
        
        for index in profiles.indices {
            profiles[index].isSelected = (profiles[index].profileName == cellProfile.profileName) ? true : false
        }
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
