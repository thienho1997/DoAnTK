//
//  OrderDetailController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/17/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import DLRadioButton
import Firebase
class OrderDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    let cellTableId = "celltableid"
    var adrresses = [Adrress]()
    var tables = [Table]()
    var products = [Product]()
    var totalPrice: String?
    func fetchTables(){
        let ref = Database.database().reference().child("tables")
        ref.observe(DataEventType.childAdded) { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let table = Table(dictionary: dictionary)
                self.tables.append(table)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func fetchAdrress() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user_addrresses").child(uid!)
        ref.observe(DataEventType.childAdded) { (snap) in
            let addressId = snap.key
            
            let refAd = Database.database().reference().child("addrresses").child(addressId)
            refAd.observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                if let dictionary = snapShot.value as? [String: AnyObject]{
                    let address = Adrress(dictionary: dictionary)
                    print(address.name)
                    self.adrresses.append(address)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adrresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableId, for: indexPath) as! AddressCell
        cell.address = adrresses[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn chọn địa chỉ này không", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Huỷ", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        let agreeAction = UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let timestamp = Int(Date().timeIntervalSince1970)
            
            // update carts
            let refCarts = Database.database().reference().child("carts").childByAutoId()
            for item in self.products {
                let value = [item.id : item.numb!]
                refCarts.updateChildValues(value)
            }
            
            // update user bills
            let address = self.adrresses[indexPath.row]
            let uid = Auth.auth().currentUser?.uid
            let refUserBills = Database.database().reference().child("user_bills").child(uid!).childByAutoId()
            let valueBill = ["id": refUserBills.key! , "id_cart": refCarts.key! , "active": 1,"totalPrice": self.totalPrice!, "id_address":address.id!,"time_stamp": timestamp ] as [String: Any]
            refUserBills.updateChildValues(valueBill)
            
            // remove user_cart
            let refUserCart = Database.database().reference().child("users_cart")
            refUserCart.removeValue()
            self.navigationController?.popToRootViewController(animated: true)
        })
        alertController.addAction(agreeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(85)
    }
    
    let cellId = "cellId"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tables.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if tables[indexPath.item].time_stamp == 0
        {
        let table_name = tables[indexPath.item].name!
         let alertController = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn chọn bàn \(table_name) với giỏ hàng đã chọn không?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Huỷ", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        let agreeAction = UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.default, handler: { alert -> Void in
             let timestamp = Int(Date().timeIntervalSince1970)
            let table = self.tables[indexPath.item]
            let value = ["id": (table.id)!,"name": (table.name)!, "max_numb": (table.max_numb)!,"time_stamp": timestamp] as [String:Any]
            let ref = Database.database().reference().child("tables").child(table.id!)
            ref.updateChildValues(value)
            
            // update carts
            let refCarts = Database.database().reference().child("carts").childByAutoId()
            for item in self.products {
            let value = [item.id : item.numb!]
            refCarts.updateChildValues(value)
            }
            
            // update user bills
            let uid = Auth.auth().currentUser?.uid
            let refUserBills = Database.database().reference().child("user_bills").child(uid!).childByAutoId()
            let valueBill = ["id": refUserBills.key! , "id_cart": refCarts.key! , "id_table": table.id!, "active": 1,"totalPrice": self.totalPrice!] as [String: Any]
            refUserBills.updateChildValues(valueBill)
            
            // remove user_cart
            let refUserCart = Database.database().reference().child("users_cart")
            refUserCart.removeValue()
            self.navigationController?.popToRootViewController(animated: true)
        })
            
        alertController.addAction(agreeAction)
        alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Thông báo", message: "Bàn đã được dùng, vui lòng chọn bàn khác!", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "Đồng ý", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TableCell
         cell.table = tables[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.view.frame.width - 20) / 3 ) - 7
        let size = CGSize(width: width, height: 100)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return inset
    }
    let labelOderType: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Order type"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return lb
    }()
    let separatedLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return v
    }()
    let radioButton1: DLRadioButton = {
        let bt = DLRadioButton(type: UIButton.ButtonType.custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.iconColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        bt.indicatorColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.iconSize = CGFloat(20)
        bt.iconStrokeWidth = 0.5
       // bt.isSelected = true
        bt.addTarget(self, action: #selector(btDeliveryAction), for: UIControl.Event.touchUpInside)
        //    bt.indicatorSize = CGFloat(50)
        return bt
    }()
    let labelDelivery: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Delivery"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    let radioButton2: DLRadioButton = {
        let bt = DLRadioButton(type: UIButton.ButtonType.custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.iconColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        bt.indicatorColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.iconSize = CGFloat(20)
        bt.iconStrokeWidth = 0.5
        // bt.isSelected = true
        bt.addTarget(self, action: #selector(btReservationAction), for: UIControl.Event.touchUpInside)
        //    bt.indicatorSize = CGFloat(50)
        return bt
    }()
    let labelReservation: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Reservation"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    lazy var collectionView: UICollectionView = {
        let lo = UICollectionViewFlowLayout()
        lo.minimumInteritemSpacing = 5
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: lo)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cv.register(TableCell.self, forCellWithReuseIdentifier: cellId)
        return cv;
    }()
    lazy var buttonADress: UIButton = {
        
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: UIControl.State.normal)
        button.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("+Add new address", for: .normal)
       // button.addTarget(self, action: #selector(addNewAddress), for: .touchUpInside)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewAddress)))
        return button
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(AddressCell.self, forCellReuseIdentifier: cellTableId)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        //footer
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let customView = UIView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
        containView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containView.addSubview(customView)
        containView.isUserInteractionEnabled = true
        customView.isUserInteractionEnabled = true
        // customView.backgroundColor = #colorLiteral(red: 0.9144216313, green: 0.9144216313, blue: 0.9144216313, alpha: 1)
        
        
        
        customView.addSubview(buttonADress)
        buttonADress.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        buttonADress.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        buttonADress.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonADress.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        tb.tableFooterView = containView
        
        return tb
    }()
   @objc func addNewAddress(){
    let alertController = UIAlertController(title: "Add New Adrress", message: "", preferredStyle: UIAlertController.Style.alert)
    alertController.addTextField { (textField : UITextField!) -> Void in
        textField.placeholder = "Enter name"
    }
    let saveAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { alert -> Void in
        
        let name = alertController.textFields![0] as UITextField
        let address = alertController.textFields![1] as UITextField
        let phoneNumber = alertController.textFields![2] as UITextField
        
        let ref = Database.database().reference().child("addrresses").childByAutoId()
        let value = ["name":name.text!,"address": address.text!, "phone_number": phoneNumber.text,"id":ref.key!] as [String : Any]
        ref.updateChildValues(value, withCompletionBlock: { (error, dataRef) in
            if (error != nil){
                print(error!)
            }
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("user_addrresses").child(uid!).child(dataRef.key!)
            ref.setValue(1)
            
        })
        
        
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
        (action : UIAlertAction!) -> Void in })
    alertController.addTextField { (textField : UITextField!) -> Void in
        textField.placeholder = "Enter address"
    }
    alertController.addTextField { (textField : UITextField!) -> Void in
        textField.placeholder = "Enter phone number"
    }
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
    }
    func setUpView(){
       // let heightStatusB = UIApplication.shared.statusBarFrame.height
        //let heightNavi = (self.navigationController?.navigationBar.frame.height)!
        view.addSubview(labelOderType)
        labelOderType.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        labelOderType.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        labelOderType.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelOderType.widthAnchor.constraint(equalToConstant:200).isActive = true
        
        view.addSubview(separatedLine)
        separatedLine.topAnchor.constraint(equalTo: labelOderType.bottomAnchor, constant: 5).isActive = true
        separatedLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatedLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separatedLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        view.addSubview(radioButton1)
        radioButton1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        radioButton1.topAnchor.constraint(equalTo: separatedLine.bottomAnchor, constant: 16).isActive = true
        radioButton1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        radioButton1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(labelDelivery)
        labelDelivery.leftAnchor.constraint(equalTo: radioButton1.rightAnchor, constant: 4).isActive = true
        labelDelivery.centerYAnchor.constraint(equalTo: radioButton1.centerYAnchor).isActive = true
        labelDelivery.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelDelivery.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(radioButton2)
        radioButton2.leftAnchor.constraint(equalTo: labelDelivery.rightAnchor, constant: 16).isActive = true
        radioButton2.topAnchor.constraint(equalTo: separatedLine.bottomAnchor, constant: 16).isActive = true
        radioButton2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        radioButton2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(labelReservation)
        labelReservation.leftAnchor.constraint(equalTo: radioButton2.rightAnchor, constant: 4).isActive = true
        labelReservation.centerYAnchor.constraint(equalTo: radioButton2.centerYAnchor).isActive = true
        labelReservation.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelReservation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: labelReservation.bottomAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: labelReservation.bottomAnchor,constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
    @objc func btDeliveryAction(){
      radioButton2.isSelected = false
        radioButton1.isSelected = true
      tableView.isHidden = false
        collectionView.isHidden = true
    }
    @objc func btReservationAction(){
        radioButton1.isSelected = false
        tableView.isHidden = true
        collectionView.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Order Detail"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        btDeliveryAction()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
         setUpView()
        fetchAdrress()
        fetchTables()
        // Do any additional setup after loading the view.
    }
    

   

}
class TableCell: UICollectionViewCell {
    var table:Table?{
        didSet{
            if table?.time_stamp == 0 {
                backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                labelTime.text = "Available"
            }
            else{
                if let seconds = table?.time_stamp?.doubleValue {
                    let secondDistance = Int(Date().timeIntervalSince1970) - Int(seconds)
                let (h,m,s) = secondsToHoursMinutesSeconds (seconds : secondDistance)
                   if h != 0 {
                    labelTime.text = "\(h) hours \(m) minutes \(s) seconds"
                    }
                    else if m != 0 {
                     labelTime.text = "\(m) minutes \(s) seconds"
                    }
                    else{
                    labelTime.text = "\(s) seconds"
                    }
                }
                
            }
            labelName.text = table?.name
            labelMaxNumb.text = "Max people: \((table?.max_numb)!)"
        }
    }
    let labelName: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return lb
    }()
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    let labelMaxNumb: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 14)
         lb.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return lb
    }()
    let labelTime : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return lb
    }()
    func setUpView(){
        self.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        addSubview(labelName)
        labelName.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        labelName.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        labelName.heightAnchor.constraint(equalToConstant: 16).isActive = true
        labelName.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(labelMaxNumb)
        labelMaxNumb.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4).isActive = true
        labelMaxNumb.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        labelMaxNumb.heightAnchor.constraint(equalToConstant: 16).isActive = true
        labelMaxNumb.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(labelTime)
        labelTime.topAnchor.constraint(equalTo: labelMaxNumb.bottomAnchor, constant: 4).isActive = true
        labelTime.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        labelTime.heightAnchor.constraint(equalToConstant: 16).isActive = true
        labelTime.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


