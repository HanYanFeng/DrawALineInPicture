//
//  ViewController.swift
//  EditImage
//
//  Created by 韩艳锋 on 2017/11/10.
//  Copyright © 2017年 韩艳锋. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var editImageView : EditImageView!
    var scrollView : UIScrollView = UIScrollView()
    var swich = UISwitch()
    override func viewDidLoad() {
        super.viewDidLoad()
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(ViewController.save))
        let undo = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(ViewController.undo))
        self.navigationItem.rightBarButtonItems = [undo,save]
    
        editImageView = EditImageView(UIImage(named:"pdfImageii")!)
        scrollView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.size.height - 64)
        scrollView.contentSize = editImageView.frame.size
        scrollView.addSubview(editImageView)
        self.view.addSubview(scrollView)
        
        self.navigationItem.titleView = swich
        editImageView.isUserInteractionEnabled = false
        swich.addTarget(self, action: #selector(swich(sender:)), for: .valueChanged)
    }
    @objc func save(){
        editImageView.保存()
    }
    @objc func undo(){
        editImageView.撤销()
    }
    @objc func swich(sender:UISwitch){
        editImageView.isUserInteractionEnabled = sender.isOn
    }
}

