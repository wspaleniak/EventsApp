//
//  ImagePickerCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 05/03/2023.
//

import UIKit

final class ImagePickerCoordinator: NSObject, Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    var parentCoordinator: AddEventCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        navigationController.present(imagePickerController, animated: true)
    }
}

// Rozszerzenie dla ImagePicker
extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            parentCoordinator?.didFinishPicking(image: image)
        }
        parentCoordinator?.childDidFinish(childCoordinator: self)
    }
    
    
}
