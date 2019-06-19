//
//  PageCell.swift
//  AudioProject
//
//  Created by HoThienHo on 5/8/19.
//  Copyright © 2019 hothienho. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var Page: Page? {
        didSet{
            guard let Page = Page else {
                return
            }
            if let image = Page.image {
                imageView.image = image
            }
            if let title = Page.title , let message = Page.message  {
                
                
                let atributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)])
                atributedText.append(NSAttributedString(string: "\n\n\(message)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                atributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: atributedText.string.count))
            
                textView.attributedText = atributedText
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "josh-edgoose-1569812-unsplash")
        return iv
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        return tv
    }()
    let lineSeparater: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func setUpView(){
        
        self.addSubview(imageView)
        self.addSubview(textView)
        self.addSubview(lineSeparater)
        
        //needs x,y,w,h
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //needs x,y,w,h
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.27).isActive = true
        
        //needs x,y,w,h
        lineSeparater.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        lineSeparater.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        lineSeparater.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        lineSeparater.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
