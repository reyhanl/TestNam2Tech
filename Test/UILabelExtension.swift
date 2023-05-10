//
//  UILabelExtension.swift
//  Test
//
//  Created by reyhan muhammad on 10/05/23.
//

import UIKit

extension UILabel{
    func createRatingText(_ rating: Int){
        for i in 1...5{
            let text = self.text ?? ""
            if i <= rating{
                self.text = text + "★"
            }else{
                self.text = text + "☆"
            }
        }
    }
}
