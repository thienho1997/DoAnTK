//
//  SignUpController.swift
//  LoginPage
//
//  Created by HoThienHo on 5/29/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class SignUpController: UIViewController {

    lazy var signUpButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("Sign Up", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        
        return bt
    }()
    @objc func signUpAction(){
        if let pass = passwordTextField.text, let passCf = confirmPasswordTextField.text , let email = emailTextField.text,  let name = userNameTextField.text{
            if pass == "" || passCf == "" || email == "" || name == "" {
                print("form is not valid")
                return
            }
            if pass != passCf {
                print (" password confirm not the same password")
                return
            }
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let values = ["name":name,"email":email,"id":(user?.user.uid)!,"urlImage":"https://profile.actionsprout.com/default.jpeg"]
                let ref = Database.database().reference()
                let userReference = ref.child("users").child((user?.user.uid)!)
                userReference.updateChildValues(values as [String: Any], withCompletionBlock: { (error, data) in
                    if let error = error {
                        print(error)
                        return
                    }
                    let alertController = UIAlertController(title: "Thông báo", message: "Đăng ký thành công", preferredStyle: UIAlertController.Style.alert)
                    let cancelAction = UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.default, handler: {
                        (action : UIAlertAction!) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                })
            }
        }
        
    }
    lazy var loginButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("Login", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.titleLabel?.font = UIFont(name: (bt.titleLabel?.font.fontName)!, size: 15)
        bt.addTarget(self, action: #selector(loginViewTap), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func loginViewTap(){
      dismiss(animated: true, completion: nil)
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "photo-camera")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let emailTextField: UITextField = {
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
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder =  "User name"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tf
    }()
    let separateLine2: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder =  "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tf
    }()
    let separateLine3: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder =  "Confirm password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tf
    }()
    let separateLine4: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
     let imageH = #imageLiteral(resourceName: "checked").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    lazy var signUpButtonMain: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(imageH, for: UIControl.State.normal)
        bt.imageView?.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        bt.setTitle("SIGN UP", for: .normal)
        bt.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        bt.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControl.State.normal)
        bt.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        bt.layer.borderWidth = 0.5
        bt.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bt.layer.cornerRadius = 15
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(signUpAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    func setUpView(){
    
        view.addSubview(signUpButton)
        //need x,y,w,h
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(loginButton)
        //need x,y,w,h
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
       
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(emailTextField)
       emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(separateLine1)
        separateLine1.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        separateLine1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separateLine1.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        separateLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(userNameTextField)
        userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        userNameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(separateLine2)
        separateLine2.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 0).isActive = true
        separateLine2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separateLine2.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        separateLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(separateLine3)
        separateLine3.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0).isActive = true
        separateLine3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separateLine3.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        separateLine3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(confirmPasswordTextField)
       confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(separateLine4)
        separateLine4.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 0).isActive = true
        separateLine4.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separateLine4.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        separateLine4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(signUpButtonMain)
        signUpButtonMain.topAnchor.constraint(equalTo: separateLine4.bottomAnchor, constant: 60).isActive = true
        signUpButtonMain.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButtonMain.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        signUpButtonMain.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpView()
    }
    

    

}
