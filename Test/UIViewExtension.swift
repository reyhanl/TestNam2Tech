//
//  UIViewExtension.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

extension UIView{
    func addGestureRecognizer(target: Any, selector: Selector){
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
    }
}
