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
    
    // Metoda do zapisywania elementów do bazy danych
    func saveEvent(name: String, date: Date, image: UIImage) {
        let event = Event(context: managedObjectContext)
        event.setValue(name, forKey: "name")
        event.setValue(date, forKey: "date")
        // zmniejszenie wielkości zapisywanego zdjęcia
        let resizedImage = image.sameAspectRatio(newHeight: 250)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getEvent(id: NSManagedObjectID) -> Event? {
        do {
            return try managedObjectContext.existingObject(with: id) as? Event
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // Metoda do odczytywania elementów z bazy danych
    func fetchEvents() -> [Event] {
        do {
            let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
            let events = try managedObjectContext.fetch(fetchRequest)
            return events
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
