//
//  EventListViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import Foundation

// MARK: ViewModel zarządzający widokiem EventList
final class EventListViewModel {
    enum Cell {
        case event(EventCellViewModel)
    }
    
    let title = "Events"
    private(set) var cells: [Cell] = []
    var coordinator: EventListCoordinator?
    var onUpdate: () -> Void = {}   // pozwala odświeżyć tablicę zdefiniowaną w kontrolerze
    
    func viewDidLoad() {
        cells = [
            .event(EventCellViewModel()),
            .event(EventCellViewModel()),
            .event(EventCellViewModel())
        ]
        onUpdate()
    }
    
    // Metoda wywoływana podczas naciśnięcia przycisku dodawania nowego eventu
    // Przekazuje działanie do kooordynatora
    func addEventBtnTapped() {
        coordinator?.startAddEvent()
    }
    
    // Metoda zwraca ilość elementów w tablicy cells
    // Wywoływana podczas ustawiania właściwości TableView w kontrolerze
    func numberOfRows() -> Int {
        return cells.count
    }
    
    // Metoda zwracająca element z tablicy cells na podstawie IndexPath
    // Wywoływana podczas ustawiania właściwości TableView w kontrolerze
    func cell(for indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
}
