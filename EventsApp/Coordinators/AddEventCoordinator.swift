//
//  AddEventCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import UIKit

final class AddEventCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    var parentCoordinator: EventListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let addEventViewController = AddEventViewController.instantiate()
        let addEventViewModel = AddEventViewModel()
        addEventViewModel.coordinator = self
        addEventViewController.viewModel = addEventViewModel
        navigationController.present(addEventViewController, animated: true)
    }
    
    func didFinishAddEvent() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
}
