//
//  Address.swift
//  AudioProject
//
//  Created by HoThienHo on 6/19/19.
//  Copyright © 2019 hothienho. All rights reserved.
//


import Foundation
import UIKit
class Adrress: NSObject {
    var name: String?
    var id: String?
    var adrress: String?
    var phoneNumber: String?
    init(dictionary: [String:AnyObject]){
        self.name = dictionary["name"] as? String
        self.id = dictionary["id"] as? String
        self.adrress = dictionary["address"] as? String
        self.phoneNumber = dictionary["phone_number"] as? String
    }
}
