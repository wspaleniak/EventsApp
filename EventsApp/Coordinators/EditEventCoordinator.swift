//
//  EditEventCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit

// MARK: - Koordynator dla widoku EditEvent
final class EditEventCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let event: Event
    
    // Określa kooordynator rodzica, czyli koordynator, który go wywyołał
    var parentCoordinator: EventDetailCoordinator?
    
    // Zdefiniowanie domknięcia dla przypisywania wybranego przez usera zdjęcia do cellki
    private var completion: (UIImage) -> Void = { _ in }
    
    init(navigationController: UINavigationController, event: Event) {
        self.navigationController = navigationController
        self.event = event
    }
    
    //
    func start() {
        let editEventViewController = EditEventViewController.instantiate()
        let editEventViewModel = EditEventViewModel(cellBuilder: EventsCellBuilder(), event: event)
        editEventViewModel.coordinator = self
        editEventViewController.viewModel = editEventViewModel
        navigationController.pushViewController(editEventViewController, animated: true)
    }
    
    // Kończenie działania danego widoku - wywołanie w EditEventViewModel
    func didFinish() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
    
    // Kończenie widoku gdy klikniemy przycisk 'Done' na widoku EditEvent
    // Metoda wywoływana w EditEventViewModel
    func didFinishUpdateEvent() {
        parentCoordinator?.onUpdateEvent()
        navigationController.popViewController(animated: true)
    }
    
    // Startowanie widoku ImagePicker - wywołanie w AddEventViewModel
    func showImagePicker(completion: @escaping (UIImage) -> Void) {
        self.completion = completion
        let imagePickerCoordinator = ImagePickerCoordinator(navigationController: navigationController)
        imagePickerCoordinator.parentCoordinator = self
        imagePickerCoordinator.onFinishPicking = { image in
            completion(image)
            self.navigationController.dismiss(animated: true)
        }
        childCoordinators.append(imagePickerCoordinator)
        imagePickerCoordinator.start()
    }
}
