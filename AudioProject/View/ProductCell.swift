//
//  ProductCell.swift
//  AudioProject
//
//  Created by HoThienHo on 6/9/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class ProductCell: UITableViewCell {
    
    var product_m: Product? {
        didSet{
            imageViewLeft.loadImageUsingCacheWithUrlString(urlString: (product_m?.imageUrl)!)
            labelName.text = product_m?.title
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .decimal
            labelPrice.text = currencyFormatter.string(from: (product_m?.price)!)! + "đ"
        }
    }
    let imageViewLeft: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "banh-trang-nuong-1")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        return iv
    }()
    let labelName: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 19)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let labelPrice: UILabel = {
        let lb = UILabel()
        lb.text = "18.000đ"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        lb.textAlignment = .right
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    @objc func addProductToCartDatabase(){
        let numbNSNumber = NSNumber(integerLiteral: 1)
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users_cart").child(userId!).child(product_m!.id!)
        ref.setValue(numbNSNumber)
    }
    lazy var addButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("Add", for: UIControl.State.normal)
        bt.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: UIControl.State.normal)
        bt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bt.layer.cornerRadius = 10
        bt.clipsToBounds = true
        bt.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.layer.borderWidth = 0.5
        bt.translatesAutoresizingMaskIntoConstraints = false
        //        let view = UIView()
        //        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //        bt.addSubview(view)
        //        view.topAnchor.constraint(equalTo: bt.topAnchor, constant: 0).isActive = true
        //        view.rightAnchor.constraint(equalTo: bt.rightAnchor, constant: 0).isActive = true
        //        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        //        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        bt.addTarget(self, action: #selector(addProductToCartDatabase), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    func setUpView(){
        
        addSubview(imageViewLeft)
        imageViewLeft.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageViewLeft.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        imageViewLeft.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageViewLeft.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(labelName)
        labelName.leftAnchor.constraint(equalTo: imageViewLeft.rightAnchor, constant: 30).isActive = true
        labelName.topAnchor.constraint(equalTo: imageViewLeft.topAnchor, constant: 0    ).isActive = true
        labelName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        labelName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(labelPrice)
        labelPrice.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        labelPrice.topAnchor.constraint(equalTo: labelName.topAnchor, constant: 0).isActive = true
        labelPrice.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelPrice.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: labelPrice.bottomAnchor, constant: 5).isActive = true
        addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
