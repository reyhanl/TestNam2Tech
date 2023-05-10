//
//  UIViewExtension.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

extension UIView{
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }

    func addGestureRecognizer(target: Any, selector: Selector){
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
    }
    
    func addShadowAndCornerRadius(cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
