//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/11/4.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader : UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user : User? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
            userNameLabel.text = user?.userName
    
            setupEditFollowButton()
        }
    }
    
    fileprivate func setupEditFollowButton(){
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
        }else{
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists(){
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                }else{
                    self.setupFollowStyle()
                }
    
            }, withCancel: { (err) in
                print("Failed to check if following:", err)
            })
        }
    }
    
    @objc func handleEditProfileOrFollow(){
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
                if err != nil {
                    print("failed to unfollow user")
                    return
                }
                print("successfully unfollow user: \(self.user?.userName ?? "")")
                self.setupFollowStyle()
            })
            
        }else{

            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId: 1]
            ref.updateChildValues(values) { (error, ref) in
                if error != nil {
                print("update following error")
                return
                }
                print("successfully followed user: \(self.user?.userName ?? "")")
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    fileprivate func setupFollowStyle(){
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: UIControlState())
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToListView(){
        delegate?.didChangeToListView()
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    lazy var gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: UIControlState())
        button.tintColor = UIColor.mainBlue()
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)

        return button
    }()
    
    @objc func handleChangeToGridView(){
        delegate?.didChangeToGridView()
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let bookMarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: UIControlState())
        button.tintColor = UIColor(white: 0, alpha: 0.3)

        return button
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "userName"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let postsLabel : UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: UIControlState())
        button.setTitleColor(.black, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
         button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leadingAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
        setupButtonToolbar()
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: profileImageView.bottomAnchor, left: leadingAnchor, bottom: gridButton.topAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
   
        setupUserStatusView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leadingAnchor, bottom: nil, right: followingLabel.trailingAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
    }
    
    fileprivate func setupUserStatusView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.trailingAnchor, bottom: nil, right: trailingAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        
    }
    
    fileprivate func setupButtonToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: nil, left: leadingAnchor, bottom: stackView.topAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leadingAnchor, bottom: nil, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
