//
//  ViewController.swift
//  adl
//
//  Created by Jack Sheridan on 2/6/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension UIView {

    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
           get {
               return layer.borderWidth
           }
           set {
               layer.borderWidth = newValue
           }
       }

       @IBInspectable var borderColorV: UIColor? {
           get {
               return UIColor(cgColor: layer.borderColor!)
           }
           set {
               layer.borderColor = newValue?.cgColor
           }
       }

}

