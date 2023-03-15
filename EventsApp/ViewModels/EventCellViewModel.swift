//
//  EventCellViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 05/03/2023.
//

import UIKit
import CoreData

struct EventCellViewModel {
    
    private let date = Date()
    
    private let imageQueue = DispatchQueue(label: "imageQueue", qos: .background)
    
    // przechowywanie obrazów z CoreData dla szybszego ładowania
    private static let imageCache = NSCache<NSString, UIImage>()
    private var cacheKey: String {
        return event.objectID.description
    }
    
    var onSelect: (NSManagedObjectID) -> Void = { _ in }
    
    var timeRemainingViewModel: TimeRemainingViewModel? {
        guard let eventDate = event.date else { return nil }
        var dates = date.timeRemaining(until: eventDate)?.components(separatedBy: ",") ?? []
        let lastComponents = dates.last?.components(separatedBy: " i ") ?? []
        dates.removeLast()
        let timeRemaining = dates + lastComponents
        return TimeRemainingViewModel(
            timeRemainingParts: timeRemaining,
            mode: .cell
        )
    }
    
    private let event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    var dateText: String? {
        guard let eventDate = event.date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: eventDate)
    }
    
    var eventName: String? {
        return event.name
    }
    
    // Metoda sprawdza czy dane zdjęcie jest przechowywane w imageCache
    // Jeśli jest to pobiera image.data z imageCache
    // Jeśli nie to pobiera klasycznie z CoreData
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        if let image = Self.imageCache.object(forKey: cacheKey as NSString) {
            completion(image)
        } else {
            // wykonujemy w tle
            imageQueue.async {
                guard let imageData = self.event.image,
                      let image = UIImage(data: imageData) else {
                    completion(nil)
                    return
                }
                // dodajemy zdjęcie do imageCache
                Self.imageCache.setObject(image, forKey: self.cacheKey as NSString)
                // wykonujemy na głównym wątku
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    func didSelect() {
        onSelect(event.objectID)
    }
}
