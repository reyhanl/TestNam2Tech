//
//  FavoritesViewController.swift
//  Test
//
//  Created by reyhan muhammad on 15/05/23.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var objects: [BusinessModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "FavoritesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    func fetchData(){
        let result = CoreDataManager.shared.getAllData([BusinessModel].self, from: "Business")
        switch result{
        case .success(let businesses):
            self.objects = businesses
        case .failure(let error):
            print()
        }
        updateData()
    }
    
    func updateData(){
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
}
