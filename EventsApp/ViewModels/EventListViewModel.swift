//
//  EventListViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import Foundation

final class EventListViewModel {
    
    let title = "Events"
    var coordinator: EventListCoordinator?
    
    func addEventBtnTapped() {
        coordinator?.startAddEvent()
    }
}
