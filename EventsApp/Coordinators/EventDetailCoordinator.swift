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
    
    init(navigationController: UINavigationController, eventID: NSManagedObjectID) {
        self.navigationController = navigationController
        self.eventID = eventID
    }
    
    // Startowanie widoku Event Detail - wywołanie w EventListCoordinator w funkcji onSelect(...)
    func start() {
        let eventDetailViewController = EventDetailViewController.instantiate()
        let eventDetailViewModel = EventDetailViewModel(eventID: eventID)
        eventDetailViewModel.coordinator = self
        eventDetailViewController.viewModel = eventDetailViewModel
        navigationController.pushViewController(eventDetailViewController, animated: true)
    }
    
    // Kończenie działania danego widoku - wywołanie w EventDetailViewModel
    func didFinish() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
}
