//
//  ProfilesTableView.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/5/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

class ProfilesTableViewController: UITableViewController {
    
    let defaultsStore = DefaultsStore()
    let cellId = "cellId"
    var profiles = [Profile]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellId)
        
        profiles = defaultsStore.getProfiles()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        
        navigationItem.title = "Profiles"
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
//        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleAddProfile))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddProfile))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateTable()
    }
    
    @objc func handleAddProfile() {
        print("handleAddProfile")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileCell
        cell.textLabel?.text = profiles[indexPath.item].profileName
        return cell
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
        
        cell.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0)
        
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
    
    fileprivate var originalWidth: CGFloat?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.masksToBounds = false
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 12
    }
    
    override func layoutSubviews() {
        if originalWidth == nil {
            originalWidth = self.frame.size.width
        }
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: (originalWidth ?? self.frame.size.width) - 30, height: bounds.size.height - 10)
        super.layoutSubviews()
    }
    
    override var bounds: CGRect {
        didSet {
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOffset = CGSize(width: 2, height: 4)
            layer.shadowRadius = 8
            layer.shadowOpacity = 0.2
            layer.shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
//            layer.shadowShouldRasterize = true
//            layer.shadowRasterizationScale = UIScreen.main.scale
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
