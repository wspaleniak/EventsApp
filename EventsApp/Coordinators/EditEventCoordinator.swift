//
//  EditEventCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit

protocol EventUpdatingCoordinator {
    var onUpdateEvent: () -> Void { get }
}

// MARK: - Koordynator dla widoku EditEvent
final class EditEventCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    private let event: Event
    
    // Określa kooordynator rodzica, czyli koordynator, który go wywyołał
    var parentCoordinator: (EventUpdatingCoordinator & Coordinator)?
    
    // Zdefiniowanie domknięcia dla przypisywania wybranego przez usera zdjęcia do cellki
    private var completion: (UIImage) -> Void = { _ in }
    
    init(navigationController: UINavigationController, event: Event) {
        self.navigationController = navigationController
        self.event = event
    }
    
    //
    func start() {
        self.modalNavigationController = UINavigationController()
        let editEventViewController = EditEventViewController.instantiate()
        let editEventViewModel = EditEventViewModel(cellBuilder: EventsCellBuilder(), event: event)
        editEventViewModel.coordinator = self
        editEventViewController.viewModel = editEventViewModel
        modalNavigationController?.setViewControllers([editEventViewController], animated: false)
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    // Kończenie działania danego widoku - wywołanie w EditEventViewModel
    func didFinish() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
    
    // Kończenie widoku gdy klikniemy przycisk 'Done' na widoku EditEvent
    // Metoda wywoływana w EditEventViewModel
    func didFinishUpdateEvent() {
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
