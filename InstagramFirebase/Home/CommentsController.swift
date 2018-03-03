//
//  CommentController.swift
//  InstagramFirebase
//
//  Created by SEAN on 2018/1/15.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate{
    
    var post: Post?
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        fetchComments()
    }
    
    var comments = [Comment]()
    fileprivate func fetchComments(){
        guard let postId = post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]{
                
                guard let uid = dictionary["uid"] as? String else { return }
                
                Database.fetchUserWithUID(uid: uid, completion: { (user) in
                  
                    let comment = Comment(user: user, dictionary: dictionary)
                    self.comments.append(comment)
                    self.collectionView?.reloadData()
                    
                })
            }
            
        }) { (err) in
            print("fetch comments error:",err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(estimatedSize.height, 40 + 8 + 8)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        containerView.isHidden = true
    }
    
    lazy var containerView: CommentInputAccessoryView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView

    }()
    
    
    func didSubmit(commentText: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = post?.id ?? ""
        let value = ["text": commentText, "creationDate": Date().timeIntervalSince1970, "uid" : uid] as [String : Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(value) { (error, ref) in
            
            if error != nil{
                print("failed to update comment in database",error ?? "error")
                return
            }
            print("successfully inserted comment.")
            self.containerView.clearCommentTextField()
        }
    }
    
    
    override var inputAccessoryView: UIView? {
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}
