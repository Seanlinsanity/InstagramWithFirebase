//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/11/3.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setImage(#imageLiteral(resourceName: "add_photo"), for: UIControlState())
        
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: UIControlState())
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: UIControlState())
        }
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
    
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let emailtf = UITextField()
        emailtf.placeholder = "Email"
        emailtf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        emailtf.borderStyle = .roundedRect
        emailtf.font = UIFont.systemFont(ofSize: 14)
        
        emailtf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return emailtf
    }()
    
    let nameTextField: UITextField = {
        let nametf = UITextField()
        nametf.placeholder = "name"
        nametf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        nametf.borderStyle = .roundedRect
        nametf.font = UIFont.systemFont(ofSize: 14)
        
        nametf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        
        return nametf
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
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: UIControlState())
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: UIControlState())
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sing Up", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: UIControlState())
       
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowLogin(){
      _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextInput() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && nameTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainBlue()
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, email.count > 0, password.count > 0, name.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error ?? "sign up error")
                return
            }
            print("successfully sign up for the new user")
            
            guard let image = self.plusPhotoButton.imageView?.image else{ return }
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else{ return }
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error ?? "upload image error")
                }
                
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else{ return }
                
                print("sucessfully uploaded image", profileImageUrl)
                
                guard let uid = user?.uid else{ return }
                guard let fcmToken = Messaging.messaging().fcmToken else { return }
                let values = ["name": name, "email": email, "password": password, "profileImageUrl" : profileImageUrl, "fcmToken": fcmToken] as [String : Any]
                
                Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if err != nil {
                            print(err ?? "update values error")
                    }
                    
                    print("update values in firebase")
                    
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else{ return }
                    
                    mainTabBarController.setupViewControllers()
                    
                    self.dismiss(animated: true, completion: nil)
                })
                
            })
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if #available(iOS 11.0, *){
            plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        }else{
           plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        }
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 180).isActive = true
       
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    fileprivate func setupInputFields() {
        
        
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        if #available(iOS 11.0, *){
            stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        }else{
            stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        }

    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor? , right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {

        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
           self.trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}



