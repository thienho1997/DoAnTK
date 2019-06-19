//
//  CustomTabBarController.swift
//  LoginPage
//
//  Created by HoThienHo on 6/1/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeController = HomeController()
        homeController.customTabBarController = self
        let homeNaviController = UINavigationController(rootViewController: homeController)
        homeNaviController.title = "Home"
        homeNaviController.tabBarItem.image = #imageLiteral(resourceName: "home-icon-silhouette")
        
        let menuController = MenuController()
        let menuNaviController = UINavigationController(rootViewController: menuController)
        menuNaviController.title = "Menu"
        menuNaviController.tabBarItem.image = #imageLiteral(resourceName: "menu")
        
        let profileController = ProfileController()
        let profileNavicontroller = UINavigationController(rootViewController: profileController)
        profileNavicontroller.title = "Profile"
        profileNavicontroller.tabBarItem.image = #imageLiteral(resourceName: "users-3")
        
        
        self.viewControllers = [homeNaviController,menuNaviController,profileNavicontroller]
        self.tabBar.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.tabBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
