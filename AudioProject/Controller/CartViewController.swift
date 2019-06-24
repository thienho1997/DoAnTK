//
//  CartViewController.swift
//  LoginPage
//
//  Created by HoThienHo on 6/8/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    let products:[Product] = {
//        let product1 = Product(image: #imageLiteral(resourceName: "banh-trang-nuong-1"), title: "Bánh tráng nướng", detail: "Món ngon người việt", price: 18000, numb: 2)
//        let product2 = Product(image: #imageLiteral(resourceName: "cach-lam-pha-lau-ngon-dung-chuan-khong-can-chinh-hinh-anh-1"), title: "Phá lấu", detail: nil, price: 30000, numb: 3)
//        let product3 = Product(image: #imageLiteral(resourceName: "bánh-tráng-tr-n-dóng-h-p-2"), title: "Bánh tráng trộn", detail: "Ngon không cưỡng nổi", price: 25000, numb: 1)
//        return[product1,product2,product3]
//    }()
    var products = [Product]()
    func fetchProduct(){
        let userId = Auth.auth().currentUser?.uid
        var total = 0
        let ref = Database.database().reference().child("users_cart").child(userId!)
        ref.observe(DataEventType.childAdded) { (snapShot) in
            let product_id = snapShot.key
            let numb = snapShot.value as! NSNumber
            let refProduct = Database.database().reference().child("products").child(product_id)
            refProduct.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                let product = Product(dictionary: snapShot.value as! [String : Any])
                product.setNumb(numb: numb)
                total += Int(truncating: product.price!) * Int(numb)
                self.products.append(product)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                // total label
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .decimal
                self.lableTotalPrice.text = "Total: " + currencyFormatter.string(from: NSNumber(integerLiteral: total))! + "đ"
            })
          
           
        }

        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CartCellNew
        cell.product = products[indexPath.row]
        cell.cartController = self
        return cell
    }
    let cellId = "cellId"
    let lableTotalPrice: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(CartCellNew.self, forCellReuseIdentifier: cellId)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //footer
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let customView = UIView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
        containView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containView.addSubview(customView)
        customView.backgroundColor = #colorLiteral(red: 0.9144216313, green: 0.9144216313, blue: 0.9144216313, alpha: 1)
        
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: UIControl.State.normal)
        button.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("Add more items", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        customView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: 16).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        customView.addSubview(lableTotalPrice)
        lableTotalPrice.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        lableTotalPrice.leftAnchor.constraint(equalTo: button.rightAnchor, constant: 40).isActive = true
        lableTotalPrice.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lableTotalPrice.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tb.tableFooterView = containView
        
        return tb
    }()
    
    @objc func buttonAction(){
        print(123)
        let orderDetailController = OrderDetailController()
        orderDetailController.products = products
        orderDetailController.totalPrice = lableTotalPrice.text
        self.navigationController?.pushViewController(orderDetailController, animated: true)
    }
    lazy var buttonContinue: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Continue", for: UIControl.State.normal)
        bt.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        bt.layer.cornerRadius = 15
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.clipsToBounds = true
        bt.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    func setUpView(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        view.addSubview(buttonContinue)
        buttonContinue.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        buttonContinue.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70).isActive = true
        buttonContinue.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
        buttonContinue.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //title NavigationItem
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Cart"
        setUpView()
        fetchProduct()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
