//
//  EventListCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 22/02/2023.
//

import UIKit

// MARK: - Koordynator dla widoku Event List
// Z jego poziomu możemy odpalić kolejne koordynatory do innych okien aplikacji
final class EventListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Startowanie widoku EventList - wywołanie w AppCoordinator
    func start() {
        let eventListViewController = EventListViewController.instantiate()
        let eventListViewModel = EventListViewModel()
        eventListViewModel.coordinator = self
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
    
    // Usuwanie instancji widoku, gdy nie jest już używany (gdy widok zostaje zamknięty)
    func childDidFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
