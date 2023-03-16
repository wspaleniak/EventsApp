//
//  CoreDataManager.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 22/02/2023.
//

import UIKit
import CoreData

// MARK: - Manager do zarządzania elementami bazy danych Core Data
final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "EventsApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return persistentContainer
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Metoda dla pobierania wybranego elementu z bazy danych
    func get<T: NSManagedObject>(id: NSManagedObjectID) -> T? {
        do {
            return try managedObjectContext.existingObject(with: id) as? T
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // Metoda dla pobierania wszystkich elementów z bazy danych
    func getAll<T: NSManagedObject>() -> [T] {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    // Metoda do zapisywania elementów do bazy danych
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
