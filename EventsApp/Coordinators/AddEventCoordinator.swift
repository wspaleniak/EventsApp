//
//  AddEventCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import UIKit

// MARK: - Koordynator dla widoku Add Event
final class AddEventCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    // Określa kooordynator rodzica, czyli koordynator, który go wywyołał
    // Przypisywany w EventListCoordinator w metodzie startAddEvent()
    var parentCoordinator: EventListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Startowanie widoku AddEvent - wywołania w EventListCoordinator w metodzie startAddEvent()
    func start() {
        let modalNavigationController = UINavigationController()
        let addEventViewController = AddEventViewController.instantiate()
        let addEventViewModel = AddEventViewModel()
        addEventViewModel.coordinator = self
        addEventViewController.viewModel = addEventViewModel
        modalNavigationController.setViewControllers([addEventViewController], animated: false)
        navigationController.present(modalNavigationController, animated: true)
    }
    
    // Kończenie działania danego widoku - wywołanie w AddEventViewModel
    func didFinishAddEvent() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
}
