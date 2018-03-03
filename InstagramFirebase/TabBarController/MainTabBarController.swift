//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/11/4.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
            let navPhotoController = UINavigationController(rootViewController: photoSelectorController)
            present(navPhotoController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        view.backgroundColor = .white
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navLoginController = UINavigationController(rootViewController: loginController)
                self.present(navLoginController
                    , animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers()
        
    }
    
    func setupViewControllers(){
        
        let homeNavController = templatenNavViewController(image: #imageLiteral(resourceName: "home"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        let searchNavController = templatenNavViewController(image: #imageLiteral(resourceName: "search"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        let plusNavController = templatenNavViewController(image: #imageLiteral(resourceName: "add"))
        let likeNavController = templatenNavViewController(image: #imageLiteral(resourceName: "like"))
        
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "user")
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController,userProfileNavController]
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templatenNavViewController(image: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let NavController = UINavigationController(rootViewController: viewController)
        NavController.tabBarItem.image = image
        return NavController
        
    }
    
}
