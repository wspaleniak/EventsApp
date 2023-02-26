//
//  EventListViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import Foundation

// MARK: ViewModel zarządzający widokiem EventList
final class EventListViewModel {
    
    let title = "Events"
    var coordinator: EventListCoordinator?
    
    // Metoda wywoływana podczas naciśnięcia przycisku dodawania nowego eventu
    // Przekazuje działanie do kooordynatora
    func addEventBtnTapped() {
        coordinator?.startAddEvent()
    }
}
