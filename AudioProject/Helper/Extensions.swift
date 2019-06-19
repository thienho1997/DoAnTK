//
//  Extensions.swift
//  gameofchat
//
//  Created by HoThienHo on 1/29/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        self.image = nil
        //check cache for imgae frist
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject ) as? UIImage {
            DispatchQueue.main.async {
                 self.image = imageFromCache
            }
            return
        }
        
        // otherwise download image
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            // download image hit error
            if error != nil {
                print(error!)
                return
            }
            
            //download successful
           if let image = UIImage(data: data!) {
            DispatchQueue.main.async {
                imageCache.setObject(image, forKey: urlString as AnyObject)
                self.image = image
                //      cell.imageView?.image = image
            }
            }
        }
        task.resume()
    }
}
