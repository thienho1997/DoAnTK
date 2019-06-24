//
//  PaymentCompleteController.swift
//  AudioProject
//
//  Created by HoThienHo on 6/23/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit

class PaymentCompleteController: UIViewController {
    
    let viewMain: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        iv.image = #imageLiteral(resourceName: "completed-task")
        return iv
    }()
    let labelComplete: UILabel = {
        let lb = UILabel()
        lb.text = "Payment completed"
        lb.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let labelThank: UILabel = {
        let lb = UILabel()
        lb.text = "Thank you"
        lb.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    lazy var buttonOrder: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Your Order", for: UIControl.State.normal)
        bt.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        bt.layer.cornerRadius = 15
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.clipsToBounds = true
        bt.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        bt.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        return bt
    }()
    @objc func buttonAction(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    func setUpView(){
        self.view.addSubview(viewMain)
        viewMain.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewMain.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        viewMain.heightAnchor.constraint(equalToConstant: 200).isActive = true
        viewMain.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        viewMain.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: viewMain.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: viewMain.topAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        viewMain.addSubview(labelComplete)
        labelComplete.centerXAnchor.constraint(equalTo: viewMain.centerXAnchor).isActive = true
        labelComplete.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12).isActive = true
        labelComplete.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelComplete.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        viewMain.addSubview(labelThank)
        labelThank.centerXAnchor.constraint(equalTo: viewMain.centerXAnchor).isActive = true
        labelThank.topAnchor.constraint(equalTo: labelComplete.bottomAnchor, constant: 4).isActive = true
        labelThank.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelThank.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(buttonOrder)
        buttonOrder.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        buttonOrder.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70).isActive = true
        buttonOrder.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
        buttonOrder.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.navigationItem.setHidesBackButton(true, animated: true)
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
