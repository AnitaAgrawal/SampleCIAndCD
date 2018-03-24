//
//  CoreDataHandler.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit
import CoreData

class DatabaseHandler: NSObject {

    static let sharedDatabaseHandler = DatabaseHandler()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext:NSManagedObjectContext?
    
    override init()
    {
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    public func insertDataInToDb(dataAry:[[String : Any]]) -> Bool
    {
        let entity = NSEntityDescription.entity(forEntityName:"UserData", in: managedContext!)
        
        var i = 1
        
        for dataDic:[String : Any]  in dataAry
        {
                let userDetails : UserData = (NSManagedObject(entity: entity!,insertInto: managedContext) as? UserData)!
                userDetails.company = dataDic["company_name"] as! String?
                userDetails.details = dataDic["details"] as! String?
                userDetails.email = dataDic["email"] as! String?
                userDetails.firstName = dataDic["first_name"] as! String?
                userDetails.gender = dataDic["gender"] as! String?
                userDetails.guid = dataDic["id"] as! String?
                userDetails.imageUrl = dataDic["image"] as! String?
                userDetails.lastName = dataDic["last_name"] as! String?
                userDetails.latitude = dataDic["lat"] as! String? ?? "0"
                userDetails.longitude = dataDic["lon"] as! String? ?? "0"
                userDetails.rowId = Int64(i)
                
                i += 1
            }
        do {
            try managedContext?.save()
        }
        catch let error as NSError {
            print("Could not complete the task \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    public func fetchTheDataFromDb(searchStr:String ,sortBy:String , ascendingOrder : Bool, totalCount:Int , startingFrom:Int) -> [UserData] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        
        if totalCount != 0 {
            fetchRequest.fetchLimit = totalCount
            fetchRequest.fetchOffset = startingFrom
        }
        
        let sortDescripter = NSSortDescriptor.init(key:sortBy, ascending:ascendingOrder)
        
        if searchStr != ""
        {
            let firstNamePredicate = NSPredicate(format:"firstName CONTAINS[cd] %@",searchStr as CVarArg)
            let lastNamePredicate = NSPredicate(format:"lastName CONTAINS[cd] %@",searchStr as CVarArg)
            let detailsPredicate = NSPredicate(format:"details CONTAINS[cd] %@",searchStr as CVarArg)
            
            let orPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates:[firstNamePredicate,lastNamePredicate,detailsPredicate])
            
            fetchRequest.predicate = orPredicate
        }
        
        fetchRequest.sortDescriptors = [sortDescripter]
        
        do {
            let results = try managedContext?.fetch(fetchRequest)
            return results as! [UserData]
        }
        catch let error as NSError {
            print("Could not complete the task \(error), \(error.userInfo)")
            return []
        }
    }
    
    public func fetchTheDataFromDb(rowId:Int) -> UserData {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        
        let rowIdPredicate = NSPredicate(format:"rowId == %i",rowId)
        
        fetchRequest.predicate = rowIdPredicate
        
        do {
            let results = try managedContext?.fetch(fetchRequest)
            return results?.last as? UserData ?? self.fetchTheDataFromDb(rowId:-1)
        }
        catch let error as NSError {
            print("Could not complete the task \(error), \(error.userInfo)")
            return UserData()
        }
    }

}
