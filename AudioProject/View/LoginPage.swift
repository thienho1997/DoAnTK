//
//  LoginPage.swift
//  AudioProject
//
//  Created by HoThienHo on 5/13/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class LoginPage: UICollectionViewCell {
    var viewController: ViewController?
    
    lazy var loginButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("Login", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        return bt
    }()
   
    lazy var signUpButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("Sign Up", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.titleLabel?.font = UIFont(name: (bt.titleLabel?.font.fontName)!, size: 15)
        bt.addTarget(self, action: #selector(signUpTap), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func signUpTap(){
        let signUpPage = SignUpController()
        viewController?.present(signUpPage, animated: true, completion: nil)
    }
    let imageV = #imageLiteral(resourceName: "user").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = imageV
        iv.isOpaque = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder =  "Email address"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tf
    }()
    let separateLine1: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder =  "Your password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tf
    }()
    let separateLine2: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    let imageH = #imageLiteral(resourceName: "checked").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    lazy var loginButtonMain: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(imageH, for: UIControl.State.normal)
        bt.imageView?.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        bt.setTitle("LOG IN", for: .normal)
        bt.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        bt.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControl.State.normal)
        bt.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        bt.layer.borderWidth = 0.5
        bt.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bt.layer.cornerRadius = 15
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(loginAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func loginAction(){
        guard let email = userNameTextField.text, let pass = passwordTextField.text
            else{
                print("form is not valid")
                return
        }
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            print(user?.user.uid)
           
            let ref = Database.database().reference().child("admins")
            ref.observeSingleEvent(of: DataEventType.childAdded, with: { (dtSnapShot) in
                 print(dtSnapShot.key)
                if (user?.user.uid)! == dtSnapShot.key {
                   
                    let adminHomeController = UINavigationController(rootViewController: AdminHomeController())
                    self.viewController?.present(adminHomeController, animated: true, completion: nil)
                    return
                }
                self.viewController?.dismiss(animated: true, completion: nil)
            })
            
            
            //successfully logged in
        }
    }
    func setUpView(){
        self.addSubview(loginButton)
        //need x,y,w,h
        loginButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        loginButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(signUpButton)
        //need x,y,w,h
        signUpButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(userNameTextField)
        userNameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        userNameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.addSubview(separateLine1)
        separateLine1.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 0).isActive = true
        separateLine1.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separateLine1.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        separateLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
       self.addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.addSubview(separateLine2)
        separateLine2.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0).isActive = true
        separateLine2.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separateLine2.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        separateLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.addSubview(loginButtonMain)
        loginButtonMain.topAnchor.constraint(equalTo: separateLine2.bottomAnchor, constant: 60).isActive = true
        loginButtonMain.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButtonMain.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        loginButtonMain.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
