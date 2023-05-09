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
}
