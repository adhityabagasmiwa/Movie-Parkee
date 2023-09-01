//
//  CoreDataStack.swift
//  Parkee
//
//  Created by Adhitya Bagas on 01/09/23.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private init() {
        
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieLocalDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    class func saveContext(completion: @escaping ((Result<Bool, DBError>) -> Void)) {
        let context = CoreDataStack.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(true))
            } catch {
                let nserror = error as NSError
                completion(.failure(.invalidSaveContext))
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
