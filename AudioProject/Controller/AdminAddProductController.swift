//
//  AdminAddProductController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/16/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
class AdminAddProductController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var adminProductController: AdminProductController?
    var index: Int?
    var flag = 0
    var menu: Menu?
    @objc func handleSelectProfileImageView(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel Picker")
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageViewForMenu.image = selectedImage
        }
        labelInstruct.isHidden = true
        flag = 1
        self.dismiss(animated: true, completion: nil)
    }
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Price"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let detailLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Detail"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let imageLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Your image"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        // tf.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return tf
    }()
    let priceTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        // tf.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return tf
    }()
    let detailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        // tf.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return tf
    }()
    let labelInstruct: UILabel = {
        let lb = UILabel()
        //   lb.text = "Choose image \n here"
        
        let atributedText = NSMutableAttributedString(string: "Choose image \n here", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        atributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: atributedText.string.count))
        
        lb.attributedText = atributedText
        //  lb.font = UIFont(name: lb.font.fontName, size: 15)
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    lazy var imageViewForMenu: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        iv.layer.borderWidth = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        iv.addSubview(labelInstruct)
        labelInstruct.centerXAnchor.constraint(equalTo: iv.centerXAnchor).isActive = true
        labelInstruct.centerYAnchor.constraint(equalTo: iv.centerYAnchor).isActive = true
        labelInstruct.heightAnchor.constraint(equalToConstant: 40).isActive = true
        labelInstruct.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()
    lazy var buttonAdd: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Add", for: UIControl.State.normal)
        bt.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        bt.layer.cornerRadius = 15
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.clipsToBounds = true
        bt.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.addTarget(self, action: #selector(addAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    func addAndEdit(product: Product?){
        guard let name = nameTextField.text,  let detail = detailTextField.text else {
            print("form is not valid")
            return
        }
        let price = NSNumber(value: Int(priceTextField.text!)!)
        let menu_id = menu?.id
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Image").child("\(imageName).jpg")
        if let imageForMenu = self.imageViewForMenu.image, let uploadData = imageForMenu.jpegData(compressionQuality: 0.1)
        {
            storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let imageUrl = url?.absoluteString {
                        var ref: DatabaseReference?
                    
                        if product == nil {
                            ref = Database.database().reference().child("products_menu").child((self.menu?.id)!).childByAutoId()
                           
                        }
                        else{
                            ref = Database.database().reference().child("products_menu").child((self.menu?.id)!).child((product?.id)!)
                        }
                        
                          let values = ["name":name,"urlImage":imageUrl,"id_product": ref!.key,"price": price, "detail": detail] as [String : Any]
                        ref!.updateChildValues(values, withCompletionBlock: { (error, data) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            let refFather = Database.database().reference().child("products").child(ref!.key!)
                            refFather.updateChildValues(values)
                        })
                    }
                })
                
                
            })
        }
    }
    @objc func addAction(){
        adminProductController?.products.remove(at: index!)
        if product == nil {
            addAndEdit(product: nil)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            if flag == 1 {
                addAndEdit(product: product!)
                self.navigationController?.popViewController(animated: true)
                flag = 0
            }
            else{
                guard let name = nameTextField.text, let detail = detailTextField.text else {
                    print("form is not valid")
                    return
                }
                let ref = Database.database().reference().child("products_menu").child((menu?.id)!).child((product?.id)!)
                let price = NSNumber(value: Int(priceTextField.text!)!)
                let values = ["name":name,"urlImage":product?.imageUrl,"id_product": ref.key,"price": price , "detail": detail ] as [String : Any]
                ref.updateChildValues(values, withCompletionBlock: { (error, data) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let refFather = Database.database().reference().child("products").child(ref.key!)
                    refFather.updateChildValues(values)
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
        }
    }
    func setUpView(){
        self.view.addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(nameTextField)
        nameTextField.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 8).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.view.addSubview(detailLabel)
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(detailTextField)
        detailTextField.centerYAnchor.constraint(equalTo: detailLabel.centerYAnchor).isActive = true
        detailTextField.leftAnchor.constraint(equalTo: detailLabel.rightAnchor, constant: 8).isActive = true
        detailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        detailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.view.addSubview(priceLabel)
       priceLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 16).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: detailLabel.leftAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.view.addSubview(priceTextField)
        priceTextField.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        priceTextField.leftAnchor.constraint(equalTo: detailLabel.rightAnchor, constant: 8).isActive = true
        priceTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.view.addSubview(imageViewForMenu)
        imageViewForMenu.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -16).isActive = true
        imageViewForMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageViewForMenu.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageViewForMenu.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(buttonAdd)
        buttonAdd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        buttonAdd.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70).isActive = true
        buttonAdd.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
        buttonAdd.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    var product: Product? {
        didSet{
            buttonAdd.setTitle("Edit", for: UIControl.State.normal)
            imageViewForMenu.loadImageUsingCacheWithUrlString(urlString: (product?.imageUrl)!)
            labelInstruct.isHidden = true
            nameTextField.text = product?.title
            priceTextField.text = product?.price?.stringValue
            detailTextField.text = product?.detail
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpView()
        if product != nil {
            self.navigationItem.title = "Product Edit"
        }
        else {
            self.navigationItem.title = "Add Product"
        }
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    
    
}
