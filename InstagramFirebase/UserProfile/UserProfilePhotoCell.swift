//
//  UserProfilePhotoCell.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/12/2.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit

class UserProfilePhotoCell : UICollectionViewCell {
    
    var post : Post? {
        didSet{
            
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
            
        }
    }
    
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
