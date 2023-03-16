//
//  EventDetailCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit
import CoreData

// MARK: - Koordynator dla widoku Event Detail
final class EventDetailCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    private let eventID: NSManagedObjectID
    var parentCoordinator: EventListCoordinator?
    var onUpdateEvent = {}
    
    init(navigationController: UINavigationController, eventID: NSManagedObjectID) {
        self.navigationController = navigationController
        self.eventID = eventID
    }
    
    // Startowanie widoku Event Detail - wywołanie w EventListCoordinator w funkcji onSelect(...)
    func start() {
        let eventDetailViewController = EventDetailViewController.instantiate()
        let eventDetailViewModel = EventDetailViewModel(eventID: eventID)
        eventDetailViewModel.coordinator = self
        onUpdateEvent = {
            eventDetailViewModel.reload()
            self.parentCoordinator?.onUpdateEvent()
        }
        eventDetailViewController.viewModel = eventDetailViewModel
        navigationController.pushViewController(eventDetailViewController, animated: true)
    }
    
    // Kończenie działania danego widoku - wywołanie w EventDetailViewModel
    func didFinish() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
    
    func childDidFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
    
    // Wywołanie fukncji w momencie naciśnięcua przycisku edycji wydarzenia
    func onEditEvent(event: Event) {
        let editEventCoordinator = EditEventCoordinator(navigationController: navigationController, event: event)
        editEventCoordinator.parentCoordinator = self
        childCoordinators.append(editEventCoordinator)
        editEventCoordinator.start()
    }
}
