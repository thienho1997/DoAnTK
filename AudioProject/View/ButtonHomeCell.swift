//
//  ButtonHomeCell.swift
//  AudioProject
//
//  Created by HoThienHo on 6/9/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
class ButtonHomeCell: UICollectionViewCell{
    
    var button: ButtonHome?{
        didSet{
            imageView.image = button?.image
            labelButton.text = button?.textLabel
        }
    }
    
    let viewBorder: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        v.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        v.layer.borderWidth = 0.5
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        return v
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //  iv.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return iv
    }()
    let labelButton: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        //   lb.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        return lb
    }()
    func setUpView(){
        addSubview(viewBorder)
        viewBorder.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        viewBorder.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        viewBorder.widthAnchor.constraint(equalToConstant: 80).isActive = true
        viewBorder.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: viewBorder.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: viewBorder.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        addSubview(labelButton)
        labelButton.topAnchor.constraint(equalTo: viewBorder.bottomAnchor, constant: 8).isActive = true
        labelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
