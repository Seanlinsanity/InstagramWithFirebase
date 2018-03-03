//
//  PreviewPhotoContainerView.swift
//  InstagramFirebase
//
//  Created by SEAN on 2018/1/10.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageVIew: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancel(){
        self.removeFromSuperview()
    }
    
    @objc func handleSave(){
        
        guard let previewImageView = previewImageVIew.image else { return }
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImageView)
            
        }) { (success, err) in
            if let err = err {
                print("failed to save photo to photo library:", err)
            }
        }
        print("successfully save photo to photo library")
        
        DispatchQueue.main.async {
            let savedLabel = UILabel()
            savedLabel.text = "Saved Successfully"
            savedLabel.textColor = .white
            savedLabel.textAlignment = .center
            savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.numberOfLines = 0
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            
            savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            savedLabel.center = self.center
            self.addSubview(savedLabel)
            
            savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
            }, completion: { (completion) in
                UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                
                }, completion: { (_) in
                    savedLabel.removeFromSuperview()
                })
            })
            self.addSubview(savedLabel)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        
        addSubview(previewImageVIew)
        previewImageVIew.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leadingAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leadingAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 50, height: 50)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
