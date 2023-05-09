//
//  DetailViewController.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var id: String?
    var businessModel: BusinessModel?{
        didSet{
            updateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        fetchData(id: id ?? "")
    }
    
    func setupUI(id: String){
        self.id = id
    }
    
    func setCollectionView(){
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    func fetchData(id: String){
        NetworkManager.shared.fetchBusinessDetail(id: id) { result in
            switch result {
            case .success(let model):
                self.businessModel = model
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func updateData(){
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
        }
    }
    
    func scrollToNearestCell(){
        guard let collectionView = imagesCollectionView, let index = collectionView.indexPathsForVisibleItems.sorted().last, let firstIndex = collectionView.indexPathsForVisibleItems.sorted().first else{return}
        if let cell = collectionView.cellForItem(at: index), let globalFrame = cell.globalFrame{
            if globalFrame.origin.x < view.frame.width / 2{
                collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }else{
                collectionView.scrollToItem(at: firstIndex, at: .centeredHorizontally, animated: true)
            }
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let businessModel = businessModel, let photos = businessModel.photos{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
            cell.setupCell(urlString: photos[indexPath.row])
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let businessModel = businessModel, let photos = businessModel.photos else{return 0}
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollToNearestCell()
    }
}
