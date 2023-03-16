//
//  EventService.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 16/03/2023.
//

import UIKit
import CoreData

// MARK: - Protokół dla określenia potrzebnych metod w ewentualnych innych serwisach
protocol EventServiceProtocol {
    func perform(action: EventService.EventAction, data: EventService.EventInputData)
    func getEvent(id: NSManagedObjectID) -> Event?
    func getAllEvents() -> [Event]
    func deleteEvent(id: NSManagedObjectID)
}

// MARK: - EventService dla pobierania eventów
final class EventService: EventServiceProtocol {
    // Enum dla wyboru akcji, którą chcemy wykonać
    enum EventAction {
        case add
        case update(Event)
    }
    
    // Struktura dla łatwiejszego przekazywania danych
    struct EventInputData {
        let name: String
        let date: Date
        let image: UIImage
    }
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Dodawanie nowego elementu do bazy danych lub aktualizacja istniejącego
    func perform(action: EventAction, data: EventInputData) {
        var event: Event
        switch action {
        case .add:
            event = Event(context: coreDataManager.managedObjectContext)
        case .update(let eventToUpdate):
            event = eventToUpdate
        }
        event.setValue(data.name, forKey: "name")
        event.setValue(data.date, forKey: "date")
        let resizedImage = data.image.sameAspectRatio(newHeight: 250.0)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        coreDataManager.save()
    }
    
    // Pobieranie wybranego elementu z bazy danych
    func getEvent(id: NSManagedObjectID) -> Event? {
        return coreDataManager.get(id: id)
    }
    
    // Pobieranie wszystkich elementów z bazy danych
    func getAllEvents() -> [Event] {
        return coreDataManager.getAll()
    }
    
    // Metoda do usuwania wybranego elementu z bazy danych
    func deleteEvent(id: NSManagedObjectID) {
        guard let event = coreDataManager.get(id: id) as? Event else { return }
        coreDataManager.managedObjectContext.delete(event)
        coreDataManager.save()
    }
}
