//
//  ViewController.swift
//  AudioProject
//
//  Created by HoThienHo on 5/8/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let pages:[Page] = {
        let firstPage = Page(title: "Hệ thống thông minh", message: "Thưởng thức món ăn và thức uống một cách trọn vẹn", image: #imageLiteral(resourceName: "photo-1476718406336-bb5a9690ee2a"))
        let secondPage = Page(title: "Mua thức uống tại cửa hàng bằng điện thoại", message: "Đơn giản quá trình chọn món, giảm đi sự nhầm lẫn", image: #imageLiteral(resourceName: "photo-1543362906-acfc16c67564"))
        let thirdPage = Page(title: "Thức uống tới nhà chỉ sau một lần kích", message: "Bạn vẫn có thể thưởng thức cuộc sống dù có bận rộn", image: #imageLiteral(resourceName: "photo-1478145046317-39f10e56b5e9"))
        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        pc.numberOfPages = pages.count + 1
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    lazy var nextButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("Next", for: UIControl.State.normal)
        bt.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(nextPage), for: UIControl.Event.touchUpInside)
        bt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bt.layer.cornerRadius = 10
        bt.clipsToBounds = true
        return bt
    }()
    @objc func nextPage(){
        if pageControl.currentPage == pages.count {
            return
        }
        if pageControl.currentPage == pages.count - 1{
            pageControlBottomAnchor?.constant = 60
            skipButtonLeftAnchor?.constant = -50
            nextButtonRightAnchor?.constant = 50
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        let item = pageControl.currentPage + 1
        let indexPath = IndexPath(item: item, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    lazy var skipButton: UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("Skip", for: UIControl.State.normal)
        bt.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(skipPage), for: UIControl.Event.touchUpInside)
        bt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bt.layer.cornerRadius = 10
        bt.clipsToBounds = true
        return bt
    }()
    @objc func skipPage(){
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    let cellId = "cellID"
    let loginId = "loginID"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginId, for: indexPath) as! LoginPage
            loginCell.viewController = self
            return loginCell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        let page = pages[indexPath.row]
        cell.Page = page
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        return size
    }

    lazy var collectionView: UICollectionView =  {
        let clFlowLayout = UICollectionViewFlowLayout()
        clFlowLayout.scrollDirection = .horizontal
        clFlowLayout.minimumLineSpacing = 0
        
        let clView = UICollectionView(frame: .zero, collectionViewLayout: clFlowLayout)
        clView.isPagingEnabled = true
        clView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        clView.delegate = self
        clView.dataSource = self
        clView.translatesAutoresizingMaskIntoConstraints = false
        return clView
    }()
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / self.view.frame.width)
        pageControl.currentPage = pageNumber
        if pageNumber == pages.count {
            pageControlBottomAnchor?.constant = 60
            skipButtonLeftAnchor?.constant = -50
            nextButtonRightAnchor?.constant = 50
        }
        else {
            pageControlBottomAnchor?.constant = 0
            skipButtonLeftAnchor?.constant = 8
            nextButtonRightAnchor?.constant = -8
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
   private func collectionViewRegister(){
    collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(LoginPage.self, forCellWithReuseIdentifier: loginId)
    }
    var pageControlBottomAnchor: NSLayoutConstraint?
    var nextButtonRightAnchor: NSLayoutConstraint?
    var skipButtonLeftAnchor: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionViewRegister()
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        //need x,y,w,h
        let margins = view.layoutMarginsGuide
        let haha = view.safeAreaLayoutGuide
        collectionView.leftAnchor.constraint(equalTo: haha.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: haha.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
     
        //need x,y,w,h
        pageControl.leftAnchor.constraint(equalTo: haha.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: haha.rightAnchor).isActive = true
        pageControlBottomAnchor = pageControl.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        pageControlBottomAnchor?.isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //need x,y,w,h
        nextButtonRightAnchor = nextButton.rightAnchor.constraint(equalTo: haha.rightAnchor, constant: -8)
        nextButtonRightAnchor?.isActive = true
        nextButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //need x,y,w,h
        skipButtonLeftAnchor = skipButton.leftAnchor.constraint(equalTo: haha.leftAnchor, constant: 8)
        skipButtonLeftAnchor?.isActive = true
        skipButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

