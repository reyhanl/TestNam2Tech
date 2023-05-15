//
//  CoreDataManager.swift
//  Test
//
//  Created by reyhan muhammad on 15/05/23.
//

import CoreData
import UIKit

class CoreDataManager{
    static var shared = CoreDataManager()
    
    static var delegate: AppDelegate?{
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return delegate
    }
    let managedContext = delegate?.persistentContainer.viewContext
    
    func getAllData<T: Decodable>(_ : T.Type, from entity: String) -> Result<T, Error>{
        guard let managedContext = managedContext else{return .failure(CustomError.fetchFromCoreDataError)}
        let entityObj = NSEntityDescription.entity(forEntityName: entity, in: managedContext)
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: entity)
        
        do {
            let businesses = try managedContext.fetch(fetchRequest)
            guard let entityObj = entityObj?.attributesByName else{return.failure(CustomError.fetchFromCoreDataError)}
            let dict = businesses.map({$0.toDict()})
            let decoder = JSONDecoder()
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let model = try decoder.decode(T.self, from: jsonData)
            return .success(model)
        } catch let error as NSError {
            return .failure(error)
        }
    }
    
    func removeAllData(from entity: String){
        guard let managedContext = managedContext else{return}
        let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)
        //TODO: Find a way to remove all entities
    }
    
    func insertData(_ model: [String:Any], to entity: String){
        guard let managedContext = managedContext else{return}
        let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)
        entity?.setValuesForKeys(model)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(String(describing: error))
        }
    }
}
