//
//  Menu.swift
//  AudioProject
//
//  Created by HoThienHo on 6/9/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
class Menu: NSObject {
    var urlImage: String?
    var name: String?
    var id: String?
    init(dictionary: [String:AnyObject]){
        self.urlImage = dictionary["urlImage"] as? String
        self.name = dictionary["name"] as? String
        self.id = dictionary["id_menu"] as? String
    }
}
