//
//  EventListCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 22/02/2023.
//

import UIKit
import CoreData

// MARK: - Koordynator dla widoku Event List
// Z jego poziomu możemy odpalić kolejne koordynatory do innych okien aplikacji
final class EventListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    var onSaveEvent: () -> Void = {}
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Startowanie widoku EventList - wywołanie w AppCoordinator
    func start() {
        let eventListViewController = EventListViewController.instantiate()
        let eventListViewModel = EventListViewModel()
        eventListViewModel.coordinator = self
        onSaveEvent = eventListViewModel.reload
        eventListViewController.viewModel = eventListViewModel
        navigationController.setViewControllers([eventListViewController], animated: false)
    }
    
    // Startowanie widoku AddEvent - wywołanie w EventListViewModel
    func startAddEvent() {
        let addEventCoordinator = AddEventCoordinator(navigationController: navigationController)
        addEventCoordinator.parentCoordinator = self
        childCoordinators.append(addEventCoordinator)
        addEventCoordinator.start()
    }
    
    // Wywołanie metody po kliknięciu w wybrane wydarzenie na EventList
    func onSelect(id: NSManagedObjectID) {
        let eventDetailCoordinator = EventDetailCoordinator(navigationController: navigationController, eventID: id)
        eventDetailCoordinator.parentCoordinator = self
        childCoordinators.append(eventDetailCoordinator)
        eventDetailCoordinator.start()
    }
    
    // Usuwanie instancji widoku, gdy nie jest już używany (gdy widok zostaje zamknięty)
    func childDidFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
    
}
