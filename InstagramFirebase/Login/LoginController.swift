//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/11/4.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let logoContainerView : UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "instagram"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let emailTextField: UITextField = {
        let emailtf = UITextField()
        emailtf.placeholder = "Email"
        emailtf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        emailtf.borderStyle = .roundedRect
        emailtf.font = UIFont.systemFont(ofSize: 14)
        
        emailtf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return emailtf
    }()
    
    let passwordTextField: UITextField = {
        let passwordtf = UITextField()
        passwordtf.placeholder = "password"
        passwordtf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        passwordtf.borderStyle = .roundedRect
        passwordtf.font = UIFont.systemFont(ofSize: 14)
        
        passwordtf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return passwordtf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: UIControlState())
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: UIControlState())
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let notHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sing Up", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: UIControlState())
       
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp(){
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc func handleTextInput() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil{
                print(error ?? "log in failed")
                return
            }
            guard let uid = user?.uid else { return }
            guard let fcmToken = Messaging.messaging().fcmToken else { return }
            let value = ["fcmToken": fcmToken]
            Database.database().reference().child("users").child(uid).updateChildValues(value, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print("failed to update fcmToken")
                }
                print("successfully update fcmToken")
            })
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else{ return }
            
            mainTabBarController.setupViewControllers()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
    
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        view.addSubview(notHaveAccountButton)
        notHaveAccountButton.anchor(top: nil, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields() {
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        if #available(iOS 11.0, *) {
            stackView.anchor(top: logoContainerView.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        }else{
            stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        }
        
        
    }
}
