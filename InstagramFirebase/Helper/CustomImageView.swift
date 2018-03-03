//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/12/2.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if let err = err {
                print("failed to fetch post image, \(err)")
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
        
    }
    
}
