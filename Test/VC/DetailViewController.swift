//
//  DetailViewController.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imagesCarouselCollectionView: UICollectionView!
    @IBOutlet weak var ratingCollectionView: UICollectionView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var appleMapActionView: UIView!
    @IBOutlet weak var googleMapActionLabel: UILabel!
    @IBOutlet weak var backButton: UIView!
    
    private var id: String?
    private var businessModel: BusinessModel?{
        didSet{
            updateData()
        }
    }
    private var ratings: [Rating]?{
        didSet{
            updateRatingCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapKit()
        setCollectionView()
        let id = id ?? ""
        fetchData(id: id)
        fetchRating(id: id)
        setupImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupUI(id: String){
        self.id = id
    }
    
    private func setupImageView(){
        businessImageView.layer.cornerRadius = 20
    }
    
    private func setupMapKit(){
        googleMapActionLabel.addGestureRecognizer(target: self, selector: #selector(openOnGoogleMaps))
        appleMapActionView.addGestureRecognizer(target: self, selector: #selector(openOnGoogleMaps))
        backButton.addGestureRecognizer(target: self, selector: #selector(back))
        backButton.subviews.map({$0.addGestureRecognizer(target: self, selector: #selector(back))})
    }
    
    private func setCollectionView(){
        imagesCarouselCollectionView.dataSource = self
        imagesCarouselCollectionView.delegate = self
        imagesCarouselCollectionView.decelerationRate = .fast
        
        ratingCollectionView.dataSource = self
        ratingCollectionView.delegate = self
        
        let ImageCarouselCell = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        imagesCarouselCollectionView.register(ImageCarouselCell, forCellWithReuseIdentifier: "cell")
        
        let ratingCell = UINib(nibName: "RatingCollectionViewCell", bundle: nil)
        ratingCollectionView.register(ratingCell, forCellWithReuseIdentifier: "cell")
    }
    
    private func fetchData(id: String){
        NetworkManager.shared.fetchBusinessDetail(id: id) { result in
            switch result {
            case .success(let model):
                self.businessModel = model
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func fetchRating(id: String){
        NetworkManager.shared.fetchBusinessRating(id: id, completion: { result in
            switch result{
            case .success(let response):
                self.ratings = response.reviews
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func updateData(){
        guard let businessModel = businessModel else{return}
        DispatchQueue.main.async {
            self.imagesCarouselCollectionView.reloadData()
            self.titleLabel.text = businessModel.name ?? ""
            self.ratingLabel.text = "★ \(businessModel.rating ?? 0)"
            self.setMapKit(long: businessModel.coordinates?.longitude, lat: businessModel.coordinates?.latitude)
            self.businessImageView.setImage(urlString: businessModel.imageUrl)
        }
    }
    
    private func setMapKit(long: Float?, lat: Float?){
        guard let long = long, let lat = lat else{return}
        mapKit.centerCoordinate = .init(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        mapKit.cameraZoomRange = MKMapView.CameraZoomRange.init(maxCenterCoordinateDistance: 100)
        mapKit.layer.cornerRadius = 10
        mapKit.isScrollEnabled = false
        mapKit.isHidden = false
        mapKit.isUserInteractionEnabled = false
        googleMapActionLabel.isHidden = false
    }
    
    private func scrollToNearestCell(){
        //Since the image/cell take up the entire width of the screen, we can assume that at any given point, there will only be two image being displayed at the same time.
        //Then, we can just get all the IndexPath for the visible cell, and see its Global position to determine which image to scroll to (based on which one is bigger)
        guard let collectionView = imagesCarouselCollectionView, let index = collectionView.indexPathsForVisibleItems.sorted().last, let firstIndex = collectionView.indexPathsForVisibleItems.sorted().first else{return}
        //We use global position to make sure that the origin.x is going to be based on the entire screen, instead of its superview
        if let cell = collectionView.cellForItem(at: index), let globalFrame = cell.globalFrame{
            if globalFrame.origin.x < view.frame.width / 2{
                collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }else{
                collectionView.scrollToItem(at: firstIndex, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    private func updateRatingCollectionView(){
        DispatchQueue.main.async {
            self.ratingCollectionView.reloadData()
        }
    }
    
    @objc private func openOnGoogleMaps(){
        guard
            let long = businessModel?.coordinates?.longitude,
            let lat = businessModel?.coordinates?.latitude,
            let url = URL(string: "comgooglemaps://?center=\(lat),\(long)&zoom=14&views=traffic&q=\(lat),\(long)"),
            let googleUrl = URL(string: "comgooglemaps://") else{return}
        if UIApplication.shared.canOpenURL(googleUrl){
            UIApplication.shared.open(url)
        }else{
            presentToastAlert(text: "It seems that Google Maps is not available in your phone")
        }
    }
    
    @objc private func back(){
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.imagesCarouselCollectionView{
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
        if collectionView === self.imagesCarouselCollectionView{
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
        if collectionView === self.imagesCarouselCollectionView{
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
