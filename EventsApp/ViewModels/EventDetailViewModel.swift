//
//  EventDetailViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit
import CoreData

// MARK: - ViewModel zarządzający widokiem EventDetail
final class EventDetailViewModel {
    
    private let date = Date()
    private let eventID: NSManagedObjectID
    weak var coordinator: EventDetailCoordinator?
    private let coreDataManager: CoreDataManager
    private var event: Event?
    var onUpdate = {}
    
    var image: UIImage? {
        guard let imageData = event?.image else { return nil }
        return UIImage(data: imageData)
    }
    
    var timeRemainingViewModel: TimeRemainingViewModel? {
        guard let event = event,
              let eventDate = event.date else { return nil }
        var dates = date.timeRemaining(until: eventDate)?.components(separatedBy: ",") ?? []
        let lastComponents = dates.last?.components(separatedBy: " i ") ?? []
        dates.removeLast()
        let timeRemaining = dates + lastComponents
        return TimeRemainingViewModel(
            timeRemainingParts: timeRemaining,
            mode: .detail
        )
    }
    
    init(eventID: NSManagedObjectID, coreDataManager: CoreDataManager = .shared) {
        self.eventID = eventID
        self.coreDataManager = coreDataManager
    }
    
    // Metoda wywoływana podczas ładowania widoku kontrolera
    func viewDidLoad() {
        reload()
    }
    
    // Metoda wywoływana podczas kończenia widoku
    // Przekazuje działanie do kooordynatora
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func reload() {
        event = coreDataManager.getEvent(id: eventID)
        onUpdate()
    }
    
    @objc func editButtonTapped() {
        guard let event = event else { return }
        coordinator?.onEditEvent(event: event)
    }
}
