//
//  HistoryController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/23/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import Firebase
class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var billsAction = [Bill]()
    var billsFinish = [Bill]()
    let cellId = "cellId"
    let cellFin = "cellFin"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewAction {
            return billsAction.count
        }
        else {
            return billsFinish.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewFinish {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellFin, for: indexPath) as! HistoryCell
            cell.bill = billsFinish[indexPath.item]
            return cell
        }
       else {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryCell
        cell.bill = billsAction[indexPath.item]
        return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewAction {
            let bill = billsAction[indexPath.row]
            let billDetailController = BillDetailController()
            billDetailController.bill = bill
            billDetailController.historyController = self
            self.navigationController?.pushViewController(billDetailController, animated: true)
        }
        else {
            let bill = billsFinish[indexPath.row]
            let billDetailController = BillDetailController()
            billDetailController.bill = bill
             billDetailController.historyController = self
            self.navigationController?.pushViewController(billDetailController, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    func fetchBill(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user_bills").child(uid!)
        ref.observe(DataEventType.childAdded) { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let bill = Bill(dictionary: dictionary)
                if bill.active! == 1 {
                    self.billsAction.append(bill)
                    DispatchQueue.main.async {
                        self.tableViewAction.reloadData()
                    }
                }
                else{
                    self.billsFinish.append(bill)
                     DispatchQueue.main.async {
                    self.tableViewFinish.reloadData()
                    }
                }
                
            }
        }
        ref.observe(DataEventType.childChanged) { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let bill = Bill(dictionary: dictionary)
                for i in 0 ..< self.billsAction.count {
                    if bill.id == self.billsAction[i].id {
                        self.billsFinish.append(self.billsAction[i])
                        self.billsAction.remove(at: i)
                    }
                }
                self.tableViewAction.reloadData()
                self.tableViewFinish.reloadData()
            }
        }
    }
    lazy var loginRegisterSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Action","Finish"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterSegmentControl), for: UIControl.Event.valueChanged)
        return sc
    }()
    @objc func handleLoginRegisterSegmentControl(){
       if loginRegisterSegmentControl.selectedSegmentIndex == 0 {
        self.tableViewAction.isHidden = false
        self.tableViewFinish.isHidden = true
        }
        else{
        self.tableViewAction.isHidden = true
        self.tableViewFinish.isHidden = false
        }
    }
    lazy var tableViewAction: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(HistoryCell.self, forCellReuseIdentifier: cellId)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        return tb
    }()
    lazy var tableViewFinish: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(HistoryCell.self, forCellReuseIdentifier: cellFin)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return tb
    }()
    func setUpView(){
       // let heightStatusB = UIApplication.shared.statusBarFrame.height
       // let heightNavi = (self.navigationController?.navigationBar.frame.height)!
        // need x,y,width,height
        self.view.addSubview(loginRegisterSegmentControl)
        loginRegisterSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        loginRegisterSegmentControl.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        loginRegisterSegmentControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(tableViewAction)
        tableViewAction.topAnchor.constraint(equalTo: loginRegisterSegmentControl.bottomAnchor, constant: 16).isActive = true
        tableViewAction.leftAnchor.constraint(equalTo: loginRegisterSegmentControl.leftAnchor).isActive = true
        tableViewAction.rightAnchor.constraint(equalTo: loginRegisterSegmentControl.rightAnchor).isActive = true
        tableViewAction.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view.addSubview(tableViewFinish)
        tableViewFinish.topAnchor.constraint(equalTo: loginRegisterSegmentControl.bottomAnchor, constant: 16).isActive = true
        tableViewFinish.leftAnchor.constraint(equalTo: loginRegisterSegmentControl.leftAnchor).isActive = true
        tableViewFinish.rightAnchor.constraint(equalTo: loginRegisterSegmentControl.rightAnchor).isActive = true
        tableViewFinish.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewFinish.isHidden = true
        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.navigationItem.title = "Orders"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 23)] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        setUpView()
        fetchBill()
        // Do any additional setup after loading the view.
    }
    

   

}
class HistoryCell: UITableViewCell {
    var bill: Bill?{
        didSet{
            if let id_table = bill?.id_table {
                imageViewLocation.image = #imageLiteral(resourceName: "shop")
                let refTable = Database.database().reference().child("tables").child(id_table)
                refTable.observeSingleEvent(of: DataEventType.value) { (snapShot) in
                    let table = Table(dictionary: snapShot.value as! [String : AnyObject])
                    self.lableLocation.text = table.name
                    
                    if let seconds = table.time_stamp?.doubleValue {
                        let date = Date(timeIntervalSince1970: seconds)
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss a"
                        self.lableTime.text = dateFormater.string(from: date)
                    }
                   
                }
            }
            else {
                
                imageViewLocation.image = #imageLiteral(resourceName: "scooter")
                if let seconds = bill!.time_stamp?.doubleValue {
                    let date = Date(timeIntervalSince1970: seconds)
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss a"
                    self.lableTime.text = dateFormater.string(from: date)
                }
                let refAdress = Database.database().reference().child("addrresses").child((bill?.id_address)!)
                refAdress.observeSingleEvent(of: DataEventType.value) { (snapShot) in
                     let address = Adrress(dictionary: snapShot.value as! [String : AnyObject])
                    self.lableLocation.text = address.adrress
                }
                
            }
            self.lableTotalPrice.text = bill?.totalPrice
        }
    }
    let lableLocation: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    let lableTotalPrice: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    let lableTime: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    let imageViewLocation: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    func setUpView(){
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(imageViewLocation)
        imageViewLocation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageViewLocation.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        imageViewLocation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageViewLocation.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(lableTotalPrice)
        lableTotalPrice.centerYAnchor.constraint(equalTo: imageViewLocation.centerYAnchor).isActive = true
        lableTotalPrice.leftAnchor.constraint(equalTo: imageViewLocation.rightAnchor, constant: 16).isActive = true
        lableTotalPrice.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lableTotalPrice.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(lableLocation)
        lableLocation.leftAnchor.constraint(equalTo: imageViewLocation.rightAnchor, constant: 16).isActive = true
        lableLocation.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lableLocation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lableLocation.bottomAnchor.constraint(equalTo: lableTotalPrice.topAnchor, constant: -2).isActive = true
        
        addSubview(lableTime)
        lableTime.leftAnchor.constraint(equalTo: imageViewLocation.rightAnchor, constant: 16).isActive = true
        lableTime.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lableTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lableTime.topAnchor.constraint(equalTo: lableTotalPrice.bottomAnchor, constant: 2).isActive = true
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
