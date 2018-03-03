//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/12/10.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet{
            usernameLabel.text = user?.userName
            guard let url = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: url)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(seperatorView)
        profileImageView.anchor(top: nil, left: leadingAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.anchor(top: topAnchor, left: profileImageView.trailingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        seperatorView.anchor(top: nil, left: usernameLabel.leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
