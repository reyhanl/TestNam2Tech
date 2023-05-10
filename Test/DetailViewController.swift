//
//  DetailViewController.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var ratingCollectionView: UICollectionView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var appleMapActionView: UIView!
    @IBOutlet weak var googleMapActionLabel: UILabel!
    
    var id: String?
    var businessModel: BusinessModel?{
        didSet{
            updateData()
        }
    }
    var ratings: [Rating]?{
        didSet{
            updateRatingCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapKit()
        setCollectionView()
        fetchData(id: id ?? "")
        fetchRating(id: id ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupUI(id: String){
        self.id = id
    }
    
    func setupMapKit(){
        googleMapActionLabel.addGestureRecognizer(target: self, selector: #selector(openOnGoogleMaps))
        appleMapActionView.addGestureRecognizer(target: self, selector: #selector(openOnGoogleMaps))
    }
    
    func setCollectionView(){
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.decelerationRate = .fast
        
        ratingCollectionView.dataSource = self
        ratingCollectionView.delegate = self
        
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let ratingCell = UINib(nibName: "RatingCollectionViewCell", bundle: nil)
        ratingCollectionView.register(ratingCell, forCellWithReuseIdentifier: "cell")
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
    
    func fetchRating(id: String){
        NetworkManager.shared.fetchBusinessRating(id: id, completion: { result in
            switch result{
            case .success(let response):
                print(response.reviews)
                self.ratings = response.reviews
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func updateData(){
        guard let businessModel = businessModel else{return}
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
            self.titleLabel.text = businessModel.name ?? ""
            self.ratingLabel.text = "★ \(businessModel.rating ?? 0)"
            self.setMapKit(long: businessModel.coordinates?.longitude, lat: businessModel.coordinates?.latitude)
        }
    }
    
    func setMapKit(long: Float?, lat: Float?){
        guard let long = long, let lat = lat else{return}
        mapKit.centerCoordinate = .init(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        mapKit.cameraZoomRange = MKMapView.CameraZoomRange.init(maxCenterCoordinateDistance: 30)
        mapKit.layer.cornerRadius = 10
        mapKit.isScrollEnabled = false
        mapKit.isHidden = false
        mapKit.isUserInteractionEnabled = false
        googleMapActionLabel.isHidden = false
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
    
    func updateRatingCollectionView(){
        DispatchQueue.main.async {
            self.ratingCollectionView.reloadData()
        }
    }
    
    @objc func openOnGoogleMaps(){
        guard let long = businessModel?.coordinates?.longitude, let lat = businessModel?.coordinates?.latitude, let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving"), let googleUrl = URL(string: "comgooglemaps://") else{return}
        if UIApplication.shared.canOpenURL(googleUrl){
            UIApplication.shared.open(url)
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.imagesCollectionView{
            if let businessModel = businessModel, let photos = businessModel.photos{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
                cell.setupCell(urlString: photos[indexPath.row])
                return cell
            }else{
                return UICollectionViewCell()
            }
        }else{
            guard let ratings = ratings else{return UICollectionViewCell()}
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RatingCollectionViewCell
            cell.setupCell(rating: ratings[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.imagesCollectionView{
            guard let businessModel = businessModel, let photos = businessModel.photos else{return 0}
            return photos.count
        }else{
            guard let ratings = ratings else{return 0}
            return ratings.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === self.imagesCollectionView{
            return CGSize(width: view.frame.width, height: 200)
        }else{
            return CGSize(width: 200, height: 150)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollToNearestCell()
    }
}
