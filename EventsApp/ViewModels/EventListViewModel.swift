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
    private let coreDataManager: CoreDataManager
    var coordinator: EventListCoordinator?
    var onUpdate: () -> Void = {}   // pozwala odświeżyć tablicę zdefiniowaną w kontrolerze
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func viewDidLoad() {
        reload()
    }
    
    // Wykonywanie tej funkcji przypisujemy w kooordynatorze, gdy jego dziecko skończy działanie
    func reload() {
        let events = coreDataManager.fetchEvents()
        cells = events.map {
            .event(EventCellViewModel(event: $0))
        }
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
