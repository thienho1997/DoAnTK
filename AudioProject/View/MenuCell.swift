//
//  MenuCell.swift
//  AudioProject
//
//  Created by HoThienHo on 6/9/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
class MenuCell: UITableViewCell {
    
    var menu:Menu? {
        didSet{
            imageViewL.loadImageUsingCacheWithUrlString(urlString: (menu?.urlImage)!)
            labelName.text = menu?.name
            print(menu?.name)
        }
    }
    let imageViewL:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "426798d4508141d997980d5f26658d1b")
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let labelName: UILabel = {
        let label = UILabel()
        label.text = "Snacks"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageViewR:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "right-arrow")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    func setUpView(){
        addSubview(imageViewL)
        imageViewL.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageViewL.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        imageViewL.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageViewL.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(labelName)
        labelName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        labelName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(imageViewR)
        imageViewR.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageViewR.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        imageViewR.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageViewR.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
