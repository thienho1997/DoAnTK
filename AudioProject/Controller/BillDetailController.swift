//
//  BillDetailController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/23/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class BillDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var historyController: HistoryController?
    var bill: Bill?
    {
        didSet{
            if bill?.active == 0 {
                buttonPay.isHidden = true
            }
           self.lableTotalPrice.text = bill?.totalPrice
            fetchProduct()
           
            if let id_table = bill?.id_table {
            let refTable = Database.database().reference().child("tables").child(id_table)
            refTable.observeSingleEvent(of: DataEventType.value) { (snapShot) in
                let table = Table(dictionary: snapShot.value as! [String : AnyObject])
                self.lableLocation.text = table.name
                }
            }
            else{
                let refAdress = Database.database().reference().child("addrresses").child((bill?.id_address)!)
                refAdress.observeSingleEvent(of: DataEventType.value) { (snapShot) in
                    let address = Adrress(dictionary: snapShot.value as! [String : AnyObject])
                    self.lableLocation.text = "Address:" + address.adrress!
                }
            }
        }
    }
    var products = [Product]()
    func fetchProduct(){
        let userId = Auth.auth().currentUser?.uid
//        var total = 0
        let ref = Database.database().reference().child("carts").child((bill?.id_cart)!)
        ref.observe(DataEventType.childAdded) { (snapShot) in
            let product_id = snapShot.key
            let numb = snapShot.value as! NSNumber
            let refProduct = Database.database().reference().child("products").child(product_id)
            refProduct.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                let product = Product(dictionary: snapShot.value as! [String : Any])
                product.setNumb(numb: numb)
             //   total += Int(truncating: product.price!) * Int(numb)
                self.products.append(product)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                // total label
//                let currencyFormatter = NumberFormatter()
//                currencyFormatter.usesGroupingSeparator = true
//                currencyFormatter.numberStyle = .decimal
//                self.lableTotalPrice.text = "Total: " + currencyFormatter.string(from: NSNumber(integerLiteral: total))! + "đ"
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
        cell.buttonEdit.isHidden = true
        cell.buttonRemove.isHidden = true
        cell.product = products[indexPath.row]
        return cell
    }
    let cellId = "cellId"
    
    let lableLocation: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return lb
    }()
    let lableTotalPrice: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return lb
    }()
    let lableChiTiet: UILabel = {
        let lb = UILabel()
        lb.text = "Chi tiết"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 16)
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
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let customView = UIView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 75))
        containView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containView.addSubview(customView)
        customView.backgroundColor = #colorLiteral(red: 0.9144216313, green: 0.9144216313, blue: 0.9144216313, alpha: 1)
        
        customView.addSubview(lableLocation)
        lableLocation.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8).isActive = true
        lableLocation.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: 16).isActive = true
        lableLocation.rightAnchor.constraint(equalTo: customView.rightAnchor).isActive = true
        lableLocation.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        customView.addSubview(lableTotalPrice)
        lableTotalPrice.topAnchor.constraint(equalTo: lableLocation.bottomAnchor, constant: 4).isActive = true
        lableTotalPrice.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: 16).isActive = true
        lableTotalPrice.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lableTotalPrice.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tb.tableFooterView = containView
        
        return tb
    }()
    lazy var buttonPay: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Pay", for: UIControl.State.normal)
        bt.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        bt.layer.cornerRadius = 15
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.clipsToBounds = true
        bt.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func buttonAction(){
         if let id_table = bill?.id_table {
        let refTable = Database.database().reference().child("tables").child(id_table)
        refTable.observeSingleEvent(of: DataEventType.value) { (snapShot) in
            let table = Table(dictionary: snapShot.value as! [String : AnyObject])
            let value = ["id": (table.id)!,"name": (table.name)!, "max_numb": (table.max_numb)!,"time_stamp": 0] as [String:Any]
            let ref = Database.database().reference().child("tables").child(table.id!)
            ref.updateChildValues(value)
        }
        }
        let uid = Auth.auth().currentUser?.uid
        let value = ["id": bill!.id!, "id_cart": bill!.id_cart!, "id_table": bill!.id_table!,"totalPrice": bill!.totalPrice!,"active": 0] as [String : Any]
        let refUserBill = Database.database().reference().child("user_bills").child(uid!).child(bill!.id!)
        refUserBill.updateChildValues(value)
        
      //  historyController?.fetchBill()
        let paymentCompletedController = PaymentCompleteController()
        self.navigationController?.pushViewController(paymentCompletedController, animated: true)
    }
    func setUpView(){
        view.addSubview(lableChiTiet)
        lableChiTiet.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        lableChiTiet.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lableChiTiet.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        lableChiTiet.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: lableChiTiet.bottomAnchor, constant: 8).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        view.addSubview(buttonPay)
        buttonPay.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        buttonPay.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70).isActive = true
        buttonPay.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
        buttonPay.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpView()
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
