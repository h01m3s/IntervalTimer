//
//  ProfileCell.swift
//  IntervalTimer
//
//  Created by Weijie Lin on 3/22/18.
//  Copyright © 2018 Weijie Lin. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate {
    func didTapSelectButton(cell: ProfileCell)
}

class ProfileCell: UITableViewCell {
    
    var delegate: ProfileCellDelegate?
    
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
        delegate?.didTapSelectButton(cell: self)
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
