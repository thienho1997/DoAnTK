//
//  OrderDetailController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/17/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit
import DLRadioButton
class OrderDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let cellId = "cellId"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TableCell
        cell.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
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
    func setUpView(){
        let heightStatusB = UIApplication.shared.statusBarFrame.height
        //let heightNavi = (self.navigationController?.navigationBar.frame.height)!
        view.addSubview(labelOderType)
        labelOderType.topAnchor.constraint(equalTo: view.topAnchor, constant: heightStatusB+16).isActive = true
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
    }
    @objc func btDeliveryAction(){
      radioButton2.isSelected = false
    }
    @objc func btReservationAction(){
        radioButton1.isSelected = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
         setUpView()
        // Do any additional setup after loading the view.
    }
    

   

}
class TableCell: UICollectionViewCell {
    func setUpView(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
