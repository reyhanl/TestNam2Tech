//
//  ImageCollectionViewCell.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(urlString: String){
        setImage(urlString: urlString)
    }
    
    func setImage(urlString: String?){
        guard let urlString = urlString, let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else{return}
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}
