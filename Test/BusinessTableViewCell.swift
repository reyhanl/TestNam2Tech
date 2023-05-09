//
//  BusinessTableViewCell.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(business: BusinessModel){
        nameLabel.text = business.name ?? ""
        setImage(urlString: business.imageUrl)
    }
    
    func setImage(urlString: String?){
        guard let urlString = urlString, let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else{return}
            DispatchQueue.main.async {
                self.businessImageView.image = image
            }
        }.resume()
    }
    
}
