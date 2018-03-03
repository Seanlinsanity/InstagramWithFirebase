//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/11/25.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController : UIViewController {
    
    var selectedImage : UIImage? {
        
        didSet{
            imageView.image = selectedImage
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
     
        setupImageAndTextViews()
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        if #available(iOS 11.0, *){
            containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        }else{
            containerView.anchor(top: view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        }
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leadingAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.trailingAnchor, bottom: containerView.bottomAnchor, right: containerView.trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func handleShare(){
        guard let caption = textView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }
        guard let uploadDate = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(filename).putData(uploadDate, metadata: nil) { (metadata, error) in
            
            if error != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                print("failed to upload post image")
                return
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            
            //print(imageUrl)
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let caption = textView.text else { return }
        guard let postImage = selectedImage else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            
            if err != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("failed to update post in database")
                return
            }
            
            print("successfully save post to database")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
