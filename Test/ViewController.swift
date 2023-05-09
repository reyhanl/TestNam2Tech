//
//  ViewController.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var businesses: [BusinessModel] = []
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchData()
    }
    
    func setupUI(){
        title = "Businesses"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "BusinessTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    private func fetchData(){
        NetworkManager.shared.fetchBusiness(model: .init(location: "New York City", limit: 20, offset: currentPage * 20)) { result in
            switch result{
            case .success(let model):
                self.currentPage += 1
                print("model: \(model.businesses?.count)")
                self.businesses.append(contentsOf: model.businesses ?? [])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
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
        print(indexPath.row)
        if indexPath.row == businesses.count - 1{
            fetchData()
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
