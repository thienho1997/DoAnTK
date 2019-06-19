//
//  ProfileController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/16/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddressCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }

    let imageViewProfile: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 35
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "ma19tr101-2")
      //  iv.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let nameLabel: UILabel = {
        let lb = UILabel()
     //   lb.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        lb.text = "Bill Gates"
        lb.font = UIFont.boldSystemFont(ofSize: 21)
        lb.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let emailLabel: UILabel = {
        let lb = UILabel()
      //  lb.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        lb.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lb.text = "BillGates@outlook.com"
        lb.font = UIFont(name: lb.font.fontName, size: 14)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let phoneNumberLabel: UILabel = {
        let lb = UILabel()
     //   lb.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lb.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lb.text = "0123456789"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: lb.font.fontName, size: 14)
        return lb
    }()
    let editButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
     //   bt.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        bt.setImage(#imageLiteral(resourceName: "pencil-in-black-circular-interface-button"), for: UIControl.State.normal)
        return bt
    }()
    lazy var viewForProfileDetail: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
       v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.addSubview(imageViewProfile)
        imageViewProfile.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 8 ).isActive = true
        imageViewProfile.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        imageViewProfile.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewProfile.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        v.addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: imageViewProfile.centerYAnchor).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 215).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: imageViewProfile.rightAnchor, constant: 16).isActive = true
        
        v.addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -1).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageViewProfile.rightAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 215).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        v.addSubview(phoneNumberLabel)
        phoneNumberLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 1).isActive = true
        phoneNumberLabel.leftAnchor.constraint(equalTo: imageViewProfile.rightAnchor, constant: 16).isActive = true
        phoneNumberLabel.widthAnchor.constraint(equalToConstant:215).isActive = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        v.addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -20).isActive = true
        editButton.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return v
    }()
    let imageViewLock: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "lock")
      //  iv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return iv
    }()
    let lableChangePass: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Change password"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    let imageViewDirection: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "next")
        //  iv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return iv
    }()
    lazy var viewForChangePass: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.addSubview(imageViewLock)
        imageViewLock.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        imageViewLock.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 8).isActive = true
        imageViewLock.heightAnchor.constraint(equalToConstant: 35).isActive = true
        imageViewLock.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        v.addSubview(lableChangePass)
        lableChangePass.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        lableChangePass.leftAnchor.constraint(equalTo: imageViewLock.rightAnchor, constant: 8).isActive = true
        lableChangePass.widthAnchor.constraint(equalToConstant: 200).isActive = true
        lableChangePass.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        v.addSubview(imageViewDirection)
        imageViewDirection.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -20).isActive = true
        imageViewDirection.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        imageViewDirection.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageViewDirection.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return v
    }()
    let cellId = "cellId"
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(AddressCell.self, forCellReuseIdentifier: cellId)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        //footer
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let customView = UIView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
        containView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containView.addSubview(customView)
       // customView.backgroundColor = #colorLiteral(red: 0.9144216313, green: 0.9144216313, blue: 0.9144216313, alpha: 1)
        
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: UIControl.State.normal)
        button.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("+Add new address", for: .normal)
      //  button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        customView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        tb.tableFooterView = containView
        
        return tb
    }()
    lazy var buttonLogOut: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Log out", for: UIControl.State.normal)
        bt.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        bt.layer.cornerRadius = 15
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.clipsToBounds = true
        bt.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.addTarget(self, action: #selector(handleLogout), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
       // self.dismiss(animated: true, completion: nil)
        let loginController = ViewController()
        present(loginController, animated: true, completion: nil)
    }
    func setUpView(){
       
        
        self.view.addSubview(viewForProfileDetail)
        viewForProfileDetail.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewForProfileDetail.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
         viewForProfileDetail.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        viewForProfileDetail.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(viewForChangePass)
        viewForChangePass.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewForChangePass.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewForChangePass.topAnchor.constraint(equalTo: viewForProfileDetail.bottomAnchor, constant: 12).isActive = true
        viewForChangePass.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: viewForChangePass.bottomAnchor,constant: 12).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        view.addSubview(buttonLogOut)
        buttonLogOut.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        buttonLogOut.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70).isActive = true
        buttonLogOut.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
        buttonLogOut.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Profile"
        
        setUpView()
        // Do any additional setup after loading the view.
    }
    
}
class AddressCell: UITableViewCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
