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
    
    var session: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        businessImageView.layer.cornerRadius = businessImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        session?.cancel()
        session = nil
        businessImageView.image = nil
    }
    
    func setupCell(business: BusinessModel){
        nameLabel.text = business.name ?? ""
        setImage(urlString: business.imageUrl)
    }
    
    func setImage(urlString: String?){
        guard let urlString = urlString, let url = URL(string: urlString) else{return}
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = CacheManager.loadData(key: urlString), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.businessImageView.image = image
                }
                return
            }
            self.session = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else{return}
                CacheManager.saveData(key: urlString, data: data)
                DispatchQueue.main.async {
                    self.businessImageView.image = image
                }
            }
            self.session?.resume()
        }
    }
    
}
