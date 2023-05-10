//
//  UIImageViewExtension.swift
//  Test
//
//  Created by reyhan muhammad on 10/05/23.
//

import UIKit

extension UIImageView{
    func setImage(urlString: String?){
        guard let urlString = urlString, let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else{return}
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
