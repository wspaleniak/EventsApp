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
    private var modalNavigationController: UINavigationController?
    
    // Określa kooordynator rodzica, czyli koordynator, który go wywyołał
    // Przypisywany w EventListCoordinator w metodzie startAddEvent()
    var parentCoordinator: (EventUpdatingCoordinator & Coordinator)?
    
    // Zdefiniowanie domknięcia dla przypisywania wybranego przez usera zdjęcia do cellki
    private var completion: (UIImage) -> Void = { _ in }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Startowanie widoku AddEvent - wywołania w EventListCoordinator w metodzie startAddEvent()
    func start() {
        self.modalNavigationController = UINavigationController()
        let addEventViewController = AddEventViewController.instantiate()
        let addEventViewModel = AddEventViewModel(cellBuilder: EventsCellBuilder())
        addEventViewModel.coordinator = self
        addEventViewController.viewModel = addEventViewModel
        modalNavigationController?.setViewControllers([addEventViewController], animated: false)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    // Kończenie działania danego widoku - wywołanie w AddEventViewModel
    func didFinish() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
    
    // Kończenie widoku gdy klikniemy przycisk 'Done' na widoku AddEvent
    // Metoda wywoływana w AddEventViewModel
    func didFinishSaveEvent() {
        parentCoordinator?.onUpdateEvent()
        navigationController.dismiss(animated: true)
    }
    
    // Startowanie widoku ImagePicker - wywołanie w AddEventViewModel
    func showImagePicker(completion: @escaping (UIImage) -> Void) {
        guard let modalNavigationController = modalNavigationController else { return }
        self.completion = completion
        let imagePickerCoordinator = ImagePickerCoordinator(navigationController: modalNavigationController)
        imagePickerCoordinator.parentCoordinator = self
        imagePickerCoordinator.onFinishPicking = { image in
            completion(image)
            self.modalNavigationController?.dismiss(animated: true)
        }
        childCoordinators.append(imagePickerCoordinator)
        imagePickerCoordinator.start()
    }
    
    // Usuwanie instancji widoku, gdy nie jest już używany (gdy widok zostaje zamknięty)
    func childDidFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
