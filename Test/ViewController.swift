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
    
    private var businesses: [BusinessModel] = []
    private var currentPage: Int = 0
    private var searchController: UISearchController?
    private var filters: [Filter] = [
        .nearMe, .cheap, .quiteCheap, .expensive, .superExpensive
    ]
    private var locationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D?{
        didSet{
            //Since user's location is always going to be updated, we want to make sure that we only fetch data on the begining.
            if oldValue == nil{
                fetchData()
            }
        }
    }
    private var activeFilters: [Filter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCollectionView()
        navigationController?.navigationBar.prefersLargeTitles = true
        setLocationManager()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupUI(){
        setupNavigationBar()
        setupScrollToTop()
    }
    
    private func setLocationManager(){
        location = .init(latitude: CLLocationDegrees(40.714868), longitude: CLLocationDegrees(-73.997006))
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //FIXME: Uncomment if you want to use user's real location
        //Commented because in Indonesia you would get no business around your area whatsoever.
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
    }
    
    private func setupNavigationBar(){
        title = "Businesses"
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController?.searchResultsUpdater = self
    }
    
    private func setupScrollToTop(){
        scrollToTopButton.backgroundColor = .blue
        scrollToTopButton.addGestureRecognizer(target: self, selector: #selector(scrollToTop))
        scrollToTopButton.layer.cornerRadius = scrollToTopButton.frame.width / 2
    }
    
    private func setupCollectionView(){
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
        var sortBy = "best_match" //will be replace by distance if Near Me filter Active
        
        keyword = getKeyword()
        getFilter()
        if shouldRemovePreviousData{
            currentPage = 0
        }
        
        let location = location
        let longitude: Float? = location?.longitude == nil ? nil:Float(location?.longitude ?? 0)
        let latitude: Float? = location?.latitude == nil ? nil:Float(location?.latitude ?? 0)
        
        let model = QueryModel.init(
                                latitude: latitude,
                                longitude: longitude,
                                term: keyword,
                                price: priceFilter,
                                sortBy: sortBy,
                                limit: 20,
                                offset: currentPage * 20)
        NetworkManager.shared.fetchBusiness(model: model) { [weak self] result in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.currentPage += 1
                DispatchQueue.main.async {
                    if shouldRemovePreviousData{
                        self.businesses =  model.businesses ?? []
                        self.tableView.reloadData()
                    }else{
                        let businesses = model.businesses ?? []
                        let minIndex = self.businesses.count
                        let maxIndex = minIndex + businesses.count
                        print(minIndex, maxIndex)
                        let indexPaths = (minIndex..<maxIndex).map({IndexPath(row: $0, section: 0)})
                        
                        self.businesses.append(contentsOf: businesses)
                        self.tableView.performBatchUpdates {
                            self.tableView.insertRows(at: indexPaths, with: .automatic)
                        }
                    }
                }
            case .failure(_):
                break
            }
        }
        
        func getKeyword() -> String?{
            if keywordParam == nil, let text = searchController?.searchBar.text, text != ""{
                keyword = text
            }else if keywordParam != nil{
                keyword = keywordParam
            }
            return keyword
        }
        
        func getFilter(){
            for filter in activeFilters{
                if [Filter.cheap, .quiteCheap, .expensive, .superExpensive].contains(where: {$0.displayValue == filter.displayValue}){
                    //$ = 1, $$ = 2, $$$ = 3, $$$$ = 4
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
        }
    }
    
    @objc private func scrollToTop(){
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController(nibName: "DetailViewController", bundle: nil)
        vc.setupUI(id: businesses[indexPath.row].id ?? "")
        self.navigationController?.pushViewController(vc, animated: true)
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
//        URLSession.shared.invalidateAndCancel()
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
