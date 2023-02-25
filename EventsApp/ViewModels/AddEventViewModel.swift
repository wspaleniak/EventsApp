//
//  AddEventViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import Foundation

final class AddEventViewModel {
    
    var coordinator: AddEventCoordinator?
    
    func viewDidDisappear() {
        coordinator?.didFinishAddEvent()
    }
}
