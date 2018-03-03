//
//  CommentInputAccessoryView.swift
//  InstagramFirebase
//
//  Created by SEAN on 2018/3/2.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(commentText: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField(){
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    fileprivate let submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return submitButton
    }()
    
    fileprivate let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        autoresizingMask = .flexibleHeight

        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leadingAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        setupSeperatorLine()
        
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    private func setupSeperatorLine(){
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(seperatorView)
        seperatorView.anchor(top: topAnchor, left: leadingAnchor, bottom: nil, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc func handleSubmit(){
        guard let text = commentTextView.text else { return }
        delegate?.didSubmit(commentText: text)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
