//
//  MenuController.swift
//  LoginPage
//
//  Created by HoThienHo on 6/1/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class MenuController: UITableViewController {
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MenuCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.title = "Menu"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        fetchMenu()
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
        let productController = ProductController()
        productController.menu = menu
        self.navigationController?.pushViewController(productController, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        cell.menu = menus[indexPath.item]

        return cell
    }
 

    

}

