//
//  FilterCollectionViewCell.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sortImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var filter: Filter?
    var delegate: FilterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupCell(filter: Filter, isActive: Bool){
        label.text = filter.displayValue
        switch filter{
        case .distanceAscending(let isAscending):
            sortImageView.isHidden = false
            print("filter: \(filter) \(isAscending)")
            sortImageView.image = isAscending ? UIImage(systemName: "arrow.up"):.init(systemName: "arrow.down")
        default:
            sortImageView.isHidden = true
        }
        self.filter = filter
        setActiveStatus(isActive)
    }
    
    func setupUI(){
        sortImageView.addGestureRecognizer(target: self, selector: #selector(changeSort))
        addGestureRecognizer(target: self, selector: #selector(shouldExecuteFilter))
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    func setActiveStatus(_ isActive: Bool){
        backgroundColor = isActive ? .blue:.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        label.textColor = isActive ? .white:.black
    }
    
    @objc func changeSort(){
        guard let filter = filter else{return}
        switch filter{
        case .distanceAscending(_):
            delegate?.changeSort(filter: filter)
        default:
            break
        }
    }
    
    @objc func shouldExecuteFilter(){
        guard let filter = filter else{return}
        delegate?.shouldExecuteFilter(filter: filter)
    }
}

protocol FilterCollectionViewCellDelegate{
    func changeSort(filter: Filter)
    func shouldExecuteFilter(filter: Filter)
}
