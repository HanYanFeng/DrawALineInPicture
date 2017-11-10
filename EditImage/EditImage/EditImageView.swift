//
//  EditImageView.swift
//  EditImage
//
//  Created by 韩艳锋 on 2017/11/10.
//  Copyright © 2017年 韩艳锋. All rights reserved.
//

import UIKit
import Photos

class EditImageView: UIView {

    let image :  UIImage
    let imageView = UIImageView()
    var drawingBoard : DrawingBoard!
    init(_ imagee:UIImage) {
        image = imagee
        let width = UIScreen.main.bounds.width
        let heigh = width / image.size.width * image.size.height
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: heigh))
        imageView.frame = self.bounds
        imageView.image = image
        self.addSubview(imageView)
        self.backgroundColor = UIColor.white
        drawingBoard = DrawingBoard(frame: self.bounds)
        self.addSubview(drawingBoard)
    }
 
    func 撤销() {
        drawingBoard.撤销()
    }
    func 保存(){
        UIGraphicsBeginImageContext(image.size)

//        let cgcontext = UIGraphicsGetCurrentContext()
//        cgcontext?.draw(image.cgImage!, in: )
        image.drawAsPattern(in: CGRect(origin: CGPoint.zero, size:image.size))
        
        for path in drawingBoard.pathArr {
            UIColor.red.set()
            let ppp = path
            let scale = image.size.width / self.frame.size.width
            let transform = CGAffineTransform(scaleX: scale, y: scale)
//            transform = transform.scaledBy(x: scale, y: scale)
            ppp.apply(transform)
            ppp.stroke()
        }
//        cgcontext?.scaleBy(x: scale, y: scale)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            PHPhotoLibrary.shared().performChanges({
                _ = PHAssetChangeRequest.creationRequestForAsset(from: newImage)
            }, completionHandler: { (succed, error) in
                print("\(succed) __  \(String(describing: error))")
            })
        }else{
            PHPhotoLibrary.requestAuthorization { (staticc) in
                print("\(staticc)")
                switch staticc {
                case .authorized:
                    print("authorized")
                    PHPhotoLibrary.shared().performChanges({
                        _ = PHAssetChangeRequest.creationRequestForAsset(from: newImage)
                    }, completionHandler: { (succed, error) in
                        print("\(succed) __  \(String(describing: error))")
                    })
                case .notDetermined:
                    print("notDetermined")
                case .restricted:
                    print("restricted")
                case .denied:
                    print("denied")
                }
            }
        }
        
        
    }
    @objc func completionSave(sender:AnyObject)  {
        print(sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import UIKit

class DrawingBoard: UIView {
    var 颜色 = UIColor.red
    var 线宽 : CGFloat = 4
    var pathArr : [UIBezierPath] = []
    var _path : UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        for path in pathArr {
            颜色.set()
            path.stroke()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoard.action(sender:)))
        self.addGestureRecognizer(pan)
        self.backgroundColor = UIColor.clear
    }
    
    @objc func action(sender:UIPanGestureRecognizer) {
        let curPoint = sender.location(in: self)
        if sender.state == .began {
            _path = UIBezierPath()
            _path?.move(to: curPoint)
            _path?.lineWidth = 线宽
            self.pathArr.append(_path!)
        }else{
            _path?.addLine(to: curPoint)
        }
        self.setNeedsDisplay()
    }
    func 撤销() {
        if !self.pathArr.isEmpty {
            self.pathArr.removeLast()
            self.setNeedsDisplay()
        }
    }
    func 清空() {
        self.pathArr.removeAll()
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
