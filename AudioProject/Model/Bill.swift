//
//  Bill.swift
//  AudioProject
//
//  Created by HoThienHo on 6/23/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
class Bill: NSObject{
    var id: String?
    var id_table: String?
    var id_cart: String?
    var active: NSNumber?
    var id_address: String?
    var totalPrice: String?
    init(dictionary: [String:AnyObject]){
        self.id_cart = dictionary["id_cart"] as? String
        self.id = dictionary["id"] as? String
        self.id_table = dictionary["id_table"] as? String
        self.active = dictionary["active"] as? NSNumber
        self.id_address = dictionary["id_address"] as? String
        self.totalPrice = dictionary["totalPrice"] as? String
    }
}
