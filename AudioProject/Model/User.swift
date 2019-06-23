//
//  User.swift
//  AudioProject
//
//  Created by HoThienHo on 6/19/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
class User: NSObject {
    var urlImage: String?
    var name: String?
    var id: String?
    var email: String?
    var phoneNumber: String?
    init(dictionary: [String:AnyObject]){
        self.urlImage = dictionary["urlImage"] as? String
        self.name = dictionary["name"] as? String
        self.id = dictionary["id"] as? String
        self.email = dictionary["email"] as? String
        self.phoneNumber = dictionary["phone_number"] as? String
    }
}
