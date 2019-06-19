//
//  Product.swift
//  AudioProject
//
//  Created by HoThienHo on 6/9/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
class Product: NSObject {
    var imageUrl: String?
    var title: String?
    var detail: String?
    var price: NSNumber?
    var numb: NSNumber?
    var id: String?
    var id_menu: String?
    init(dictionary:[String:Any]){
        self.imageUrl = dictionary["urlImage"] as? String
        self.title = dictionary["name"] as? String
        self.detail = dictionary["detail"] as? String
        self.price = dictionary["price"] as? NSNumber
        self.numb = dictionary["numb"] as? NSNumber
        self.id = dictionary["id_product"] as? String
        self.id_menu = dictionary["id_menu"] as? String
    }
    public func setNumb(numb: NSNumber){
        self.numb = numb
    }
}
