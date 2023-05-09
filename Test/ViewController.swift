//
//  ViewController.swift
//  Test
//
//  Created by reyhan muhammad on 09/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var businesses: [BusinessModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "BusinessTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    private func fetchData(){
        NetworkManager.shared.fetchBusiness(model: .init(location: "New York City", limit: 20)) { result in
            switch result{
            case .success(let model):
                print("model: \(model.businesses?.count)")
                self.businesses = model.businesses ?? []
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
}
