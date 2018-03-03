//
//  CommentInputTextView.swift
//  InstagramFirebase
//
//  Created by SEAN on 2018/3/2.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment..."
        label.textColor = .lightGray
        return label
    }()
    
    func showPlaceholderLabel(){
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: .UITextViewTextDidChange, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc private func handleTextChange(){
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
