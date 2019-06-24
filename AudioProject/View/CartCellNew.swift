//
//  CartCellNew.swift
//  AudioProject
//
//  Created by HoThienHo on 6/23/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class CartCellNew: UITableViewCell {
    var cartController: CartViewController?
    var index: Int?
    var product: Product? {
        didSet {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .decimal
            imageLeft.loadImageUsingCacheWithUrlString(urlString: (product?.imageUrl)!)
            labelDishName.text = "\(product!.numb!)x" + product!.title!
            labelDetailPrice.text = "\(product!.numb!)x" + currencyFormatter.string(from: (product?.price)!)! + "đ"
        }
    }
    let imageLeft: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //  iv.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return iv
    }()
    let labelDishName: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        lb.translatesAutoresizingMaskIntoConstraints = false
        //  lb.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    let labelDetailPrice: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: lb.font.fontName, size: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        //  lb.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    lazy var buttonEdit: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(#imageLiteral(resourceName: "iconfinder_brush-pencil_1055103"), for: UIControl.State.normal)
        // bt.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        bt.addTarget(self, action: #selector(editProduct), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func editProduct(){
        let alertController = UIAlertController(title: "Edit Product", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter new quantity"
        }
        let cancelAction = UIAlertAction(title: "Thoát", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        let agreeAction = UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.default, handler: { alert -> Void in
             let quantity = alertController.textFields![0] as UITextField
             let uid = Auth.auth().currentUser?.uid
             let ref = Database.database().reference().child("users_cart").child(uid!).child(self.product!.id!)
            let numb = Int(quantity.text!)
            ref.setValue(numb!)
            
            for i in 0 ..< self.cartController!.products.count {
                if self.product!.id! == self.cartController!.products[i].id! {
                    self.cartController!.products[i].setNumb(numb: NSNumber(integerLiteral: numb!))
                    self.cartController!.tableView.reloadData()
                    break
                }
            }
            
            
            let userId = Auth.auth().currentUser?.uid
            var total = 0
            let refUserCart = Database.database().reference().child("users_cart").child(userId!)
            refUserCart.observe(DataEventType.childAdded) { (snapShot) in
                let product_id = snapShot.key
                let numb = snapShot.value as! NSNumber
                let refProduct = Database.database().reference().child("products").child(product_id)
                refProduct.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                    let product = Product(dictionary: snapShot.value as! [String : Any])
                    product.setNumb(numb: numb)
                    total += Int(truncating: product.price!) * Int(numb)
        
                    // total label
                    let currencyFormatter = NumberFormatter()
                    currencyFormatter.usesGroupingSeparator = true
                    currencyFormatter.numberStyle = .decimal
                    self.cartController!.lableTotalPrice.text = "Total: " + currencyFormatter.string(from: NSNumber(integerLiteral: total))! + "đ"
                })
                
                
            }
            
            
        })
        alertController.addAction(agreeAction)
        alertController.addAction(cancelAction)
        cartController?.present(alertController, animated: true, completion: nil)
    }
    lazy var buttonRemove: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(#imageLiteral(resourceName: "iconfinder_flat-style-circle-delete-trash_1312512"), for: UIControl.State.normal)
        //  bt.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        bt.addTarget(self, action: #selector(removeProduct), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func removeProduct(){
        
       
        let alertController = UIAlertController(title: "Thông báo", message: "Bạn có thật sự muốn xoá sản phẩm này khỏi giỏ hàng không?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Thoát", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        let agreeAction = UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.default, handler: { alert -> Void in
            
            for i in 0 ..< self.cartController!.products.count {
                if self.product!.id! == self.cartController!.products[i].id! {
                    self.cartController!.products.remove(at: i)
                    self.cartController!.tableView.reloadData()
                    break
                }
            }
            let uid = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference().child("users_cart").child(uid!).child(self.product!.id!)
            ref.removeValue()
            let userId = Auth.auth().currentUser?.uid
            var total = 0
            let refUserCart = Database.database().reference().child("users_cart").child(userId!)
            refUserCart.observe(DataEventType.childAdded) { (snapShot) in
                let product_id = snapShot.key
                let numb = snapShot.value as! NSNumber
                let refProduct = Database.database().reference().child("products").child(product_id)
                refProduct.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                    let product = Product(dictionary: snapShot.value as! [String : Any])
                    product.setNumb(numb: numb)
                    total += Int(truncating: product.price!) * Int(numb)
                    
                    // total label
                    let currencyFormatter = NumberFormatter()
                    currencyFormatter.usesGroupingSeparator = true
                    currencyFormatter.numberStyle = .decimal
                    self.cartController!.lableTotalPrice.text = "Total: " + currencyFormatter.string(from: NSNumber(integerLiteral: total))! + "đ"
                })
                
                
            }
            
        })
        alertController.addAction(agreeAction)
        alertController.addAction(cancelAction)
        cartController?.present(alertController, animated: true, completion: nil)
    }
    func setUpView(){
        addSubview(imageLeft)
        imageLeft.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageLeft.leftAnchor.constraint(equalTo: leftAnchor,constant: 12).isActive = true
        imageLeft.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageLeft.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(labelDishName)
        labelDishName.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        labelDishName.leftAnchor.constraint(equalTo: imageLeft.rightAnchor, constant: 8).isActive = true
        labelDishName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        labelDishName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(labelDetailPrice)
        labelDetailPrice.topAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        labelDetailPrice.leftAnchor.constraint(equalTo: imageLeft.rightAnchor, constant: 8).isActive = true
        labelDetailPrice.widthAnchor.constraint(equalToConstant: 200).isActive = true
        labelDetailPrice.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(buttonEdit)
        buttonEdit.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonEdit.leftAnchor.constraint(equalTo: labelDishName.rightAnchor, constant: 16).isActive = true
        buttonEdit.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonEdit.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(buttonRemove)
        buttonRemove.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonRemove.leftAnchor.constraint(equalTo: buttonEdit.rightAnchor, constant: 12).isActive = true
        buttonRemove.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonRemove.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        setUpView()
        self.backgroundColor = #colorLiteral(red: 0.9144216313, green: 0.9144216313, blue: 0.9144216313, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
