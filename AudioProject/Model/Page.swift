//
//  Page.swift
//  AudioProject
//
//  Created by HoThienHo on 5/11/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit

class Page {
    let title: String?
    let message: String?
    let image: UIImage?
    init(title: String, message: String, image: UIImage) {
        self.title = title
        self.message = message
        self.image = image
    }
}
