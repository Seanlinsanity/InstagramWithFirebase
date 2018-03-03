//
//  CommentsCell.swift
//  InstagramFirebase
//
//  Created by SEAN on 2018/1/15.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else { return }
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
            
            let attributedText = NSMutableAttributedString(string: comment.user.userName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "  " + comment.text, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText
        }
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .blue
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leadingAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        addSubview(textView)
        textView.anchor(top: topAnchor, left: profileImageView.trailingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

