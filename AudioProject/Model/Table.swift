//
//  Table.swift
//  AudioProject
//
//  Created by HoThienHo on 6/21/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation

class Table: NSObject {
    var id: String?
    var name: String?
    var max_numb: NSNumber?
    var time_stamp: NSNumber?
    init(dictionary: [String:AnyObject]){
        self.name = dictionary["name"] as? String
        self.id = dictionary["id"] as? String
        self.max_numb = dictionary["max_numb"] as? NSNumber
        self.time_stamp = dictionary["time_stamp"] as? NSNumber
    }
}
