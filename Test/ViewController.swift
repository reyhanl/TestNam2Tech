//
//  ViewController.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollToTopButton: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var businesses: [BusinessModel] = []
    var currentPage: Int = 0
    var searchController: UISearchController?
    var filters: [Filter] = [
        .nearMe, .cheap, .quiteCheap, .expensive, .superExpensive
    ]
    var locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?{
        didSet{
            if oldValue == nil{
                fetchData()
            }
        }
    }
    var activeFilters: [Filter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCollectionView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupUI(){
        setupNavigationBar()
        setupScrollToTop()
    }
    
    func setupNavigationBar(){
        title = "Businesses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController?.searchResultsUpdater = self
    }
    
    func setupScrollToTop(){
        scrollToTopButton.backgroundColor = .blue
        scrollToTopButton.addGestureRecognizer(target: self, selector: #selector(scrollToTop))
        scrollToTopButton.layer.cornerRadius = scrollToTopButton.frame.width / 2
    }
    
    func setupCollectionView(){
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        
        let nib = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
        filterCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "BusinessTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    private func fetchData(keywordParam: String? = nil, shouldRemovePreviousData: Bool = false){
        var priceFilter: [Int]? = []
        var keyword: String? = nil
        if keywordParam == nil, let text = searchController?.searchBar.text, text != ""{
            keyword = text
        }else if keywordParam != nil{
            keyword = keywordParam
        }
        var sortBy = "best_match"
        for filter in activeFilters{
            if [Filter.cheap, .quiteCheap, .expensive, .superExpensive].contains(where: {$0.displayValue == filter.displayValue}){
                priceFilter?.append(filter.displayValue.count)
            }else{
                if filter.displayValue == Filter.nearMe.displayValue{
                    sortBy = "distance"
                }
            }
        }
        if priceFilter?.count == 0{
            priceFilter = nil
        }
        if shouldRemovePreviousData{
            currentPage = 0
        }
        let location = location
        let longitude: Float? = location?.longitude == nil ? nil:Float(location?.longitude ?? 0)
        let latitude: Float? = location?.latitude == nil ? nil:Float(location?.latitude ?? 0)
        print(longitude, latitude)
        NetworkManager.shared.fetchBusiness(model: .init(location: nil, latitude: latitude, longitude: longitude, term: keyword, price: priceFilter, sortBy: sortBy, limit: 20, offset: currentPage * 20)) { result in
            switch result{
            case .success(let model):
                self.currentPage += 1
                print("model: \(model.businesses?.count)")
                if shouldRemovePreviousData{
                    self.businesses =  model.businesses ?? []
                }else{
                    print()
                    self.businesses.append(contentsOf: model.businesses ?? [])
                }
                print(model.businesses.map({$0.first?.name}))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func sort(){
        if let filter = activeFilters.first(where: {$0.displayValue == "Distance"}){
            switch filter{
            case .distanceAscending(let isAscending):
                if isAscending{
                    businesses = businesses.sorted(by: {$0.distance ?? 0 < $1.distance ?? 0})
                }else{
                    businesses = businesses.sorted(by: {$0.distance ?? 0 > $1.distance ?? 0})
                }
            default:
                break
            }
        }
    }
    
    @objc func scrollToTop(){
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BusinessTableViewCell
        cell.setupCell(business: businesses[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var shouldDisplayScrollToTopButton = (tableView.indexPathsForVisibleRows?.contains(where: {$0.row == 0}) ?? false)
        scrollToTopButton.isHidden = shouldDisplayScrollToTopButton
        
        if indexPath.row == businesses.count - 1 && tableView.contentSize.height > tableView.frame.height{
            fetchData()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterCollectionViewCell
        let filter = filters[indexPath.row]
        cell.setupCell(filter: filter, isActive: activeFilters.contains(where: {$0.displayValue == filter.displayValue}))
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 0)
    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{return}
        fetchData(keywordParam: text, shouldRemovePreviousData: true)
    }
}

extension ViewController: FilterCollectionViewCellDelegate{
    func shouldExecuteFilter(filter: Filter) {
        if activeFilters.contains(where: {$0.displayValue == filter.displayValue}){
            activeFilters.removeAll(where: {$0.displayValue == filter.displayValue})
            filterCollectionView.reloadData()
            fetchData(shouldRemovePreviousData: true)
        }else{
            activeFilters.append(filter)
            filterCollectionView.reloadData()
            fetchData(shouldRemovePreviousData: true)
        }
    }
    
    func changeSort(filter: Filter) {
        guard let index = filters.enumerated().first(where: {$0.element.displayValue == filter.displayValue})?.offset else{return}
        switch filter{
        case .nearMe:
            break
        case .distanceAscending(let isAscending):
            filters.remove(at: index)
            filters.insert(.distanceAscending(!isAscending), at: index)
            filterCollectionView.reloadData()
            tableView.reloadData()
        default:
            break
        }
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}
