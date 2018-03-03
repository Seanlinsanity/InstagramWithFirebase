//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/12/7.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    
        setupNavigationItem()
        fetchAllPosts()
    }
    
    @objc func handleRefresh(){
        posts = [Post]()//posts.removeAll()
        //The reason of reloading data here is to fix the bug of refreshing, which makes index out of range for the collectionViewCell
        collectionView?.reloadData()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts(){
        fetchPosts()
        fetchFollowingUserId()
    }
    
    fileprivate func fetchFollowingUserId(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (err) in
            print("failed to fetch following user ids:", err)
        }
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
//        Database.fetchUserWithUID(uid: uid) { (user) in
//            self.fetchPostsWithUser(user: user)
//        }
        Database.fetchUserWithUID(uid: uid, completion: (fetchPostsWithUser))
    }
    
    fileprivate func fetchPostsWithUser(user: User) {

        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    }else{
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (_) in
                    print("failed to fetch like info for post")
                })
            })
        }, withCancel: nil)
        
    }
    
    func setupNavigationItem() {
        
        let titleImage : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: "instagram")?.withRenderingMode(.alwaysTemplate)
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .black
            
            return iv
        }()
        
        navigationItem.titleView = titleImage
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height : CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    func didTapComment(post: Post) {
        print("Message coming from HomeController")
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePostCell){
        print("handle like")
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        
        let value = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(value) { (err, _) in
            
            if err != nil{
                print("failed to like", err ?? "error")
                return
            }
            
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView?.reloadItems(at: [indexPath])
        }
        
    }
}
