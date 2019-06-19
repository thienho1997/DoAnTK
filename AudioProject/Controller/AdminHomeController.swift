//
//  AdminController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/11/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class AdminHomeController: UIViewController {
   
    lazy var buttonQLMonAn: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Quan Ly Mon An", for: UIControl.State.normal)
        bt.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        bt.addTarget(self, action: #selector(qlMonAnAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func qlMonAnAction(){
        let adminMenuController = AdminMenuController()
        self.navigationController?.pushViewController(adminMenuController, animated: true)
    }
    lazy var logOutButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Log out", for: UIControl.State.normal)
        bt.addTarget(self, action: #selector(logOutAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func logOutAction(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
     //   let loginController = ViewController()
        self.dismiss(animated: false, completion: nil)
    //    present(loginController, animated: true, completion: nil)
    }
    func setUpTitleNavigation(){
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Admin"
    }
    func setUpSubViews(){
        self.view.addSubview(buttonQLMonAn)
        buttonQLMonAn.leftAnchor.constraint(equalTo: view.leftAnchor
            , constant: 8).isActive = true
        buttonQLMonAn.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        buttonQLMonAn.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        buttonQLMonAn.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        
        view.addSubview(logOutButton)
        logOutButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpTitleNavigation()
        setUpSubViews()
        // Do any additional setup after loading the view.
    }
    

}
