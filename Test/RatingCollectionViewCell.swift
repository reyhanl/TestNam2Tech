//
//  RatingCollectionViewCell.swift
//  Test
//
//  Created by reyhan muhammad on 10/05/23.
//

import UIKit

class RatingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var rating: Rating?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func setupCell(rating: Rating){
        profileImageView.setImage(urlString: rating.user?.profileImage)
        usernameLabel.text = rating.user?.name
        reviewLabel.text = rating.text
        guard let ratingValue = rating.rating else{return}
        print(ratingValue)
        ratingLabel.text = ""
        for i in 1...5{
            if i <= ratingValue{
                ratingLabel.text = (ratingLabel.text ?? "") + "★"
            }else{
                ratingLabel.text = (ratingLabel.text ?? "") + "☆"
            }
        }
    }

}

