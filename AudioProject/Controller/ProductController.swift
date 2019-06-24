//
//  ProductController.swift
//  LoginPage
//
//  Created by HoThienHo on 6/6/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class ProductController: UITableViewController {

    var menu:Menu? {
        didSet{
            self.navigationItem.title = menu?.name
        }
    }
    var productSelected: Product?
//    let products:[Product] = {
//        let product1 = Product(image: #imageLiteral(resourceName: "banh-trang-nuong-1"), title: "Bánh tráng nướng", detail: "Món ngon người việt", price: 18000, numb: nil)
//        let product2 = Product(image: #imageLiteral(resourceName: "cach-lam-pha-lau-ngon-dung-chuan-khong-can-chinh-hinh-anh-1"), title: "Phá lấu", detail: nil, price: 30000, numb: nil)
//        let product3 = Product(image: #imageLiteral(resourceName: "bánh-tráng-tr-n-dóng-h-p-2"), title: "Bánh tráng trộn", detail: "Ngon không cưỡng nổi", price: 25000, numb: nil)
//        return[product1,product2,product3]
//    }()
    var products = [Product]()
    func fetchProduct(){
        let ref = Database.database().reference().child("products_menu").child((menu?.id)!)
        
        ref.observe(DataEventType.childAdded, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let product = Product(dictionary: dictionary)
                self.products.append(product)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
        ref.observe(DataEventType.childChanged, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let product = Product(dictionary: dictionary)
                self.products.append(product)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    var productsCart = [Product]()
    func fetchNumbInCart(){
        let userId = Auth.auth().currentUser?.uid
        var numberOfProductInCart = 0
        let ref = Database.database().reference().child("users_cart").child(userId!)
        ref.observe(DataEventType.childAdded, with: { (snapShot) in
            let product_id = snapShot.key
            let numb = snapShot.value as! NSNumber
            let refProduct = Database.database().reference().child("products").child(product_id)
            refProduct.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                let product = Product(dictionary: snapShot.value as! [String : Any])
                product.setNumb(numb: numb)
              
                self.productsCart.append(product)
            })
            let valueI = snapShot.value as! Int
             numberOfProductInCart = numberOfProductInCart + valueI
            self.labelNumberForCart.text = "\(numberOfProductInCart)"
        }, withCancel: nil)
        ref.observe(DataEventType.childChanged) { (dataSnap) in
            
              let product_id = dataSnap.key
             let numb = dataSnap.value as! NSNumber
            let refProduct = Database.database().reference().child("products").child(product_id)
            refProduct.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                let product = Product(dictionary: snapShot.value as! [String : Any])
                product.setNumb(numb: numb)
                
                for i in 0..<self.productsCart.count {
                    if ( product.id == self.productsCart[i].id) {
                        numberOfProductInCart = numberOfProductInCart - Int(self.productsCart[i].numb!)
                        numberOfProductInCart = numberOfProductInCart + Int(product.numb!)
                        self.productsCart.remove(at: i)
                        self.productsCart.append(product)
                        self.labelNumberForCart.text = "\(numberOfProductInCart)"
                        
                        return
                    }
                }
                
            })
            
            
            
       
            
           
        }
    }
    lazy var blackView: UIView = {
        let blackView = UIView()
        blackView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        blackView.alpha = 0
        blackView.frame = view.frame
        blackView.frame = CGRect(x: 0, y: 0, width: blackView.frame.width, height: blackView.frame.height)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outOfBlackView)))
        return blackView
    }()
    @objc func outOfBlackView(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.blackView.removeFromSuperview()
            self.viewForDetailProduct.removeFromSuperview()
        }
    }
    let imageViewForDetailProduct: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "banh-trang-nuong-1")
        iv.clipsToBounds = true
        iv.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return iv
    }()
    let labelTileDetailProduct: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Bánh tráng trộn"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
       // lb.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    let textViewInfoDetailProduct: UITextView = {
        let lb = UITextView()
        lb.translatesAutoresizingMaskIntoConstraints = false
       
      //  lb.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return lb
    }()
    let separatedLine: UIView = {
      let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return v
    }()
    let labelQuantity: UILabel = {
        let lb = UILabel()
        lb.text = "Quantity:"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let buttonSubtract: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setImage(#imageLiteral(resourceName: "minus-round-button"), for: UIControl.State.normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bt.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
         bt.addTarget(self, action: #selector(buttonSubtractTap), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func buttonSubtractTap(){
        let numberString  = labelNumber.text
        let newNumber = Int(numberString!)
        if var numb = newNumber, numb != 1{
            numb -= 1
            labelNumber.text = "\(numb)"
        }
    }
    let labelNumber: UILabel = {
        let lb = UILabel()
        lb.text = "1"
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    lazy var buttonPlus: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setImage(#imageLiteral(resourceName: "plus-2"), for: UIControl.State.normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bt.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bt.addTarget(self, action: #selector(buttonPlusTap), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func buttonPlusTap(){
        let numberString  = labelNumber.text
        let newNumber = Int(numberString!)
        if var numb = newNumber {
            numb += 1
            labelNumber.text = "\(numb)"
        }
    }
    let buttonCancel: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bt.layer.cornerRadius = 10
        bt.clipsToBounds = true
        bt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bt.layer.borderWidth = 1
        bt.setTitle("Close", for: UIControl.State.normal)
        bt.addTarget(self, action: #selector(outOfBlackView), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    lazy var buttonAddToCart: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        bt.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bt.layer.cornerRadius = 10
        bt.clipsToBounds = true
        bt.setTitle("Add to cart", for: UIControl.State.normal)
        bt.addTarget(self, action: #selector(addToCartAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func addToCartAction(){
        let numb = Int(labelNumber.text!)
        addProductToCartDatabase(product: productSelected!, numb: numb!)
        outOfBlackView()
        let alertController = UIAlertController(title: "Thông báo", message: "Thêm giỏ hàng thành công", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    lazy var viewForDetailProduct: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        v.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        v.addSubview(imageViewForDetailProduct)
        imageViewForDetailProduct.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        imageViewForDetailProduct.leftAnchor.constraint(equalTo: v.leftAnchor).isActive = true
        imageViewForDetailProduct.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        imageViewForDetailProduct.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        v.addSubview(labelTileDetailProduct)
        labelTileDetailProduct.topAnchor.constraint(equalTo: imageViewForDetailProduct.bottomAnchor, constant: 8).isActive = true
        labelTileDetailProduct.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 8).isActive = true
        labelTileDetailProduct.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelTileDetailProduct.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        v.addSubview(textViewInfoDetailProduct)
        textViewInfoDetailProduct.topAnchor.constraint(equalTo: labelTileDetailProduct.bottomAnchor, constant: 4).isActive = true
        textViewInfoDetailProduct.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 8     ).isActive = true
        textViewInfoDetailProduct.heightAnchor.constraint(equalToConstant: 25).isActive = true
        textViewInfoDetailProduct.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        v.addSubview(separatedLine)
        separatedLine.topAnchor.constraint(equalTo: textViewInfoDetailProduct.bottomAnchor, constant: 22).isActive = true
        separatedLine.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 8).isActive = true
        separatedLine.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -8).isActive = true
        separatedLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        v.addSubview(labelQuantity)
        labelQuantity.topAnchor.constraint(equalTo: separatedLine.bottomAnchor, constant: 28).isActive = true
        labelQuantity.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 8).isActive = true
        labelQuantity.widthAnchor.constraint(equalToConstant: 90).isActive = true
        labelQuantity.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        v.addSubview(buttonSubtract)
        buttonSubtract.centerYAnchor.constraint(equalTo: labelQuantity.centerYAnchor).isActive = true
        buttonSubtract.leftAnchor.constraint(equalTo: labelQuantity.rightAnchor, constant: 8).isActive = true
        buttonSubtract.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonSubtract.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        v.addSubview(labelNumber)
        labelNumber.centerYAnchor.constraint(equalTo: buttonSubtract.centerYAnchor).isActive = true
        labelNumber.leftAnchor.constraint(equalTo: buttonSubtract.rightAnchor, constant: 2).isActive = true
        labelNumber.widthAnchor.constraint(equalToConstant: 50).isActive = true
        labelNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        v.addSubview(buttonPlus)
        buttonPlus.centerYAnchor.constraint(equalTo: labelNumber.centerYAnchor).isActive = true
        buttonPlus.leftAnchor.constraint(equalTo: labelNumber.rightAnchor, constant: 2).isActive = true
        buttonPlus.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonPlus.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        v.addSubview(buttonCancel)
        buttonCancel.topAnchor.constraint(equalTo: labelQuantity.bottomAnchor, constant: 28).isActive = true
        buttonCancel.rightAnchor.constraint(equalTo: v.centerXAnchor, constant: -8).isActive = true
        buttonCancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonCancel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        v.addSubview(buttonAddToCart)
        buttonAddToCart.topAnchor.constraint(equalTo: labelQuantity.bottomAnchor, constant: 28).isActive = true
        buttonAddToCart.leftAnchor.constraint(equalTo: v.centerXAnchor, constant: 8).isActive = true
        buttonAddToCart.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonAddToCart.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        return v
    }()
    let labelNumberForCart: UILabel = {
        let labelNumbe = UILabel()
        labelNumbe.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        labelNumbe.layer.cornerRadius = 7
        labelNumbe.clipsToBounds = true
        labelNumbe.text = "0"
        labelNumbe.textAlignment = .center
        labelNumbe.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelNumbe.font = UIFont(name: labelNumbe.font.fontName, size: 13)
        labelNumbe.translatesAutoresizingMaskIntoConstraints = false
        return labelNumbe
    }()
    lazy var viewForCart: UIView = {
        let v = UIView(frame: CGRect.zero)
       // v.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cartTap)))
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "shopping-cart")
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        v.addSubview(iv)

        //iv.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        iv.topAnchor.constraint(equalTo: v.topAnchor, constant: 5).isActive = true
        iv.leftAnchor.constraint(equalTo: v.leftAnchor, constant:0).isActive = true
        iv.rightAnchor.constraint(equalTo: v.rightAnchor, constant:-5).isActive = true
        iv.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        
        v.addSubview(labelNumberForCart)
        
        labelNumberForCart.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        labelNumberForCart.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        labelNumberForCart.heightAnchor.constraint(equalToConstant: 14).isActive = true
        labelNumberForCart.widthAnchor.constraint(equalToConstant: 14).isActive = true
        return v
    }()
    func addProductToCartDatabase(product: Product, numb: Int){

       // var numbNSNumber = NSNumber(integerLiteral: numb)
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users_cart").child(userId!).child(product.id!)
        ref.observeSingleEvent(of: DataEventType.value) { (snapShot) in
            if let numOld = snapShot.value as? Int {
                let numNew = numb + numOld
                let numbNSNumber = NSNumber(integerLiteral: numNew)
                ref.setValue(numbNSNumber)
            }
            else {
                ref.setValue(numb)
            }
        }
        
    }
    @objc func cartTap(){
        let cartController = CartViewController()
        self.navigationController?.pushViewController(cartController, animated: true)
    }
    let homeButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.custom)
        bt.setTitle("SCAR", for: UIControl.State.normal)
        bt.setImage(#imageLiteral(resourceName: "store"), for: UIControl.State.normal)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.clipsToBounds = true
        // bt.imageView?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        bt.imageEdgeInsets = UIEdgeInsets(top: 4, left: 60, bottom: 4, right: 60)
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -65, bottom: 0, right: 0)
        bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        // bt.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        bt.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: UIControl.State.normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return bt
    }()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ProductCell.self, forCellReuseIdentifier: cellId)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
      
        let buttonItem = UIBarButtonItem(customView: viewForCart)
        self.navigationItem.rightBarButtonItem = buttonItem
        fetchProduct()
        fetchNumbInCart()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductCell
        cell.product_m = products[indexPath.row]
        cell.productController = self
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.addSubview(blackView)
        self.view.addSubview(viewForDetailProduct)
        
        viewForDetailProduct.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewForDetailProduct.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        viewForDetailProduct.heightAnchor.constraint(equalToConstant: 360).isActive = true
        viewForDetailProduct.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0.75
        }
        let product = products[indexPath.row]
        productSelected = product
        imageViewForDetailProduct.loadImageUsingCacheWithUrlString(urlString: product.imageUrl!)
        if let info = product.detail {
            textViewInfoDetailProduct.text = info
        }
        labelTileDetailProduct.text = product.title
    }

}
