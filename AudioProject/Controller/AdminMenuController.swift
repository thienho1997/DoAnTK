//
//  AdminMenuController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/11/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class AdminMenuController: UITableViewController {
    let cellId = "cellId"
//    let Menus:[Menu] = {
//        let menu1 = Menu(image: #imageLiteral(resourceName: "426798d4508141d997980d5f26658d1b"), name: "Snacks")
//        let menu2 = Menu(image: #imageLiteral(resourceName: "426798d4508141d997980d5f26658d1b"), name: "Main course")
//        let menu3 = Menu(image: #imageLiteral(resourceName: "426798d4508141d997980d5f26658d1b"), name: "Dessert")
//        let menu4 = Menu(image: #imageLiteral(resourceName: "426798d4508141d997980d5f26658d1b"), name: "Drinking")
//        return [menu1,menu2,menu3,menu4]
//    }()
    var menus = [Menu]()
    func fetchMenu(){
        let ref = Database.database().reference().child("menus")
        
            ref.observe(DataEventType.childAdded, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let menu = Menu(dictionary: dictionary)
                self.menus.append(menu)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
        ref.observe(DataEventType.childChanged, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let menu = Menu(dictionary: dictionary)
                self.menus.append(menu)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
       // print(123)
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Edit") { (rowAction, indexPath) in
            let adminEditController = AdminAddMenuController()
            adminEditController.adminMenuController = self
            adminEditController.menu = self.menus[indexPath.row]
            adminEditController.index = indexPath.row
            self.navigationController?.pushViewController(adminEditController, animated: true)
        }
        editButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let deleteButton = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Delete") { (rowAction, indexPath) in
            let menu = self.menus[indexPath.row]
            let databaseRef = Database.database().reference().child("menus").child(menu.id!)
            databaseRef.removeValue { (error, dataRefer) in
                if error != nil {
                    print(error!)
                }
            }
            self.menus.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        deleteButton.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [editButton,deleteButton]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MenuCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.title = "Menu Admin"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let customView = UIView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
        containView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containView.addSubview(customView)
        customView.backgroundColor = #colorLiteral(red: 0.9144216313, green: 0.9144216313, blue: 0.9144216313, alpha: 1)
        
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: UIControl.State.normal)
        button.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("+ Add more items", for: .normal)
        button.addTarget(self, action: #selector(buttonAddAction), for: .touchUpInside)
        
        customView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        tableView.tableFooterView = containView
        fetchMenu()
    }
    @objc func buttonAddAction(){
        let adminAddMenuController = AdminAddMenuController()
        self.navigationController?.pushViewController(adminAddMenuController, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menus.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = menus[indexPath.row]
        let adminProductController = AdminProductController()
      //  productController.viewForCart.isHidden = true
      adminProductController.menu = menu
        
        
        self.navigationController?.pushViewController(adminProductController, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        cell.menu = menus[indexPath.row]
       
        
        return cell
    }
    
    
    
    
}

